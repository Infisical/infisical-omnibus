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
# omnibus options
####
default['infisical']['bootstrap']['enable'] = true
# Create users and groups needed for the package
default['infisical']['manage_accounts']['enable'] = true

####
# The Git User that services run as
####
# The username for the chef services user
default['infisical']['user']['username'] = 'git'
default['infisical']['user']['group'] = 'git'
default['infisical']['user']['uid'] = nil
default['infisical']['user']['gid'] = nil
# The shell for the chef services user
default['infisical']['user']['shell'] = '/bin/sh'
# The home directory for the chef services user
default['infisical']['user']['home'] = '/var/opt/infisical'

####
# infisical Rails app
####
default['infisical']['infisical_core']['enable'] = true
default['infisical']['infisical_core']['dir'] = '/var/opt/infisical/infisical-core'
default['infisical']['infisical_core']['log_directory'] = '/var/log/infisical/infisical-core'
default['infisical']['infisical_core']['environment'] = 'production'
default['infisical']['infisical_core']['env'] = {
  'SSL_CERT_DIR' => "#{node['package']['install-dir']}/embedded/ssl/certs/",
  'SSL_CERT_FILE' => "#{node['package']['install-dir']}/embedded/ssl/cert.pem"
}

default['infisical']['infisical_core']['internal_api_url'] = nil
default['infisical']['infisical_core']['uploads_directory'] = '/var/opt/infisical/infisical-core/uploads'
default['infisical']['infisical_core']['auto_migrate'] = true
default['infisical']['infisical_core']['rake_cache_clear'] = true
default['infisical']['infisical_core']['infisical_host'] = node['fqdn']
default['infisical']['infisical_core']['infisical_port'] = 80
default['infisical']['infisical_core']['infisical_https'] = false
default['infisical']['infisical_core']['infisical_ssh_user'] = nil
default['infisical']['infisical_core']['infisical_ssh_host'] = nil
default['infisical']['infisical_core']['time_zone'] = nil
default['infisical']['infisical_core']['cdn_host'] = nil
default['infisical']['infisical_core']['infisical_email_from'] = nil
default['infisical']['infisical_core']['infisical_email_display_name'] = nil
default['infisical']['infisical_core']['infisical_email_subject_suffix'] = nil
default['infisical']['infisical_core']['infisical_email_smime_enabled'] = false
default['infisical']['infisical_core']['infisical_email_smime_key_file'] = '/etc/infisical/ssl/infisical_smime.key'
default['infisical']['infisical_core']['infisical_email_smime_cert_file'] = '/etc/infisical/ssl/infisical_smime.crt'
default['infisical']['infisical_core']['infisical_email_smime_ca_certs_file'] = nil
default['infisical']['infisical_core']['infisical_username_changing_enabled'] = nil
default['infisical']['infisical_core']['infisical_default_theme'] = nil
default['infisical']['infisical_core']['custom_html_header_tags'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_issues'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_merge_requests'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_wiki'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_wall'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_snippets'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_builds'] = nil
default['infisical']['infisical_core']['infisical_default_projects_features_container_registry'] = nil
default['infisical']['infisical_core']['infisical_issue_closing_pattern'] = nil
default['infisical']['infisical_core']['infisical_repository_downloads_path'] = nil
default['infisical']['infisical_core']['gravatar_plain_url'] = nil
default['infisical']['infisical_core']['gravatar_ssl_url'] = nil
default['infisical']['infisical_core']['stuck_ci_jobs_worker_cron'] = nil
default['infisical']['infisical_core']['expire_build_artifacts_worker_cron'] = nil
default['infisical']['infisical_core']['environments_auto_stop_cron_worker_cron'] = nil
default['infisical']['infisical_core']['pipeline_schedule_worker_cron'] = nil
default['infisical']['infisical_core']['repository_check_worker_cron'] = nil
default['infisical']['infisical_core']['admin_email_worker_cron'] = nil
default['infisical']['infisical_core']['personal_access_tokens_expiring_worker_cron'] = nil
default['infisical']['infisical_core']['personal_access_tokens_expired_notification_worker_cron'] = nil
default['infisical']['infisical_core']['repository_archive_cache_worker_cron'] = nil
default['infisical']['infisical_core']['ci_archive_traces_cron_worker'] = nil
default['infisical']['infisical_core']['pages_domain_verification_cron_worker'] = nil
default['infisical']['infisical_core']['pages_domain_ssl_renewal_cron_worker'] = nil
default['infisical']['infisical_core']['pages_domain_removal_cron_worker'] = nil
default['infisical']['infisical_core']['remove_unaccepted_member_invites_cron_worker'] = nil
default['infisical']['infisical_core']['schedule_migrate_external_diffs_worker_cron'] = nil
default['infisical']['infisical_core']['ci_platform_metrics_update_cron_worker'] = nil
default['infisical']['infisical_core']['historical_data_worker_cron'] = nil
default['infisical']['infisical_core']['analytics_devops_adoption_create_all_snapshots_worker_cron'] = nil
default['infisical']['infisical_core']['ldap_sync_worker_cron'] = nil
default['infisical']['infisical_core']['ldap_group_sync_worker_cron'] = nil
default['infisical']['infisical_core']['geo_repository_sync_worker_cron'] = nil
default['infisical']['infisical_core']['geo_secondary_registry_consistency_worker'] = nil
default['infisical']['infisical_core']['geo_secondary_usage_data_cron_worker'] = nil
default['infisical']['infisical_core']['geo_prune_event_log_worker_cron'] = nil
default['infisical']['infisical_core']['geo_repository_verification_primary_batch_worker_cron'] = nil
default['infisical']['infisical_core']['geo_repository_verification_secondary_scheduler_worker_cron'] = nil
default['infisical']['infisical_core']['analytics_usage_trends_count_job_trigger_worker_cron'] = nil
default['infisical']['infisical_core']['member_invitation_reminder_emails_worker_cron'] = nil
default['infisical']['infisical_core']['user_status_cleanup_batch_worker_cron'] = nil
default['infisical']['infisical_core']['loose_foreign_keys_cleanup_worker_cron'] = nil
default['infisical']['infisical_core']['elastic_index_bulk_cron'] = nil
default['infisical']['infisical_core']['incoming_email_enabled'] = false
default['infisical']['infisical_core']['incoming_email_address'] = nil
default['infisical']['infisical_core']['incoming_email_host'] = nil
default['infisical']['infisical_core']['incoming_email_port'] = nil
default['infisical']['infisical_core']['incoming_email_ssl'] = nil
default['infisical']['infisical_core']['incoming_email_start_tls'] = nil
default['infisical']['infisical_core']['incoming_email_email'] = nil
default['infisical']['infisical_core']['incoming_email_password'] = nil
default['infisical']['infisical_core']['incoming_email_mailbox_name'] = 'inbox'
default['infisical']['infisical_core']['incoming_email_idle_timeout'] = nil
default['infisical']['infisical_core']['incoming_email_log_file'] = '/var/log/infisical/mailroom/mail_room_json.log' # file path of internal `mail_room` JSON logs
default['infisical']['infisical_core']['incoming_email_delete_after_delivery'] = true
default['infisical']['infisical_core']['incoming_email_expunge_deleted'] = nil
default['infisical']['infisical_core']['incoming_email_inbox_method'] = 'imap'
default['infisical']['infisical_core']['incoming_email_inbox_options'] = nil
default['infisical']['infisical_core']['incoming_email_delivery_method'] = 'webhook'
default['infisical']['infisical_core']['incoming_email_auth_token'] = nil
default['infisical']['infisical_core']['click_house_ci_finished_builds_sync_worker_cron'] = nil
default['infisical']['infisical_core']['click_house_ci_finished_builds_sync_worker_args'] = nil
default['infisical']['infisical_core']['ci_click_house_finished_pipelines_sync_worker_cron'] = nil
default['infisical']['infisical_core']['ci_click_house_finished_pipelines_sync_worker_args'] = nil

