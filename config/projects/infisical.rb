#
# Copyright 2024 YOUR NAME
#
# All Rights Reserved.
#

name "infisical"
maintainer "CHANGE ME"
homepage "https://CHANGE-ME.com"

# Defaults to C:/infisical on Windows
# and /opt/infisical on all other platforms
install_dir "#{default_root}/#{name}"
# install_dir File.expand_path(File.join(Omnibus::Config.project_root, 'infisical-tmp'))

require "#{Omnibus::Config.project_root}/lib/infisical/util"
require "#{Omnibus::Config.project_root}/lib/infisical/ohai_helper.rb"
require "#{Omnibus::Config.project_root}/lib/infisical/build/check.rb"


build_version Omnibus::BuildVersion.semver
build_iteration 1

replace         'infisical'
conflict        'infisical'

override :libffi, version: "3.4.2"
override :openssl, version: '3.0.12'

# Creates required build directories
dependency "preparation"

# infisical dependencies/components

# dependency "omnibus-infisical-gems"
# dependency "redis"
# dependency "jemalloc"
# dependency "logrotate"
# failed dependency "runit"
# dependency "consul"


# dependency "infisical-pg-ctl"
# dependency "infisical-cookbooks"
# dependency "infisical-ctl"


# dependency "infisical-scripts"
 dependency "postgresql"
 dependency "pgbouncer"

# dependency "infisical"

exclude "**/.git"
exclude "**/bundler/git"
