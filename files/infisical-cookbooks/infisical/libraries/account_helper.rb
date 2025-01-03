#
# Copyright:: Copyright (c) 2015 GitLab B.V.
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

class AccountHelper
  attr_reader :node

  def initialize(node)
    @node = node
  end

  def infisical_core_user
    node['infisical']['user']['username']
  end

  def infisical_core_group
    node['infisical']['user']['group']
  end

  def web_server_user
    node['infisical']['web_server']['username']
  end

  def web_server_group
    node['infisical']['web_server']['group']
  end

  def redis_user
    node['redis']['username']
  end

  def redis_group
    node['redis']['group']
  end

  def postgresql_user
    node['postgresql']['username']
  end

  def postgresql_group
    node['postgresql']['group']
  end

  def mattermost_user
    node['mattermost']['username']
  end

  def mattermost_group
    node['mattermost']['group']
  end

  def registry_user
    node['registry']['username']
  end

  def registry_group
    node['registry']['group']
  end

  def prometheus_user
    node['monitoring']['prometheus']['username']
  end

  def prometheus_group
    node['monitoring']['prometheus']['group']
  end

  def consul_user
    node['consul']['username']
  end

  def consul_group
    node['consul']['group']
  end

  def users
    %W[
      #{infisical_core_user}
      #{web_server_user}
      #{redis_user}
      #{postgresql_user}
      #{mattermost_user}
      #{registry_user}
      #{prometheus_user}
      #{consul_user}
    ]
  end

  def groups
    %W[
      #{infisical_core_group}
      #{web_server_group}
      #{redis_group}
      #{postgresql_group}
      #{mattermost_group}
      #{registry_group}
      #{consul_group}
      #{prometheus_group}
    ]
  end
end
