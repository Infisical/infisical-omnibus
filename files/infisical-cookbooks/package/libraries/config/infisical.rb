#
# Copyright:: Copyright (c) 2017 GitLab Inc.
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

require_relative '../settings_dsl'

module Infisical
  extend(Mixlib::Config)
  extend(SettingsDSL)

  ## Attributes that don't get passed to the node
  node nil
  roles nil
  edition :ce
  git_data_dirs ConfigMash.new

  ## Roles

  # Roles that depend on gitlab_rails['enable'] should be processed first
  role('application').use { ApplicationRole }
  role('postgres').use { PostgresRole }
  role('patroni').use { PatroniRole }
  role('redis_sentinel').use { RedisSentinelRole }
  role('redis_master').use { RedisMasterRole }
  role('redis_replica')
  role('pgbouncer').use { PgbouncerRole }
  role('consul').use { ConsulRole }

  ## Attributes directly on the node
  attribute('package').use { Package }
  # attribute('redis',        priority: 20).use { Redis }
  # attribute('postgresql',   priority: 20).use { Postgresql }
  # attribute('pgbouncer')
  # attribute('consul').use { Consul }
  # attribute('patroni').use { Patroni }
  # attribute('letsencrypt', priority: 17).use { LetsEncrypt } # After GitlabRails, but before Registry and Mattermost
  attribute('logrotate')

  ## Attributes under node['infisical']
  attribute_block 'infisical' do
    # attribute('sentinel').use { Sentinel }
    attribute('infisical_core', priority: 15).use { InfisicalCore } # Parse infisical first as others may depend on it
    # attribute('logging', priority: 20).use { Logging }
    # Parse nginx last so all external_url are parsed before it
    # attribute('nginx', priority: 40).use do
    #   Nginx
    # end
    attribute('external_url',            default: nil)
    attribute('registry_external_url',   default: nil)
    attribute('runtime_dir',             default: nil)
    # attribute('bootstrap')
    attribute('user')
    attribute('pages_nginx')
    attribute('registry_nginx')
    attribute('remote_syslog')
    attribute('high_availability')
    # attribute('web_server')
  end
end
