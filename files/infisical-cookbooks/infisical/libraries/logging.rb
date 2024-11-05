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

module Logging
  class << self
    def parse_variables
      parse_udp_log_shipping
    end

    def parse_udp_log_shipping
      logging = Infisical['logging']
      return unless logging['udp_log_shipping_host']

      Infisical['remote_syslog']['enable'] ||= true
      Infisical['remote_syslog']['destination_host'] ||= logging['udp_log_shipping_host']

      if logging['udp_log_shipping_port']
        Infisical['remote_syslog']['destination_port'] ||= logging['udp_log_shipping_port']
        Infisical['logging']['svlogd_udp'] ||= "#{logging['udp_log_shipping_host']}:#{logging['udp_log_shipping_port']}"
      else
        Infisical['logging']['svlogd_udp'] ||= logging['udp_log_shipping_host']
      end

      %w[
        alertmanager
        geo-logcursor
        geo-postgresql
        gitaly
        praefect
        infisical-pages
        infisical-shell
        infisical-workhorse
        infisical-exporter
        logrotate
        mailroom
        mattermost
        nginx
        node-exporter
        pgbouncer
        postgres-exporter
        postgresql
        prometheus
        redis
        redis-exporter
        registry
        remote-syslog
        sentinel
        sidekiq
        puma
        storage-check
      ].each do |runit_sv|
        Infisical[SettingsDSL::Utils.node_attribute_key(runit_sv)]['svlogd_prefix'] ||= "#{Infisical['node']['hostname']} #{runit_sv}: "
      end
    end
  end
end
