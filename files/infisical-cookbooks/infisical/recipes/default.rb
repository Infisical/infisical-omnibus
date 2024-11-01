require 'openssl'
require_relative '../../package/libraries/settings_dsl'

# Default location of install-dir is /opt/infisical/. This path is set during build time.
# DO NOT change this value unless you are building your own GitLab packages
install_dir = node['package']['install-dir']
ENV['PATH'] = "#{install_dir}/bin:#{install_dir}/embedded/bin:#{ENV['PATH']}"

include_recipe 'infisical::config'

OmnibusHelper.check_environment

directory 'Create /var/opt/infisical' do
  path '/var/opt/infisical'
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory 'Create /var/log/infisical' do
  path '/var/log/infisical'
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

puts node['infisical']['infisical_core']['infisical_port']
