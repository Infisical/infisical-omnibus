#
# Copyright 2024 YOUR NAME
#
# All Rights Reserved.
#

name "test"
maintainer "CHANGE ME"
homepage "https://CHANGE-ME.com"

# Defaults to C:/test on Windows
# and /opt/test on all other platforms
install_dir "#{default_root}/#{name}"
# install_dir File.expand_path(File.join(Omnibus::Config.project_root, 'infisical-tmp'))


build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "preparation"

# test dependencies/components
dependency "infisical"


exclude "**/.git"
exclude "**/bundler/git"
