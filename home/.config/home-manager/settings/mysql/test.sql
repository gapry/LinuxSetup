SELECT
  CURRENT_USER() = CONCAT(SUBSTRING_INDEX(USER(), '@', 1), '@localhost') AS same_os_user,
  (SELECT COUNT(*) = 1 FROM mysql.user
    WHERE User = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
      AND Host = 'localhost'
      AND plugin = 'auth_socket'
      AND account_locked = 'N') AS socket_auth,
  (SELECT COUNT(*) = 1 FROM mysql.user
    WHERE User = 'root'
      AND Host = 'localhost'
      AND account_locked = 'Y') AS root_locked;
