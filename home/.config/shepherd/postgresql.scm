(use-modules (srfi srfi-1))

(define postgresql-service
  (let* ((home (getenv "HOME"))
         (data-dir (string-append home "/.local/share/postgresql"))
         (socket-dir (string-append home "/.local/run/postgres")))
    (service
      '(postgresql)
      #:start
      (lambda ()
        (when (file-exists? (string-append data-dir ".bootstrap-incomplete"))
          (error "PostgreSQL initialization was interrupted; manual recovery is required."))
        (unless (file-exists? (string-append data-dir "/PG_VERSION"))
          (error "PostgreSQL initialization has not completed."))
        (unless (file-exists? socket-dir)
          (mkdir-p socket-dir))
        (chmod socket-dir #o700)
        ((make-forkexec-constructor
          (list
            (string-append home "/.nix-profile/bin/postgres")
            "-D" data-dir
            "-c" (string-append "config_file=" home "/.config/postgresql/postgresql.conf"))
          #:environment-variables
          (cons "LC_ALL=C"
            (filter
              (lambda (variable)
                (not (string-prefix? "LC_ALL=" variable)))
              (default-environment-variables))))))
      #:stop (make-kill-destructor SIGINT #:grace-period 300)
      #:respawn? #t)))
