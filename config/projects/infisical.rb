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


build_version Omnibus::BuildVersion.semver
build_iteration 1

override :libffi, version: "3.4.2"

# Creates required build directories
dependency "preparation"

# infisical dependencies/components
dependency "infisical"

# dependency "infisical-ctl"


exclude "**/.git"
exclude "**/bundler/git"
