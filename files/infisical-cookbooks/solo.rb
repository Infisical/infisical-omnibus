require_relative 'package/libraries/handlers/infisical'
require_relative 'package/libraries/formatters/infisical'

CURRENT_PATH = __dir__
TIME = Time.now.to_i
LOG_PATH = '/var/log/infisical/reconfigure'.freeze
Dir.exist?(LOG_PATH) || FileUtils.mkdir_p(LOG_PATH)
add_formatter :infisical
file_cache_path "#{CURRENT_PATH}/cache"
cookbook_path CURRENT_PATH
cache_path "#{CURRENT_PATH}/cache"

exception_handlers << InfisicalHandler::Exception.new
report_handlers << InfisicalHandler::Attributes.new
verbose_logging false
ssl_verify_mode :verify_peer
fips false

# Log to the reconfigure log
log_location "#{LOG_PATH}/#{TIME}.log"
log_level :info

# This monkey-patch is a workaround for https://github.com/chef/chef/issues/6889
# We do not want an additional logger attached to STDOUT as the `infisical`
# formatter manages STDOUT
class ::Chef::Application
  def want_additional_logger?
    false
  end
end

# Don't fork, and run just once
client_fork false
once true

# Omnibus-GitLab only needs to know very little about the system it is running
# on. We want to disable as many Ohai plugins as we can to avoid plugin bugs
# and speed up 'infisical-ctl reconfigure'.
#
# The list below, based on Ohai 7.4.1, is a blacklist. UNcomment a plugin to
# disable it. For example, ':Groovy,' is uncommented because omnibus-infisical
# does not care about Groovy.
ohai.disabled_plugins = %i[
  Azure
  Cloud
  CloudV2
  DMI
  DigitalOcean
  EC2
  Erlang
  Elixir
  Eucalyptus
  GCE
  Groovy
  Go
  Java
  Joyent
  Linode
  Lua
  Mono
  NetworkListeners
  NetworkRoutes
  Nodejs
  Openstack
  Perl
  PHP
  Powershell
  Python
  Rackspace
  Rust
  Virtualbox
  VMware
  SystemProfile
  Zpools
  Virtualization
]
