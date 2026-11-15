SELECT
  system_user = 'peer:' || current_user AS peer_identity,
  (SELECT rolsuper FROM pg_roles WHERE rolname = current_user) AS superuser,
  current_database() = 'postgres' AS default_database,
  current_setting('listen_addresses') = '' AS tcp_disabled,
  NOT EXISTS (
    SELECT 1 FROM pg_hba_file_rules
    WHERE type <> 'local' OR auth_method <> 'peer' OR error IS NOT NULL
  ) AS peer_only;
