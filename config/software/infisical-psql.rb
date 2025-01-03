#
# Copyright:: Copyright (c) 2016 GitLab Inc.
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

name 'infisical-psql'

license 'Apache-2.0'
license_file File.expand_path('LICENSE', Omnibus::Config.project_root)

skip_transitive_dependency_licensing true

# This 'software' is self-contained in this file. Use the file contents
# to generate a version string.
default_version Digest::MD5.file(__FILE__).hexdigest

build do
  mkdir "#{install_dir}/bin/"

  block do
    File.open("#{install_dir}/bin/infisical-psql", 'w') do |file|
      file.print <<~EOH
        #!/bin/sh

        error_echo()
        {
          echo "$1" 2>& 1
        }

        infisical_psql_rc='/opt/infisical-core/etc/infisical-psql-rc'


        if ! [ -f ${infisical_psql_rc} ] ; then
          error_echo "$0 error: could not load ${infisical_psql_rc}"
          error_echo "Either you are not allowed to read the file, or it does not exist yet."
          error_echo "You can generate it with:   sudo infisical-ctl reconfigure"
          exit 1
        fi

        . ${infisical_psql_rc}

        if [ "$(id -n -u)" = "${psql_user}" ] ; then
          privilege_drop=''
        else
          privilege_drop="-u ${psql_user}:${psql_group}"
        fi

        cd /tmp; exec /opt/infisical-core/embedded/bin/chpst ${privilege_drop} -U ${psql_user} /usr/bin/env PGSSLCOMPRESSION=0 /opt/infisical-core/embedded/bin/psql -p ${psql_port} -h ${psql_host} -d ${psql_dbname} "$@"
      EOH
    end
  end

  command "chmod 755 #{install_dir}/bin/infisical-psql"
end
