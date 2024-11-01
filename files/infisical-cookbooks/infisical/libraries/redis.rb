#
# Copyright:: Copyright (c) 2016 GitLab Inc.
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

require 'open3'

require_relative 'redis_uri'
require_relative '../../package/libraries/helpers/redis_helper/infisical_core'

module Redis
  CommandExecutionError = Class.new(StandardError)

  class << self
    def parse_variables
      parse_redis_settings
      parse_redis_sentinel_settings
      parse_rename_commands
      populate_extra_config
    end

    def parse_redis_settings
      redis_helper = RedisHelper::Base
      # node['redis'] need not reflect user's choice accurately here, since we
      # also set redis['port'] programmatically, and hence can't depend on it.
      # So we specify Infisical['redis'] as the config to use.
      if redis_helper.redis_server_over_tcp?(config: Infisical['redis'])
        # The user wants Redis to listen via TCP instead of unix socket.
        Infisical['redis']['unixsocket'] = false

        parse_redis_bind_address
        # Try to discover infisical_core redis connection params
        # based on redis daemon
        parse_redis_daemon! unless redis_helper.has_sentinels?(config: Infisical['infisical_core'])
      end

      Infisical['redis']['master'] = false if redis_helper.redis_replica_role?

      # When announce-ip is defined and announce-port not, infer the later from the main redis_port
      # This functionality makes sense for redis replicas but with sentinel, the redis role can swap
      # We introduce the option regardless the user defined de redis node as master or replica
      Infisical['redis']['announce_port'] ||= Infisical['redis']['port'] if Infisical['redis']['announce_ip']

      if redis_managed? && (redis_helper.sentinel_daemon_enabled? || redis_helper.redis_replica?(config: Infisical['redis']) || redis_helper.redis_master_role?)
        Infisical['redis']['master_password'] ||= Infisical['redis']['password']
      end

      return unless redis_helper.sentinel_daemon_enabled? || redis_helper.redis_replica?(config: Infisical['redis'])

      raise "redis 'master_ip' is not defined" unless Infisical['redis']['master_ip']
      raise "redis 'master_password' is not defined" unless Infisical['redis']['master_password']
    end

    def parse_redis_sentinel_settings
      redis_helper = RedisHelper::InfisicalCore
      return unless redis_helper.sentinel_daemon_enabled?

      Infisical['infisical_core']['redis_sentinels_password'] ||= Infisical['sentinel']['password']

      redis_helper::REDIS_INSTANCES.each do |instance|
        Infisical['infisical_core']["redis_#{instance}_sentinels_password"] ||= Infisical['sentinel']['password']
      end
    end

    def parse_rename_commands
      return unless Infisical['redis']['rename_commands'].nil?

      Infisical['redis']['rename_commands'] = {
        'KEYS' => ''
      }
    end

    def redis_managed?
      Services.enabled?('redis')
    end

    def populate_extra_config
      return unless Infisical['redis']['extra_config_command']

      command = Infisical['redis']['extra_config_command']

      begin
        _, stdout_stderr, status = Open3.popen2e(*command.split(' '))
      # If the command is path to a script and it doesn't exist, inform the user
      rescue Errno::ENOENT
        raise CommandExecutionError, "Redis: Execution of `#{command}` failed. File does not exist."
      end

      output = stdout_stderr.read
      stdout_stderr.close

      # Command execution failed. Inform the user.
      unless status.value.success?
        raise CommandExecutionError,
              "Redis: Execution of `#{command}` failed with exit code #{status.value.exitstatus}. Output: #{output}"
      end

      Infisical['redis']['extra_config'] = output
      parse_redis_password_from_extra_config(output)
    end

    # Extract the password from generated config. This password is used by
    # omnibus-infisical library code to connect to Redis to get running version.
    def parse_redis_password_from_extra_config(config)
      passwords = {
        password: /requirepass ['"](?<password>.*)['"]$/,
        master_password: /masterauth ['"](?<master_password>.*)['"]$/
      }
      config.lines.each do |config|
        passwords.each do |setting, reg|
          match = reg.match(config)
          Infisical['redis']["extracted_#{setting}"] = match[setting] if match
        end
      end
    end

    private

    def parse_redis_bind_address
      return unless redis_managed?

      redis_bind = Infisical['redis']['bind'] || node['redis']['bind']
      Infisical['redis']['default_host'] = redis_bind.split(' ').first
    end

    def parse_redis_daemon!
      return unless redis_managed?

      redis_bind = Infisical['redis']['bind'] || node['redis']['bind']
      Infisical['infisical_core']['redis_host'] ||= Infisical['redis']['default_host']

      redis_port_config_key = if Infisical['redis'].key?('port') && !Infisical['redis']['port'].zero?
                                # If Redis is specified to run on a non-TLS port
                                'port'
                              elsif Infisical['redis'].key?('tls_port') && !Infisical['redis']['tls_port'].zero?
                                # If Redis is specified to run on a TLS port
                                'tls_port'
                              else
                                # If Redis is running on neither ports, then it doesn't matter which
                                # key we choose as both will return `nil`.
                                'port'
                              end

      redis_port = Infisical['redis'][redis_port_config_key]
      Infisical['infisical_core']['redis_port'] ||= redis_port

      Infisical['infisical_core']['redis_password'] ||= Infisical['redis']['master_password']

      if Infisical['infisical_core']['redis_host'] != redis_bind
        Chef::Log.warn "infisical-rails 'redis_host' is different than 'bind' value defined for managed redis instance. Are you sure you are pointing to the same redis instance?"
      end

      if Infisical['infisical_core']['redis_port'] != redis_port
        Chef::Log.warn "infisical-rails 'redis_port' is different than '#{redis_port_config_key}' value defined for managed redis instance. Are you sure you are pointing to the same redis instance?"
      end

      if Infisical['infisical_core']['redis_password'] != Infisical['redis']['master_password']
        Chef::Log.warn "infisical-rails 'redis_password' is different than 'master_password' value defined for managed redis instance. Are you sure you are pointing to the same redis instance?"
      end
    end

    def node
      Infisical[:node]
    end
  end
end
