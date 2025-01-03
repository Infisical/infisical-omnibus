require 'socket'

module Patroni
  class << self
    def parse_variables
      return unless Services.enabled?('patroni')

      Infisical['patroni']['connect_address'] ||= private_ipv4 || Infisical['node']['ipaddress']
      Infisical['patroni']['connect_port'] ||= Infisical['patroni']['port'] || Infisical['node']['patroni']['port']

      check_consul_is_enabled
      parse_postgresql_overrides
      auto_detect_wal_log_hint
    end

    def private_ipv4
      Socket.getifaddrs.select { |ifaddr| ifaddr.addr&.ipv4_private? }.first&.addr&.ip_address
    end

    private

    POSTGRESQL_DCS_PARAMETERS ||= %w[
      max_connections
      max_locks_per_transaction
      max_worker_processes
      max_prepared_transactions
      track_commit_timestamp
      max_wal_senders
      max_replication_slots
      wal_keep_segments
      wal_keep_size
      checkpoint_timeout
    ].freeze

    def check_consul_is_enabled
      return if Services.enabled?('consul')

      LoggingHelper.warning('Patroni is enabled but Consul seems to be disabled. Patroni requires Consul to be enabled.')
    end

    def postgresql_setting(key)
      Infisical['postgresql'][key] || Infisical['node']['patroni']['postgresql']&.[](key) || Infisical['node']['postgresql'][key]
    end

    # These attributes are the postgres settings that patroni manages through its DCS,
    # but that we also have existing settings for in our postgresql defaults.
    # DCS only config settings are documented here: https://patroni.readthedocs.io/en/latest/dynamic_configuration.html
    # We will use the existing `postgresql[]` setting for patroni DCS, if a patroni specific
    # one hasn't been specified in infisical.rb
    def parse_postgresql_overrides
      Infisical['patroni']['postgresql'] ||= {}
      POSTGRESQL_DCS_PARAMETERS.each do |key|
        Infisical['patroni']['postgresql'][key] ||= postgresql_setting(key)
      end
    end

    # `wal_log_hints` must be `on` for `pg_rewind`
    def auto_detect_wal_log_hint
      return if Infisical['patroni']['postgresql']['wal_log_hints']

      Infisical['patroni']['postgresql']['wal_log_hints'] =
        Infisical['patroni']['use_pg_rewind'] ? 'on' : postgresql_setting('wal_log_hints')
    end
  end
end