default['infisical']['infisical_core']['service_desk_email_enabled'] = false
default['infisical']['infisical_core']['service_desk_email_address'] = nil
default['infisical']['infisical_core']['service_desk_email_host'] = nil
default['infisical']['infisical_core']['service_desk_email_port'] = nil
default['infisical']['infisical_core']['service_desk_email_ssl'] = nil
default['infisical']['infisical_core']['service_desk_email_start_tls'] = nil
default['infisical']['infisical_core']['service_desk_email_email'] = nil
default['infisical']['infisical_core']['service_desk_email_password'] = nil
default['infisical']['infisical_core']['service_desk_email_mailbox_name'] = 'inbox'
default['infisical']['infisical_core']['service_desk_email_idle_timeout'] = nil
default['infisical']['infisical_core']['service_desk_email_log_file'] = '/var/log/infisical/mailroom/mail_room_json.log' # file path of internal `mail_room` JSON logs
default['infisical']['infisical_core']['service_desk_email_inbox_method'] = 'imap'
default['infisical']['infisical_core']['service_desk_email_inbox_inbox_options'] = nil
default['infisical']['infisical_core']['service_desk_email_delivery_method'] = 'webhook'
default['infisical']['infisical_core']['service_desk_email_auth_token'] = nil

default['infisical']['infisical_core']['namespaces_in_product_marketing_emails_worker_cron'] = nil
default['infisical']['infisical_core']['ssh_keys_expired_notification_worker_cron'] = nil
default['infisical']['infisical_core']['ssh_keys_expiring_soon_notification_worker_cron'] = nil

