#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# Copyright:: Copyright (c) 2014 infisical.com
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

####
# The Git User that services run as
####
# The username for the chef services user
default['infisical']['user']['username'] = 'infisical'
default['infisical']['user']['group'] = 'infisical'

####
# infisical Rails app
####
default['infisical']['infisical_core']['enable'] = true
default['infisical']['infisical_core']['dir'] = '/var/opt/infisical/infisical-core'
default['infisical']['infisical_core']['log_directory'] = '/var/log/infisical/infisical-core'
default['infisical']['infisical_core']['environment'] = 'production'
default['infisical']['infisical_core']['env_dir'] = '/opt/infisical/etc/infisical_core/env'
default['infisical']['infisical_core']['auto_migration'] = 'true'

default['infisical']['infisical_core']['ENCRYPTION_KEY'] = nil
default['infisical']['infisical_core']['AUTH_SECRET'] = nil
default['infisical']['infisical_core']['SITE_URL'] = nil
default['infisical']['infisical_core']['PORT'] = 8080
default['infisical']['infisical_core']['TELEMETRY_ENABLED'] = true

# Telemetry credentials
default['infisical']['infisical_core']['DB_CONNECTION_URI'] = nil
default['infisical']['infisical_core']['DB_ROOT_CERT'] = nil
default['infisical']['infisical_core']['REDIS_URL'] = nil
default['infisical']['infisical_core']['DB_READ_REPLICAS'] = nil

# SMTP Connection
default['infisical']['infisical_core']['SMTP_PORT'] = '587'
default['infisical']['infisical_core']['SMTP_USERNAME'] = nil
default['infisical']['infisical_core']['SMTP_PASSWORD'] = nil
default['infisical']['infisical_core']['SMTP_FROM_ADDRESS'] = nil
default['infisical']['infisical_core']['SMTP_FROM_NAME'] = nil
default['infisical']['infisical_core']['SMTP_IGNORE_TLS'] = false
default['infisical']['infisical_core']['SMTP_REQUIRE_TLS'] = true
default['infisical']['infisical_core']['SMTP_TLS_REJECT_UNAUTHORIZED'] = true
# Auth settings
default['infisical']['infisical_core']['DEFAULT_SAML_ORG_SLUG'] = nil

# Integration settings
default['infisical']['infisical_core']['CLIENT_ID_HEROKU'] = nil
default['infisical']['infisical_core']['CLIENT_ID_VERCEL'] = nil
default['infisical']['infisical_core']['CLIENT_ID_NETLIFY'] = nil
default['infisical']['infisical_core']['CLIENT_ID_GITHUB'] = nil
default['infisical']['infisical_core']['CLIENT_ID_GITHUB_APP'] = nil
default['infisical']['infisical_core']['CLIENT_SLUG_GITHUB_APP'] = nil
default['infisical']['infisical_core']['CLIENT_ID_GITLAB'] = nil
default['infisical']['infisical_core']['CLIENT_ID_BITBUCKET'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_HEROKU'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_VERCEL'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_NETLIFY'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GITHUB'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GITHUB_APP'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GITLAB'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_BITBUCKET'] = nil
default['infisical']['infisical_core']['CLIENT_SLUG_VERCEL'] = nil
default['infisical']['infisical_core']['CLIENT_PRIVATE_KEY_GITHUB_APP'] = nil
default['infisical']['infisical_core']['CLIENT_APP_ID_GITHUB_APP'] = nil

# SSO Settings
default['infisical']['infisical_core']['CLIENT_ID_GOOGLE_LOGIN'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GOOGLE_LOGIN'] = nil
default['infisical']['infisical_core']['CLIENT_ID_GITHUB_LOGIN'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GITHUB_LOGIN'] = nil
default['infisical']['infisical_core']['CLIENT_ID_GITLAB_LOGIN'] = nil
default['infisical']['infisical_core']['CLIENT_SECRET_GITLAB_LOGIN'] = nil

# HCaptcha settings
default['infisical']['infisical_core']['CAPTCHA_SECRET'] = nil
default['infisical']['infisical_core']['NEXT_PUBLIC_CAPTCHA_SITE_KEY'] = nil

# SSL Settings
default['infisical']['infisical_core']['SSL_CLIENT_CERTIFICATE_HEADER_KEY'] = nil

# Logging
###
default['infisical']['logging']['svlogd_size'] = 200 * 1024 * 1024 # rotate after 200 MB of log data
default['infisical']['logging']['svlogd_num'] = 30 # keep 30 rotated log files
default['infisical']['logging']['svlogd_timeout'] = 24 * 60 * 60 # rotate after 24 hours
default['infisical']['logging']['svlogd_filter'] = 'gzip' # compress logs with gzip
default['infisical']['logging']['svlogd_udp'] = nil # transmit log messages via UDP
default['infisical']['logging']['svlogd_prefix'] = nil # custom prefix for log messages
default['infisical']['logging']['udp_log_shipping_host'] = nil # remote host to ship log messages to via UDP
default['infisical']['logging']['udp_log_shipping_hostname'] = nil # set the hostname for log messages shipped via UDP
default['infisical']['logging']['udp_log_shipping_port'] = 514 # remote port to ship log messages to via UDP
default['infisical']['logging']['logrotate_frequency'] = 'daily' # rotate logs daily
default['infisical']['logging']['logrotate_maxsize'] = nil # rotate logs when they grow bigger than size bytes even before the specified time interval (daily, weekly, monthly, or yearly)
default['infisical']['logging']['logrotate_size'] = nil # do not rotate by size by default
default['infisical']['logging']['logrotate_rotate'] = 30 # keep 30 rotated logs
default['infisical']['logging']['logrotate_compress'] = 'compress' # see 'man logrotate'
default['infisical']['logging']['logrotate_method'] = 'copytruncate' # see 'man logrotate'
default['infisical']['logging']['logrotate_postrotate'] = nil # no postrotate command by default
default['infisical']['logging']['logrotate_dateformat'] = nil # use date extensions for rotated files rather than numbers e.g. a value of "-%Y-%m-%d" would give rotated files like production.log-2016-03-09.gz
default['infisical']['logging']['log_group'] = nil # log group for logs (svlogd only at this time)
