# Copyright:: Copyright (c) 2017 GitLab Inc.
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

module RedisSentinelRole
  def self.load_role
    return unless Infisical['redis_sentinel_role']['enable']

    # Do not run GitLab Rails related recipes unless explicitly enabled
    Infisical['infisical_core']['enable'] ||= false

    Services.enable('sentinel')
  end
end