default['infisical']['infisical_core']['ci_runners_stale_group_runners_prune_worker_cron'] = nil
default['infisical']['infisical_core']['ci_runner_versions_reconciliation_worker_cron'] = nil
default['infisical']['infisical_core']['ci_runners_stale_machines_cleanup_worker_cron'] = nil
default['infisical']['infisical_core']['ci_catalog_resources_process_sync_events_worker_cron'] = nil

# Consolidated object storage config
default['infisical']['infisical_core']['object_store']['enabled'] = false
default['infisical']['infisical_core']['object_store']['connection'] = {}
default['infisical']['infisical_core']['object_store']['storage_options'] = {}
default['infisical']['infisical_core']['object_store']['proxy_download'] = false
default['infisical']['infisical_core']['object_store']['objects'] = {}
default['infisical']['infisical_core']['object_store']['objects']['artifacts'] = {}
default['infisical']['infisical_core']['object_store']['objects']['artifacts']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['external_diffs'] = {}
default['infisical']['infisical_core']['object_store']['objects']['external_diffs']['bucket'] = false
default['infisical']['infisical_core']['object_store']['objects']['lfs'] = {}
default['infisical']['infisical_core']['object_store']['objects']['lfs']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['uploads'] = {}
default['infisical']['infisical_core']['object_store']['objects']['uploads']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['packages'] = {}
default['infisical']['infisical_core']['object_store']['objects']['packages']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['dependency_proxy'] = {}
default['infisical']['infisical_core']['object_store']['objects']['dependency_proxy']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['terraform_state'] = {}
default['infisical']['infisical_core']['object_store']['objects']['terraform_state']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['ci_secure_files'] = {}
default['infisical']['infisical_core']['object_store']['objects']['ci_secure_files']['bucket'] = nil
default['infisical']['infisical_core']['object_store']['objects']['pages'] = {}
default['infisical']['infisical_core']['object_store']['objects']['pages']['bucket'] = nil

default['infisical']['infisical_core']['artifacts_enabled'] = true
default['infisical']['infisical_core']['artifacts_path'] = nil
default['infisical']['infisical_core']['artifacts_object_store_enabled'] = false
default['infisical']['infisical_core']['artifacts_object_store_proxy_download'] = false
default['infisical']['infisical_core']['artifacts_object_store_remote_directory'] = 'artifacts'
default['infisical']['infisical_core']['artifacts_object_store_connection'] = {}
default['infisical']['infisical_core']['external_diffs_enabled'] = nil
default['infisical']['infisical_core']['external_diffs_when'] = nil
default['infisical']['infisical_core']['external_diffs_storage_path'] = nil
default['infisical']['infisical_core']['external_diffs_object_store_enabled'] = false
default['infisical']['infisical_core']['external_diffs_object_store_proxy_download'] = false
default['infisical']['infisical_core']['external_diffs_object_store_remote_directory'] = 'external-diffs'
default['infisical']['infisical_core']['external_diffs_object_store_connection'] = {}
default['infisical']['infisical_core']['lfs_enabled'] = nil
default['infisical']['infisical_core']['lfs_storage_path'] = nil
default['infisical']['infisical_core']['lfs_object_store_enabled'] = false
default['infisical']['infisical_core']['lfs_object_store_proxy_download'] = false
default['infisical']['infisical_core']['lfs_object_store_remote_directory'] = 'lfs-objects'
default['infisical']['infisical_core']['lfs_object_store_connection'] = {}
default['infisical']['infisical_core']['uploads_storage_path'] = nil
default['infisical']['infisical_core']['uploads_base_dir'] = nil
default['infisical']['infisical_core']['uploads_object_store_enabled'] = false
default['infisical']['infisical_core']['uploads_object_store_proxy_download'] = false
default['infisical']['infisical_core']['uploads_object_store_remote_directory'] = 'uploads'
default['infisical']['infisical_core']['uploads_object_store_connection'] = {}
default['infisical']['infisical_core']['packages_enabled'] = nil
default['infisical']['infisical_core']['packages_storage_path'] = nil
default['infisical']['infisical_core']['packages_object_store_enabled'] = false
default['infisical']['infisical_core']['packages_object_store_proxy_download'] = false
default['infisical']['infisical_core']['packages_object_store_remote_directory'] = 'packages'
default['infisical']['infisical_core']['packages_object_store_connection'] = {}
default['infisical']['infisical_core']['dependency_proxy_enabled'] = nil
default['infisical']['infisical_core']['dependency_proxy_storage_path'] = nil
default['infisical']['infisical_core']['dependency_proxy_object_store_enabled'] = false
default['infisical']['infisical_core']['dependency_proxy_object_store_proxy_download'] = false
default['infisical']['infisical_core']['dependency_proxy_object_store_remote_directory'] = 'dependency_proxy'
default['infisical']['infisical_core']['dependency_proxy_object_store_connection'] = {}
default['infisical']['infisical_core']['terraform_state_enabled'] = nil
default['infisical']['infisical_core']['terraform_state_storage_path'] = nil
default['infisical']['infisical_core']['terraform_state_object_store_enabled'] = false
default['infisical']['infisical_core']['terraform_state_object_store_remote_directory'] = 'terraform'
default['infisical']['infisical_core']['terraform_state_object_store_connection'] = {}
default['infisical']['infisical_core']['ci_secure_files_enabled'] = nil
default['infisical']['infisical_core']['ci_secure_files_storage_path'] = nil
default['infisical']['infisical_core']['ci_secure_files_object_store_enabled'] = false
default['infisical']['infisical_core']['ci_secure_files_object_store_remote_directory'] = 'ci-secure-files'
default['infisical']['infisical_core']['ci_secure_files_object_store_connection'] = {}
default['infisical']['infisical_core']['ldap_enabled'] = false
default['infisical']['infisical_core']['prevent_ldap_sign_in'] = false
default['infisical']['infisical_core']['ldap_servers'] = []
default['infisical']['infisical_core']['pages_enabled'] = false
default['infisical']['infisical_core']['pages_host'] = nil
default['infisical']['infisical_core']['pages_port'] = nil
default['infisical']['infisical_core']['pages_https'] = false
default['infisical']['infisical_core']['pages_path'] = nil
default['infisical']['infisical_core']['pages_object_store_enabled'] = false
default['infisical']['infisical_core']['pages_object_store_remote_directory'] = 'pages'
default['infisical']['infisical_core']['pages_object_store_connection'] = {}
default['infisical']['infisical_core']['pages_local_store_enabled'] = true
default['infisical']['infisical_core']['pages_local_store_path'] = nil
default['infisical']['infisical_core']['registry_enabled'] = false
default['infisical']['infisical_core']['registry_host'] = nil
default['infisical']['infisical_core']['registry_port'] = nil
default['infisical']['infisical_core']['registry_api_url'] = nil
default['infisical']['infisical_core']['registry_key_path'] = nil
default['infisical']['infisical_core']['registry_path'] = nil
default['infisical']['infisical_core']['registry_issuer'] = 'omnibus-infisical-issuer'
default['infisical']['infisical_core']['registry_notification_secret'] = nil
default['infisical']['infisical_core']['impersonation_enabled'] = nil
default['infisical']['infisical_core']['disable_animations'] = false
default['infisical']['infisical_core']['application_settings_cache_seconds'] = nil
default['infisical']['infisical_core']['sentry_enabled'] = false
default['infisical']['infisical_core']['sentry_dsn'] = nil
default['infisical']['infisical_core']['sentry_clientside_dsn'] = nil
default['infisical']['infisical_core']['sentry_environment'] = nil
default['infisical']['infisical_core']['usage_ping_enabled'] = nil
# Defaults set in libraries/infisical_core.rb
default['infisical']['infisical_core']['repositories_storages'] = {}

