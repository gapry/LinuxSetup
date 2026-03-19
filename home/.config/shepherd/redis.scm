(define redis-service
  (let ((data-dir (string-append (getenv "HOME") "/.local/share/redis"))
        (run-dir  (string-append (getenv "HOME") "/.local/run/redis"))
        (conf-file (string-append (getenv "HOME") "/.config/redis/redis.conf")))
    
    (service
      '(redis database)
      #:requirement '()
      #:start (lambda ()
                (let loop ((dirs (list data-dir run-dir)))
                  (unless (null? dirs)
                    (unless (file-exists? (car dirs))
                      (mkdir-p (car dirs)))
                    (loop (cdr dirs))))
                
                (make-forkexec-constructor
                 (list "redis-server" conf-file)))
      #:stop (make-kill-destructor)
      #:respawn? #t)))

