#
# Copyright:: Copyright (c) 2017 GitLab Inc.
# Copyright:: Copyright (c) 2024 Infisical
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
# - Updated code to be in line with Infisical usag

name 'libevent'

default_version 'release-2.1.12-stable'

dependency 'libtool'
dependency 'openssl' unless Build::Check.use_system_ssl?

license 'BSD-3-Clause'
license_file 'LICENSE'

skip_transitive_dependency_licensing true

source github: 'libevent/libevent'
relative_path 'libevent'

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['ACLOCAL_PATH'] = "#{install_dir}/embedded/share/aclocal"

  command './autogen.sh', env: env
  command './configure ' \
    "--prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make 'install', env: env
end