####
# These LDAP settings are deprecated in favor of the new syntax. They are kept here for backwards compatibility.
# Check
# https://infisical.com/infisical-org/omnibus-infisical/blob/935ab9e1700bfe8db6ba084e3687658d8921716f/README.md#setting-up-ldap-sign-in
# for the new syntax.
default['infisical']['infisical_core']['ldap_host'] = nil
default['infisical']['infisical_core']['ldap_base'] = nil
default['infisical']['infisical_core']['ldap_port'] = nil
default['infisical']['infisical_core']['ldap_uid'] = nil
default['infisical']['infisical_core']['ldap_method'] = nil
default['infisical']['infisical_core']['ldap_bind_dn'] = nil
default['infisical']['infisical_core']['ldap_password'] = nil
default['infisical']['infisical_core']['ldap_allow_username_or_email_login'] = nil
default['infisical']['infisical_core']['ldap_lowercase_usernames'] = nil
default['infisical']['infisical_core']['ldap_user_filter'] = nil
default['infisical']['infisical_core']['ldap_group_base'] = nil
default['infisical']['infisical_core']['ldap_admin_group'] = nil
default['infisical']['infisical_core']['ldap_sync_ssh_keys'] = nil
default['infisical']['infisical_core']['ldap_sync_time'] = nil
default['infisical']['infisical_core']['ldap_active_directory'] = nil
default['infisical']['infisical_core']['ldap_smartcard_ad_cert_field'] = nil
default['infisical']['infisical_core']['ldap_smartcard_ad_cert_format'] = nil
####

default['infisical']['infisical_core']['smartcard_enabled'] = false
default['infisical']['infisical_core']['smartcard_ca_file'] = '/etc/infisical/ssl/CA.pem'
default['infisical']['infisical_core']['smartcard_client_certificate_required_host'] = nil
default['infisical']['infisical_core']['smartcard_client_certificate_required_port'] = 3444
default['infisical']['infisical_core']['smartcard_required_for_git_access'] = false
default['infisical']['infisical_core']['smartcard_san_extensions'] = false

