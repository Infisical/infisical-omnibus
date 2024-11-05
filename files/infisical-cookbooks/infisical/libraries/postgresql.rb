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

module Postgresql
  class << self
    def parse_variables
      # TODO(akhilmhdh): bring this pack
      # parse_connect_port
      # parse_wal_keep_size
    end

    def parse_secrets
      gitlab_postgresql_crt, gitlab_postgresql_key = generate_postgresql_keypair
      Infisical['postgresql']['internal_certificate'] ||= gitlab_postgresql_crt
      Infisical['postgresql']['internal_key'] ||= gitlab_postgresql_key
    end

    def parse_wal_keep_size
      wal_segment_size = 16
      wal_keep_segments = Infisical['postgresql']['wal_keep_segments'] || Infisical['node']['postgresql']['wal_keep_segments']
      wal_keep_size = Infisical['postgresql']['wal_keep_size'] || Infisical['node']['postgresql']['wal_keep_size']

      Infisical['postgresql']['wal_keep_size'] = if wal_keep_size.nil?
                                                   wal_keep_segments.to_i * wal_segment_size
                                                 else
                                                   wal_keep_size
                                                 end
    end

    def parse_connect_port
      Infisical['postgresql']['connect_port'] ||= Infisical['postgresql']['port'] || Infisical['node']['postgresql']['port']
    end

    def postgresql_managed?
      Services.enabled?('postgresql')
    end

    def generate_postgresql_keypair
      key, cert = SecretsHelper.generate_keypair(
        bits: 4096,
        subject: '/C=USA/O=GitLab/OU=Database/CN=PostgreSQL',
        validity: 365 * 10 # ten years from now
      )

      [cert.to_pem, key.to_pem]
    end
  end
end
