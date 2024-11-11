#
# Copyright:: Copyright (c) 2020 GitLab Inc.
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

require 'digest'

name 'infisical-redis-cli'

license 'Apache-2.0'
license_file File.expand_path('LICENSE', Omnibus::Config.project_root)

skip_transitive_dependency_licensing true

# This 'software' is self-contained in this file. Use the file contents
# to generate a version string.
default_version Digest::MD5.file(__FILE__).hexdigest

build do
  mkdir "#{install_dir}/bin/"

  block do
    File.open("#{install_dir}/bin/infisical-redis-cli", 'w') do |file|
      file.print <<~EOH
        #!/bin/sh

        error_echo()
        {
          echo "$1" 2>& 1
        }

        set_tls_params()
        {
          REDIS_PARAMS="${REDIS_PARAMS} -p ${redis_tls_port} --tls"
          if [ "${redis_tls_auth_clients}" = "yes" ]; then
            REDIS_PARAMS="${REDIS_PARAMS} --cacertdir ${redis_tls_cacert_dir} \
              --cacert ${redis_tls_cacert_file} \
              --cert ${redis_tls_cert_file} \
              --key ${redis_tls_key_file}"
          fi
        }

        infisical_redis_cli_rc='/opt/infisical-core/etc/infisical-redis-cli-rc'

        if ! [ -f ${infisical_redis_cli_rc} ] || ! [ -r ${infisical_redis_cli_rc} ] ; then
          error_echo "$0 error: could not load ${infisical_redis_cli_rc}"
          error_echo "Either you are not allowed to read the file, or it does not exist yet."
          error_echo "You can generate it with:   sudo infisical-ctl reconfigure"
          exit 1
        fi

        . "${infisical_redis_cli_rc}"


        if [ -e "${redis_socket}" ]; then
          REDIS_PARAMS="-s ${redis_socket}"
        else
          REDIS_PARAMS="-h ${redis_host}"
          if ! [ "${redis_port}" = "0" ]; then
            REDIS_PARAMS="${REDIS_PARAMS} -p ${redis_port}"
          elif ! [ "${redis_tls_port}" = "0pr" ]; then
            set_tls_params
          fi
        fi

        REDISCLI_AUTH="$(awk '/^requirepass /{
          pwd = $0 ;
          gsub(/^requirepass /,"",pwd);
          gsub(/^"|"$/, "", pwd);
          print pwd }' ${redis_dir}/redis.conf)"


        if [ -n "${REDISCLI_AUTH}" ]; then
          export REDISCLI_AUTH
        fi

        exec /opt/infisical-core/embedded/bin/redis-cli $REDIS_PARAMS "$@"
      EOH
    end
  end

  command "chmod 755 #{install_dir}/bin/infisical-redis-cli"
end
