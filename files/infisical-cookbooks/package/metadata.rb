name 'package'
maintainer 'GitLab Inc'
maintainer_email 'support@gitlab.com'
license 'Apache 2.0'
description 'Base GitLab Package cookbook for installing and configuring GitLab'
long_description 'Base GitLab Package cookbook for installing and configuring GitLab'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url 'https://github.com/infisical/infisical/issues'
source_url 'https://github.com/infisical/infisical-omnibus'

depends 'runit'
