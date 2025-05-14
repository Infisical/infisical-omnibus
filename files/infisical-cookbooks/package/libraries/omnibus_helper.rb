require 'fileutils'
require 'mixlib/shellout'
require_relative 'helper'

class OmnibusHelper
  include ShellOutHelper
  attr_reader :node

  def initialize(node)
    @node = node
  end

  def service_dir_enabled?(service_name)
    File.symlink?("/opt/infisical-core/service/#{service_name}")
  end

  def should_notify?(service_name)
    service_dir_enabled?(service_name) && service_up?(service_name) && service_enabled?(service_name)
  end

  def not_listening?(service_name)
    return true unless service_enabled?(service_name)

    service_down?(service_name)
  end

  def service_enabled?(service_name)
    node_attribute_key = SettingsDSL::Utils.node_attribute_key(service_name)
    # TODO(akhilmhdh): Understand this and make this change
    # As part of https://gitlab.com/gitlab-org/omnibus-gitlab/issues/2078 services are
    # being split to their own dedicated cookbooks, and attributes are being moved from
    # node['infisical'][service_name] to node[service_name]. Until they've been moved, we
    # need to check both.
    # return node['monitoring'][node_attribute_key]['enable'] if node['monitoring'].key?(node_attribute_key)
    # return node['infisical'][node_attribute_key]['enable'] if node['infisical'].key?(node_attribute_key)

    node[node_attribute_key]['enable']
  end

  def service_up?(service_name)
    success?("/opt/infisical-core/init/#{service_name} status")
  end

  def service_down?(service_name)
    failure?("/opt/infisical-core/init/#{service_name} status")
  end

  def is_managed_and_offline?(service_name)
    service_enabled?(service_name) && service_down?(service_name)
  end

  def user_exists?(username)
    success?("id -u #{username}")
  end

  def group_exists?(group)
    success?("getent group #{group}")
  end

  def expected_user?(file, user)
    File.stat(file).uid == Etc.getpwnam(user).uid
  end

  def expected_group?(file, group)
    File.stat(file).gid == Etc.getgrnam(group).gid
  end

  def expected_owner?(file, user, group)
    expected_user?(file, user) && expected_group?(file, group)
  end

  # Checks whether a specific resource exist in runtime
  #
  # @example usage
  #   omnibus_helper.resource_available?('runit_service[postgresql]')
  #
  # @param [String] name of the resource
  # @return [Boolean]
  def resource_available?(name)
    node.run_context.resource_collection.find(name)

    true
  rescue Chef::Exceptions::ResourceNotFound
    false
  end

  def self.utf8_variable?(var)
    ENV[var]&.downcase&.include?('utf-8') || ENV[var]&.downcase&.include?('utf8')
  end

  def self.valid_variable?(var)
    !ENV[var].nil? && !ENV[var].empty?
  end

  def self.on_exit
    LoggingHelper.report
  end

  def self.deprecated_os_list
    # This hash follows the format `'ohai-slug' => 'EOL version'
    # example: deprecated_os = { 'raspbian-8' => 'GitLab 11.8' }
    {
      'opensuseleap-15.4' => 'GitLab 16.8',
      'ubuntu-18.04' => 'GitLab 17.0',
      'debian-10' => 'GitLab 17.6',
      'centos-7' => 'GitLab 17.6'
    }
  end

  def self.get_raw_current_version
    return unless File.exist?('/opt/infisical-core/version-manifest.json')

    version_manifest = JSON.parse(File.read('/opt/infisical-core/version-manifest.json'))
    version_manifest['build_version']
  end

  def self.parse_current_version
    return unless File.exist?('/opt/infisical-core/version-manifest.json')

    version_manifest = JSON.parse(File.read('/opt/infisical-core/version-manifest.json'))
    version_components = version_manifest['build_version'].split('.')
    version_components[0, 2].join('.')
  end

  def self.check_environment
    ENV['LD_LIBRARY_PATH'] && LoggingHelper.warning('LD_LIBRARY_PATH was found in the env variables, this may cause issues with linking against the included libraries.')
  end

  def restart_service_resource(service)
    "runit_service[#{service}]"
  end
end
