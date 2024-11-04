account_helper = AccountHelper.new(node)
logfiles_helper = LogfilesHelper.new(node)
logging_settings = logfiles_helper.logging_settings('infisical_core')

user_name = account_helper.infisical_core_user.to_s
user_group = account_helper.infisical_core_group.to_s
service_name = 'infisical_core'

# Ensure the infisical user exists
user user_name do
  comment 'infisical service account'
  system true
  shell '/sbin/nologin'
  home "/opt/#{user_name}"
  action :create
end

execute 'chown infisical core' do
  command "chown -R #{user_group}:#{user_group} /opt/infisical/server/frontend-build/scripts /opt/infisical/server/frontend-build/public/data /opt/infisical/server/frontend-build/.next /opt/infisical/server/standalone-entrypoint.sh"
  user 'root'
end

execute 'chmod infisical core' do
  command 'chmod -R 555 /opt/infisical/server/frontend-build/scripts  /opt/infisical/server/standalone-entrypoint.sh'
  user 'root'
end

execute 'chmod infisical frontend' do
  command 'chmod -R 755 /opt/infisical/server/frontend-build/.next'
  user 'root'
end

# Set executable permissions on node, npm, and npx binaries
%w[/opt/infisical/embedded/bin/node /opt/infisical/embedded/bin/npm /opt/infisical/embedded/bin/npx].each do |bin_path|
  file bin_path do
    mode '0755'
    action :create
  end
end

# Set ownership and permissions for SSL certificates
directory '/etc/ssl/certs' do
  owner user_name
  recursive true
  mode '0700'
  action :create
end

file '/etc/ssl/certs/ca-certificates.crt' do
  owner user_name
  mode '0644'
  action :create
end

# Set permissions for update-ca-certificates
file '/usr/sbin/update-ca-certificates' do
  owner user_name
  mode '0755'
  action :create
end

directory "Create /var/log/infisical/#{service_name}" do
  path logging_settings[:log_directory]
  owner user_name
  group user_group
  mode '0755'
  recursive true
  action :create
end

infisical_core_env = {
  'PATH' => "#{ENV['PATH']}:/opt/#{service_name}/embedded/bin"
}

# Iterate through each key-value pair in node['infisical']['user']
node['infisical']['infisical_core'].each do |key, value|
  # Check if the key is fully capitalized and the value is not nil
  if key == key.upcase && !value.nil?
    # Add the key-value pair to the hash
    infisical_core_env[key] = value.to_s
  end
end

runit_service service_name do
  options({
            log_directory: logging_settings[:log_directory],
            log_user: logging_settings[:runit_user],
            log_group: logging_settings[:runit_group],
            user: user_name,
            groupname: user_group
          })
  env infisical_core_env
  owner user_name
  group user_group
  supervisor_owner 'root'
  supervisor_group 'root'
end
