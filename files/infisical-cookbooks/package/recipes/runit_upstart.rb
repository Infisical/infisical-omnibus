#
# Cookbook Name:: package
# Recipe:: runit_upstart
#
# Copyright 2008-2010, Opscode, Inc.
# Copyright 2014 GitLab.com
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

cookbook_file '/etc/init/infisical-runsvdir.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'infisical-runsvdir.conf'
end

# Reload the configuration to ensure the new conf file is loaded
execute 'initctl reload-configuration' do
  command 'initctl reload-configuration'
end

# Keep on trying till the job is found :(
execute 'initctl status infisical-runsvdir' do
  retries 30
end

# If we are stop/waiting, start
#
# Why, upstart, aren't you idempotent? :(
execute 'initctl start infisical-runsvdir' do
  only_if 'initctl status infisical-runsvdir | grep stop'
  retries 30
end
