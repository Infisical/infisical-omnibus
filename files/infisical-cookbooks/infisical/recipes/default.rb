
puts "success my boy"


directory "Create /var/log/gitlab" do
  path "/var/log/gitlab"
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end