(define mysql-service
  (let* ((home (getenv "HOME"))
         (data-dir (string-append home "/.local/share/mysql"))
         (runtime-dir (string-append home "/.local/run/mysql")))
    (service
      '(mysql)
      #:start
      (lambda ()
        (when (file-exists? (string-append data-dir ".bootstrap-incomplete"))
          (error "MySQL initialization was interrupted; manual recovery is required."))
        (unless (file-exists? (string-append data-dir "/.shepherd-auth-configured"))
          (error "MySQL initialization has not completed."))
        (unless (file-exists? runtime-dir)
          (mkdir-p runtime-dir))
        (chmod runtime-dir #o700)
        ((make-forkexec-constructor
          (list
            (string-append home "/.nix-profile/bin/mysqld")
            (string-append "--defaults-file=" home "/.my.cnf")))))
      #:stop (make-kill-destructor)
      #:respawn? #t)))
