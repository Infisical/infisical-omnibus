require 'openssl'
require_relative '../../package/libraries/settings_dsl'

# Default location of install-dir is /opt/infisical-core/. This path is set during build time.
# DO NOT change this value unless you are building your own GitLab packages
install_dir = node['package']['install-dir']
ENV['PATH'] = "#{install_dir}/bin:#{install_dir}/embedded/bin:#{ENV['PATH']}"

include_recipe 'infisical::config'

OmnibusHelper.check_environment

directory 'Create /var/opt/infisical-core' do
  path '/var/opt/infisical-core'
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory "Create /var/log/infisical-core" do
  path "/var/log/infisical-core"
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

include_recipe 'package::runit'

include_recipe 'package::sysctl'

include_recipe 'infisical::infisical_core'
