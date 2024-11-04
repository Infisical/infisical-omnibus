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

# Define paths that require ownership by 'infisical'
infisical_paths = [
  '/opt/infisical/server/frontend-build/scripts',
  '/opt/infisical/server/frontend-build/public/data',
  '/opt/infisical/server/frontend-build/.next',
  '/opt/infisical/server/standalone-entrypoint.sh'
]

# Set ownership of the specified directories to 'infisical:infisical'
infisical_paths.each do |path|
  directory path do
    owner user_name
    group user_group
    recursive true
    action :create
  end
end

# Set permissions for specific directories and files
directory '/opt/infisical/server/frontend-build/scripts' do
  mode '0555'
  recursive true
  action :create
end

file '/opt/infisical/server/standalone-entrypoint.sh' do
  mode '0555'
  action :create
end

directory '/opt/infisical/server/frontend-build/.next' do
  mode '0755'
  recursive true
  action :create
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
  path "/var/log/infisical/#{service_name}"
  owner user_name
  group user_group
  mode '0755'
  recursive true
  action :create
end

infisical_core_env = {
  PATH => "#{ENV['PATH']}:/opt/#{service_name}/embedded/bin"
}

# Iterate through each key-value pair in node['infisical']['user']
node['infisical']['infisical_core'].each do |key, value|
  # Check if the key is fully capitalized and the value is not nil
  if key == key.upcase && !value.nil?
    # Add the key-value pair to the hash
    infisical_core_env[key] = value
  end
end

puts 'env'
puts infisical_core_env
