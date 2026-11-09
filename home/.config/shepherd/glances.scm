(define glances-service
  (service
    '(glances)
    #:start (make-forkexec-constructor
             (list "glances" "--webserver" "--bind" "127.0.0.1" "--port" "61208"))
    #:stop (make-kill-destructor)
    #:respawn? #t))
