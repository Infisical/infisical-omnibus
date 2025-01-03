#
# Copyright:: Copyright (c) 2017 GitLab Inc.
# Copyright:: Copyright (c) 2024 Infisical
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Modifications made by Infisical, 2024
# - Updated the code to align with Infisical's requirements

require 'mixlib/config'
require 'chef/json_compat'
require 'chef/mixin/deep_merge'
require 'securerandom'
require 'uri'

require_relative 'config_mash'

module SettingsDSL
  def self.extended(base)
    # Setup getter/setters for roles and settings
    class << base
      attr_accessor :available_roles, :settings
    end

    base.available_roles = {}
    base.settings = {}
  end

  # Change the default root location for node attributes
  # Pass in the root (ie 'infisical') and a block containing the attributes that should
  # use that root.
  # ex:
  #   attribute_block('example') do
  #     attribute('some_attribute')
  #   end
  #   This will convert Infisical['some_attribute'] to node['example']['some-attribute']
  def attribute_block(root = nil)
    return unless block_given?

    begin
      @_default_parent = root
      yield
    ensure
      @_default_parent = nil
    end
  end

  # Create a new role with the given 'name' config
  # config options are:
  #  manage_services - Boolean to indicate whether the role enables/disables services. Defaults to enabled.
  #                    If enabled, the default service role is disabled when using a different role that manages services
  # Roles are configured as Infisical['<name>_role'] and are added to the node as node['roles']['<name>']
  # ex: some_specific_role['enable'] = true
  #     will result in Infisical['some_specific_role']['enable'] = true
  #     and node['roles']['some-specific']['enable'] = true
  def role(name, **config)
    @available_roles[name] = HandledHash.new.merge!(
      { manage_services: true }
    ).merge(config)
    send("#{name}_role", Infisical::ConfigMash.new)
    @available_roles[name]
  end

  # Create a new attribute with the given 'name' and config
  #
  # config options are:
  #  parent   - String name for the root node attribute, default can be specified using the attribute_block method
  #  priority - Integer used to sort the settings when applying them, defaults to 20, similar to sysvinit startups. Lower numbers are loaded first.
  #  ee       - Boolean to indicate that the variable should only be used in GitLab EE
  #  default  - Default value to set for the Infisical Config. Defaults to Infisical::ConfigMash.new, should be set to nil config expecting non hash values
  #
  # ex: attribute('some_attribute', parent: 'infisical', sequence: 10, default: nil)
  #     will right away set Infisical['some_attribute'] = nil
  #     and when the config is generated it will set node['infisical']['some-attribute'] = nil
  def attribute(name, **config)
    @settings[name] = HandledHash.new.merge!(
      { parent: @_default_parent, priority: 20, ee: false, default: Infisical::ConfigMash.new }
    ).merge(config)

    send(name.to_sym, @settings[name][:default])
    @settings[name]
  end

  # Same as 'attribute' but defaults 'enable' to false if the InfisicalEE module is unavailable
  def ee_attribute(name, **config)
    config = { ee: true }.merge(config)
    attribute(name, **config)
  end

  def from_file(_file_path)
    # Throw errors for unrecognized top level calls (usually spelling mistakes)
    config_strict_mode true
    # Turn on node deprecation messages
    # Allow auto mash creation during from_file call
    Infisical::ConfigMash.auto_vivify { super }
  ensure
    config_strict_mode false
  end

  # Enhance set so strict mode errors aren't thrown as long as the setting is witin our defined config
  def internal_set(symbol, value)
    if configuration.key?(symbol)
      configuration[symbol] = value
    else
      super
    end
  end

  # Enhance get so strict mode errors aren't thrown as long as the setting is witin our defined config
  def internal_get(symbol)
    if configuration.key?(symbol)
      configuration[symbol]
    else
      super
    end
  end

  def sanitized_config
    results = { 'infisical' => {}, 'roles' => {} }

    # Add the settings to the results
    sorted_settings.each do |key, value|
      if value[:parent] && !results.key?(value[:parent])
        raise "Attribute parent value invalid for key: #{key} (#{value})"
      end

      target = value[:parent] ? results[value[:parent]] : results

      target[Utils.node_attribute_key(key)] = Infisical[key]
    end

    # Add the roles the the results
    @available_roles.each do |key, _value|
      results['roles'][Utils.node_attribute_key(key)] = Infisical["#{key}_role"]
    end

    results
  end

  def load_roles
    # System services are enabled by default
    Services.enable_group(Services::SYSTEM_GROUP)
    RolesHelper.parse_enabled

    # Load our roles
    DefaultRole.load_role
    @available_roles.each do |_key, value|
      handler = value.handler
      handler.load_role if handler.respond_to?(:load_role)
    end
  end

  def generate_config
    load_roles
    # Parse all our variables using the handlers
    sorted_settings.each do |_key, value|
      handler = value.handler
      handler.parse_variables if handler.respond_to?(:parse_variables)
    end

    strip_nils(sanitized_config)
  end

  def strip_nils(attributes)
    results = {}
    attributes.each_pair do |key, value|
      next if value.nil?

      recursive_classes = [Hash, Infisical::ConfigMash, ChefUtils::Mash]
      results[key] = if recursive_classes.include?(value.class)
                       strip_nils(value)
                     else
                       value
                     end
    end
    results
  end

  # Merge provided role and value set if value is defined
  #
  # @param [String] role
  # @param [String] value
  def override_role!(role, value)
    return if value.nil?

    Infisical::ConfigMash.auto_vivify do
      self[role]['enable'] = value
    end
  end

  private

  # Sort settings by their sequence value
  def sorted_settings
    @settings.select { |_k, value| !value[:ee] || Infisical['edition'] == :ee }.sort_by { |_k, value| value[:priority] }
  end

  # Custom Hash object used to add a handler as a block to the attribute
  class HandledHash < Hash
    attr_writer :handler

    def use(&block)
      @handler = block
      self
    end

    def handler
      @handler = @handler.call if @handler.respond_to?(:call)
      @handler
    end
  end

  class Utils
    class << self
      # In service names, words are seperated with a hyphen
      def service_name(service)
        service.tr('_', '-')
      end

      # Node attributes corresponding to a service are formatted by replacing
      # hyphens in the service names with underscores
      def node_attribute_key(service)
        service.tr('-', '_')
      end
    end
  end
end
