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

require_relative '../helpers/services_helper'

module Services
  class BaseServices < ::Services::Config
    # Define all infisical cookbook services
    service 'logrotate', groups: [DEFAULT_GROUP, SYSTEM_GROUP]
    service 'infisical_core', groups: [DEFAULT_GROUP, 'infisical_role']
    service 'redis',              groups: [DEFAULT_GROUP, 'redis', 'redis_node']
    service 'postgresql',         groups: [DEFAULT_GROUP, 'postgres', 'postgres_role', 'patroni_role']
    service 'nginx',              groups: [DEFAULT_GROUP, 'pages_role']
    service 'pgbouncer',          groups: %w[postgres pgbouncer_role]
    service 'patroni',            groups: %w[postgres patroni_role]
    service 'consul',             groups: %w[consul_role ha pgbouncer_role patroni_role]
    service 'sentinel',           groups: ['redis']
  end
end
