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
# - Updated the code to align with Infisical's requirements

name 'consul'

# This version should be keep in sync with consul versions in
# consul_download.rb and consul_helper.rb.
default_version 'v1.18.2'

license 'BSL-Hashicorp'
license_file 'LICENSE'

source github: 'hashicorp/consul'

skip_transitive_dependency_licensing true

relative_path 'consul'

build do
  env = {}
  env['GOPATH'] = "#{Omnibus::Config.source_dir}/consul"
  env['GOTOOLCHAIN'] = 'local'
  env['PATH'] = "#{Infisical::Util.get_env('PATH')}:#{env['GOPATH']}/bin"

  command 'make dev', env: env
  mkdir "#{install_dir}/embedded/bin"
  copy 'bin/consul', "#{install_dir}/embedded/bin/"

  command "license_finder report --enabled-package-managers godep gomodules --decisions-file=#{Omnibus::Config.project_root}/support/dependency_decisions.yml --format=json --columns name version licenses texts notice --save=license.json"
  mkdir "#{install_dir}/licenses"
  copy 'license.json', "#{install_dir}/licenses/consul.json"
end