default['infisical']['infisical_core']['microsoft_graph_mailer_enabled'] = false
default['infisical']['infisical_core']['microsoft_graph_mailer_user_id'] = nil
default['infisical']['infisical_core']['microsoft_graph_mailer_tenant'] = nil
default['infisical']['infisical_core']['microsoft_graph_mailer_client_id'] = nil
default['infisical']['infisical_core']['microsoft_graph_mailer_client_secret'] = nil
default['infisical']['infisical_core']['microsoft_graph_mailer_azure_ad_endpoint'] = nil
default['infisical']['infisical_core']['microsoft_graph_mailer_graph_endpoint'] = nil

default['infisical']['infisical_core']['kerberos_enabled'] = nil
default['infisical']['infisical_core']['kerberos_keytab'] = nil
default['infisical']['infisical_core']['kerberos_service_principal_name'] = nil
default['infisical']['infisical_core']['kerberos_simple_ldap_linking_allowed_realms'] = nil
default['infisical']['infisical_core']['kerberos_use_dedicated_port'] = nil
default['infisical']['infisical_core']['kerberos_port'] = nil
default['infisical']['infisical_core']['kerberos_https'] = nil

default['infisical']['infisical_core']['omniauth_enabled'] = nil
default['infisical']['infisical_core']['omniauth_allow_single_sign_on'] = ['saml']
default['infisical']['infisical_core']['omniauth_sync_email_from_provider'] = nil
default['infisical']['infisical_core']['omniauth_sync_profile_from_provider'] = nil
default['infisical']['infisical_core']['omniauth_sync_profile_attributes'] = nil
default['infisical']['infisical_core']['omniauth_auto_sign_in_with_provider'] = nil
default['infisical']['infisical_core']['omniauth_block_auto_created_users'] = nil
default['infisical']['infisical_core']['omniauth_auto_link_ldap_user'] = nil
default['infisical']['infisical_core']['omniauth_auto_link_saml_user'] = nil
default['infisical']['infisical_core']['omniauth_auto_link_user'] = nil
default['infisical']['infisical_core']['omniauth_external_providers'] = nil
default['infisical']['infisical_core']['omniauth_providers'] = []
default['infisical']['infisical_core']['omniauth_cas3_session_duration'] = nil
default['infisical']['infisical_core']['omniauth_allow_bypass_two_factor'] = nil
default['infisical']['infisical_core']['omniauth_saml_message_max_byte_size'] = nil

default['infisical']['infisical_core']['forti_authenticator_enabled'] = false
default['infisical']['infisical_core']['forti_authenticator_host'] = nil
default['infisical']['infisical_core']['forti_authenticator_port'] = 443
default['infisical']['infisical_core']['forti_authenticator_username'] = nil
default['infisical']['infisical_core']['forti_authenticator_access_token'] = nil

default['infisical']['infisical_core']['duo_auth_enabled'] = false
default['infisical']['infisical_core']['duo_auth_integration_key'] = nil
default['infisical']['infisical_core']['duo_auth_secret_key'] = nil
default['infisical']['infisical_core']['duo_auth_hostname'] = nil

default['infisical']['infisical_core']['forti_token_cloud_enabled'] = false
default['infisical']['infisical_core']['forti_token_cloud_client_id'] = nil
default['infisical']['infisical_core']['forti_token_cloud_client_secret'] = nil

default['infisical']['infisical_core']['shared_path'] = '/var/opt/infisical/infisical-core/shared'
default['infisical']['infisical_core']['encrypted_settings_path'] = nil

default['infisical']['infisical_core']['backup_path'] = '/var/opt/infisical/backups'
default['infisical']['infisical_core']['backup_gitaly_backup_path'] = '/opt/infisical/embedded/bin/gitaly-backup'
default['infisical']['infisical_core']['manage_backup_path'] = true
default['infisical']['infisical_core']['backup_archive_permissions'] = nil
default['infisical']['infisical_core']['backup_pg_schema'] = nil
default['infisical']['infisical_core']['backup_keep_time'] = nil
default['infisical']['infisical_core']['backup_upload_connection'] = nil
default['infisical']['infisical_core']['backup_upload_remote_directory'] = nil
default['infisical']['infisical_core']['backup_upload_storage_options'] = {}
default['infisical']['infisical_core']['backup_multipart_chunk_size'] = nil
default['infisical']['infisical_core']['backup_encryption'] = nil
default['infisical']['infisical_core']['backup_encryption_key'] = nil
default['infisical']['infisical_core']['backup_storage_class'] = nil

# Path to the infisical Shell installation
# defaults to /opt/infisical/embedded/service/infisical-shell/. The install-dir path is set at build time
default['infisical']['infisical_core']['infisical_shell_path'] =
  "#{node['package']['install-dir']}/embedded/service/infisical-shell/"
