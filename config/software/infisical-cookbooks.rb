#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# Copyright:: Copyright (c) 2014 GitLab.com
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

name 'infisical-cookbooks'

license 'Apache-2.0'
license_file File.expand_path('LICENSE', Omnibus::Config.project_root)

skip_transitive_dependency_licensing true

source path: File.expand_path('files/infisical-cookbooks', Omnibus::Config.project_root)

build do
  cookbook_name = 'infisical'

  mkdir "#{install_dir}/embedded/cookbooks"
  sync './', "#{install_dir}/embedded/cookbooks/"

  # solo_recipes = %w(dna postgresql-bin postgresql-config pg-upgrade-config)
  solo_recipes = %w[dna]

  # If EE package, use a different master cookbook
  # if EE
  #   cookbook_name = JH ? 'infisical-jh' : 'infisical-ee'
  #   solo_recipes << 'geo-postgresql-config'
  #   solo_recipes << 'patroni-config'
  # else
  #   delete "#{install_dir}/embedded/cookbooks/infisical-ee"
  # end

  solo_recipes.each do |config|
    erb dest: "#{install_dir}/embedded/cookbooks/#{config}.json",
        source: "#{config}.json.erb",
        mode: 0o644,
        vars: { master_cookbook: cookbook_name }
  end

  # TODO(akhilmhdh): check what is build and its uses
  # block do
  #   if Build::Check.use_system_ssl?
  #     solo_file = "#{install_dir}/embedded/cookbooks/solo.rb"
  #     data = File.read(solo_file)
  #     data.sub!(/^fips false/, 'fips true')
  #     File.write(solo_file, data)
  #   end
  # end
end
