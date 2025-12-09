source 'https://rubygems.org'

# Install omnibus
gem 'omnibus', '~> 9.0'

# Use Chef's software definitions. It is recommended that you write your own
# software definitions, but you can clone/fork Chef's to get you started.
gem 'omnibus-software', github: 'infisical/omnibus-software'
source 'https://packagecloud.io/cinc-project/stable' do
  gem 'chef', '~> 18.3.0'
  gem 'chef-cli', '~> 5.6.1'
  gem 'chef-utils', '~> 18.3.0'
  gem 'mixlib-versioning'
end

gem 'ffi', '1.17.0', force_ruby_platform: true
gem 'unf_ext', '~>0.0.9.1'
gem 'ohai', '~> 18.0'
gem 'rainbow', '~> 2.2' # This is used by gitlab-ctl and the chef formatter
gem 'json'
gem 'rspec'
gem 'rake'
gem 'knapsack'
gem 'docker-api'
gem 'http'
gem 'aws-sdk-ec2'
gem 'aws-sdk-marketplacecatalog'
gem 'gitlab'
gem 'yard'
gem 'toml-rb'
gem 'retriable'
gem 'tomlib', '~> 0.6.0'
gem 'google-cloud-storage'


# This development group is installed by default when you run `bundle install`,
# but if you are using Omnibus in a CI-based infrastructure, you do not need
# the Test Kitchen-based build lab. You can skip these unnecessary dependencies
# by running `bundle install --without development` to speed up build times.
group :development do
  # Use Berkshelf for resolving cookbook dependencies
  gem 'berkshelf'

  # Use Test Kitchen with Vagrant for converging the build environment
  gem 'kitchen-vagrant'
  gem 'rubocop'
  gem 'test-kitchen'
end