# Path to the git hooks used by infisical Shell
# defaults to /opt/infisical/embedded/service/infisical-shell/hooks/. The install-dir path is set at build time
default['infisical']['infisical_core']['infisical_shell_hooks_path'] =
  "#{node['package']['install-dir']}/embedded/service/infisical-shell/hooks/"
default['infisical']['infisical_core']['infisical_shell_upload_pack'] = nil
default['infisical']['infisical_core']['infisical_shell_receive_pack'] = nil
default['infisical']['infisical_core']['infisical_shell_ssh_port'] = nil
default['infisical']['infisical_core']['infisical_shell_git_timeout'] = 10_800
# Path to the Git Executable
# defaults to /opt/infisical/embedded/bin/git. The install-dir path is set at build time
default['infisical']['infisical_core']['git_bin_path'] = "#{node['package']['install-dir']}/embedded/bin/git"
default['infisical']['infisical_core']['extra_google_analytics_id'] = nil
default['infisical']['infisical_core']['extra_google_tag_manager_id'] = nil
default['infisical']['infisical_core']['extra_one_trust_id'] = nil
default['infisical']['infisical_core']['extra_google_tag_manager_nonce_id'] = nil
default['infisical']['infisical_core']['extra_bizible'] = false
default['infisical']['infisical_core']['extra_matomo_url'] = nil
default['infisical']['infisical_core']['extra_matomo_site_id'] = nil
default['infisical']['infisical_core']['extra_matomo_disable_cookies'] = nil
default['infisical']['infisical_core']['extra_maximum_text_highlight_size_kilobytes'] = nil
default['infisical']['infisical_core']['rack_attack_git_basic_auth'] = nil

default['infisical']['infisical_core']['db_adapter'] = 'postgresql'
default['infisical']['infisical_core']['db_encoding'] = 'unicode'
default['infisical']['infisical_core']['db_collation'] = nil
default['infisical']['infisical_core']['db_database'] = 'infisicalhq_production'
default['infisical']['infisical_core']['db_username'] = 'infisical'
default['infisical']['infisical_core']['db_password'] = nil
default['infisical']['infisical_core']['db_load_balancing'] = { 'hosts' => [] }
# Path to postgresql socket directory
default['infisical']['infisical_core']['db_host'] = nil
default['infisical']['infisical_core']['db_port'] = 5432
default['infisical']['infisical_core']['db_socket'] = nil
default['infisical']['infisical_core']['db_sslmode'] = nil
default['infisical']['infisical_core']['db_sslcompression'] = 0
default['infisical']['infisical_core']['db_sslrootcert'] = nil
default['infisical']['infisical_core']['db_sslcert'] = nil
default['infisical']['infisical_core']['db_sslkey'] = nil
default['infisical']['infisical_core']['db_sslca'] = nil
default['infisical']['infisical_core']['db_prepared_statements'] = false
default['infisical']['infisical_core']['db_database_tasks'] = true
default['infisical']['infisical_core']['db_statements_limit'] = 1000
default['infisical']['infisical_core']['db_statement_timeout'] = nil
default['infisical']['infisical_core']['db_connect_timeout'] = nil
default['infisical']['infisical_core']['db_keepalives'] = nil
default['infisical']['infisical_core']['db_keepalives_idle'] = nil
default['infisical']['infisical_core']['db_keepalives_interval'] = nil
default['infisical']['infisical_core']['db_keepalives_count'] = nil
default['infisical']['infisical_core']['db_tcp_user_timeout'] = nil
default['infisical']['infisical_core']['db_application_name'] = nil
default['infisical']['infisical_core']['db_extra_config_command'] = nil

default['infisical']['infisical_core']['databases'] = {}

# used by workhorse to connect to a separate external redis instead of the omnibus-infisical redis
default['infisical']['infisical_core']['redis_workhorse_sentinel_master'] = nil

default['infisical']['infisical_core']['session_store_session_cookie_token_prefix'] = ''

default['infisical']['infisical_core']['redis_yml_override'] = nil

default['infisical']['infisical_core']['smtp_enable'] = false
default['infisical']['infisical_core']['smtp_address'] = nil
default['infisical']['infisical_core']['smtp_port'] = nil
default['infisical']['infisical_core']['smtp_user_name'] = nil
default['infisical']['infisical_core']['smtp_password'] = nil
default['infisical']['infisical_core']['smtp_domain'] = nil
default['infisical']['infisical_core']['smtp_authentication'] = nil
default['infisical']['infisical_core']['smtp_enable_starttls_auto'] = nil
default['infisical']['infisical_core']['smtp_tls'] = nil
default['infisical']['infisical_core']['smtp_openssl_verify_mode'] = nil
default['infisical']['infisical_core']['smtp_ca_path'] = nil
default['infisical']['infisical_core']['smtp_pool'] = false
# Path to the public Certificate Authority file
# defaults to /opt/infisical/embedded/ssl/certs/cacert.pem. The install-dir path is set at build time
default['infisical']['infisical_core']['smtp_ca_file'] =
  "#{node['package']['install-dir']}/embedded/ssl/certs/cacert.pem"
