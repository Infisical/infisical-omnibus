#
# Copyright:: Copyright (c) 2016 GitLab B.V.
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

# Make node object available to libraries to access default values specified in
# attribute files
Infisical[:node] = node

# Populate the service list. When using `roles`, services will get
# automatically enabled. For that, services should be already present in the
# list.
Services.add_services('infisical', Services::BaseServices.list)

# Parse `/etc/infisical/infisical.rb` and populate Infisical object
Infisical.from_file('/etc/infisical/infisical.rb') if File.exist?('/etc/infisical/infisical.rb')

# Generate config hash with settings specified in infisical.rb, computed default
# values for settings via parse_variable method, and secrets either loaded from
# infisical-secrets.json file or created anew. After this point, `Infisical` object
# will have values either read from `/etc/infisical/infisical.rb` or computed by the
# libraries.
generated_config = Infisical.generate_config

# Populate node objects with the config hash generated above. After this point,
# the node objects will have the final values to be used in recipes.
node.consume_attributes(generated_config)
