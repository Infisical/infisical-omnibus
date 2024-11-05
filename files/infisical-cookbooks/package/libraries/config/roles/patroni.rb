# Copyright:: Copyright (c) 2021 GitLab Inc.
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

module PatroniRole
  def self.load_role
    return unless Infisical['patroni_role']['enable']

    # We need to set Infisical['infisical_core']['enable'] to true because DB
    # creation in database_objects resource is gated on whether Rails is
    # enabled or not.
    Infisical['infisical_core']['enable'] = true if Infisical['infisical_core']['enable'].nil?

    Services.enable_group('patroni_role')
  end
end