# These are defaults from Net::SMTP: https://ruby-doc.org/stdlib-3.0.0/libdoc/net/smtp/rdoc/Net/SMTP.html
default['infisical']['infisical_core']['smtp_open_timeout'] = 30
default['infisical']['infisical_core']['smtp_read_timeout'] = 60

# Path to directory that contains (ca) certificates that should also be trusted (e.g. on
# outgoing Webhooks connections). For these certificates symlinks will be created in
# /opt/infisical/embedded/ssl/certs/.
default['infisical']['infisical_core']['trusted_certs_dir'] = '/etc/infisical/trusted-certs'

default['infisical']['infisical_core']['webhook_timeout'] = nil

default['infisical']['infisical_core']['http_client'] = {}

default['infisical']['infisical_core']['graphql_timeout'] = nil

default['infisical']['infisical_core']['initial_root_password'] = nil
default['infisical']['infisical_core']['initial_license_file'] = nil
default['infisical']['infisical_core']['initial_shared_runners_registration_token'] = nil
default['infisical']['infisical_core']['display_initial_root_password'] = false
default['infisical']['infisical_core']['store_initial_root_password'] = false
default['infisical']['infisical_core']['trusted_proxies'] = []
default['infisical']['infisical_core']['content_security_policy'] = nil
default['infisical']['infisical_core']['allowed_hosts'] = []

####
# Web server
####
# Username for the webserver user
default['infisical']['web_server']['username'] = 'infisical-www'
default['infisical']['web_server']['group'] = 'infisical-www'
default['infisical']['web_server']['uid'] = nil
default['infisical']['web_server']['gid'] = nil
default['infisical']['web_server']['shell'] = '/bin/false'
default['infisical']['web_server']['home'] = '/var/opt/infisical/nginx'
# When bundled nginx is disabled we need to add the external webserver user to the infisical webserver group
default['infisical']['web_server']['external_users'] = []

####
# Nginx
####
default['infisical']['nginx']['enable'] = false
default['infisical']['nginx']['ha'] = false
default['infisical']['nginx']['dir'] = '/var/opt/infisical/nginx'
default['infisical']['nginx']['log_directory'] = '/var/log/infisical/nginx'
default['infisical']['nginx']['error_log_level'] = 'error'
default['infisical']['nginx']['worker_processes'] = [1, node.dig('cpu', 'total').to_i, node.dig('cpu', 'real').to_i].max
default['infisical']['nginx']['worker_connections'] = 10_240
default['infisical']['nginx']['log_format'] = '$remote_addr - $remote_user [$time_local] "$request_method $filtered_request_uri $server_protocol" $status $body_bytes_sent "$filtered_http_referer" "$http_user_agent" $gzip_ratio' #  NGINX 'combined' format without query strings
default['infisical']['nginx']['sendfile'] = 'on'
default['infisical']['nginx']['tcp_nopush'] = 'on'
default['infisical']['nginx']['tcp_nodelay'] = 'on'
default['infisical']['nginx']['hide_server_tokens'] = 'off'
default['infisical']['nginx']['gzip_http_version'] = '1.1'
default['infisical']['nginx']['gzip_comp_level'] = '2'
default['infisical']['nginx']['gzip_proxied'] = 'no-cache no-store private expired auth'
default['infisical']['nginx']['gzip_types'] =
  ['text/plain', 'text/css', 'application/x-javascript', 'text/xml', 'application/xml', 'application/xml+rss',
   'text/javascript', 'application/json']
default['infisical']['nginx']['keepalive_timeout'] = 65
default['infisical']['nginx']['keepalive_time'] = '1h'
default['infisical']['nginx']['client_max_body_size'] = 0
default['infisical']['nginx']['cache_max_size'] = '5000m'
default['infisical']['nginx']['redirect_http_to_https'] = false
default['infisical']['nginx']['redirect_http_to_https_port'] = 80
# The following matched paths will set proxy_request_buffering to off
default['infisical']['nginx']['request_buffering_off_path_regex'] =
  '/api/v\\d/jobs/\\d+/artifacts$|/import/infisical_project$|\\.git/git-receive-pack$|\\.git/ssh-receive-pack$|\\.git/ssh-upload-pack$|\\.git/infisical-lfs/objects|\\.git/info/lfs/objects/batch$'
