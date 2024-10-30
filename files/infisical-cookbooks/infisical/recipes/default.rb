
puts "success my boy"


directory "Create /var/log/infisicalcal" do
  path "/var/log/infisical"
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end