default['infisical']['nginx']['ssl_client_certificate'] = nil # Most root CA's will be included by default
default['infisical']['nginx']['ssl_verify_client'] = nil # do not enable 2-way SSL client authentication
default['infisical']['nginx']['ssl_verify_depth'] = '1' # n/a if ssl_verify_client off
default['infisical']['nginx']['ssl_certificate'] = "/etc/infisical/ssl/#{node['fqdn']}.crt"
default['infisical']['nginx']['ssl_certificate_key'] = "/etc/infisical/ssl/#{node['fqdn']}.key"
default['infisical']['nginx']['ssl_ciphers'] = 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384' # settings from by https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&ocsp=false&guideline=5.6
default['infisical']['nginx']['ssl_prefer_server_ciphers'] = 'off' # settings from by https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&ocsp=false&guideline=5.6
default['infisical']['nginx']['ssl_protocols'] = 'TLSv1.2 TLSv1.3' # recommended by https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html & https://cipherli.st/
default['infisical']['nginx']['ssl_session_cache'] = 'shared:SSL:10m'
default['infisical']['nginx']['ssl_session_tickets'] = 'off'
default['infisical']['nginx']['ssl_session_timeout'] = '1d' # settings from by https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&ocsp=false&guideline=5.6
default['infisical']['nginx']['ssl_dhparam'] = nil # Path to dhparam.pem
default['infisical']['nginx']['ssl_password_file'] = nil
default['infisical']['nginx']['listen_addresses'] = ['*']
default['infisical']['nginx']['listen_port'] = nil # override only if you have a reverse proxy
default['infisical']['nginx']['listen_https'] = nil # override only if your reverse proxy internally communicates over HTTP
default['infisical']['nginx']['custom_infisical_server_config'] = nil
default['infisical']['nginx']['custom_nginx_config'] = nil
default['infisical']['nginx']['proxy_read_timeout'] = 3600
default['infisical']['nginx']['proxy_connect_timeout'] = 300
default['infisical']['nginx']['proxy_set_headers'] = {
  'Host' => '$http_host_with_default',
  'X-Real-IP' => '$remote_addr',
  'X-Forwarded-For' => '$proxy_add_x_forwarded_for',
  'Upgrade' => '$http_upgrade',
  'Connection' => '$connection_upgrade'
}
default['infisical']['nginx']['proxy_protocol'] = false
default['infisical']['nginx']['proxy_custom_buffer_size'] = nil
default['infisical']['nginx']['referrer_policy'] = 'strict-origin-when-cross-origin'
default['infisical']['nginx']['http2_enabled'] = true
# Cache up to 1GB of HTTP responses from infisical on disk
default['infisical']['nginx']['proxy_cache_path'] = 'proxy_cache keys_zone=infisical:10m max_size=1g levels=1:2'
# Set to 'off' to disable proxy caching.
default['infisical']['nginx']['proxy_cache'] = 'infisical'
# Config for the http_realip_module http://nginx.org/en/docs/http/ngx_http_realip_module.html
default['infisical']['nginx']['real_ip_trusted_addresses'] = [] # Each entry creates a set_real_ip_from directive
default['infisical']['nginx']['real_ip_header'] = nil
default['infisical']['nginx']['real_ip_recursive'] = nil
default['infisical']['nginx']['server_names_hash_bucket_size'] = 64
# HSTS
default['infisical']['nginx']['hsts_max_age'] = 63_072_000 # settings from by https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&ocsp=false&guideline=5.6
default['infisical']['nginx']['hsts_include_subdomains'] = false
# Compression
default['infisical']['nginx']['gzip_enabled'] = true

# Consul
default['infisical']['nginx']['consul_service_name'] = 'nginx'
default['infisical']['nginx']['consul_service_meta'] = nil

###
# Nginx status
###
default['infisical']['nginx']['status']['enable'] = true
default['infisical']['nginx']['status']['listen_addresses'] = ['*']
default['infisical']['nginx']['status']['fqdn'] = 'localhost'
default['infisical']['nginx']['status']['port'] = 8060
default['infisical']['nginx']['status']['vts_enable'] = true
default['infisical']['nginx']['status']['options'] = {
  'server_tokens' => 'off',
  'access_log' => 'off',
  'allow' => '127.0.0.1',
  'deny' => 'all'
}

###
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

###
# Remote syslog
###
default['infisical']['remote_syslog']['enable'] = false
default['infisical']['remote_syslog']['ha'] = false
default['infisical']['remote_syslog']['dir'] = '/var/opt/infisical/remote-syslog'
default['infisical']['remote_syslog']['log_directory'] = '/var/log/infisical/remote-syslog'
default['infisical']['remote_syslog']['destination_host'] = 'localhost'
default['infisical']['remote_syslog']['destination_port'] = 514
default['infisical']['remote_syslog']['services'] =
  %w[redis nginx puma infisical-core infisical-shell postgresql sidekiq infisical-workhorse infisical-pages praefect
     infisical-kas]

###
# High Availability
###
default['infisical']['high_availability']['mountpoint'] = nil
