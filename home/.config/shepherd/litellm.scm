(use-modules
  (ice-9 rdelim)
  (srfi srfi-1))

(define (make-litellm-service name config port log-file)
  (let ((home (getenv "HOME")))
    (service
      (list name)
      #:start
      (lambda ()
        (let* (
          (prefix "LITELLM_MASTER_KEY=")
          (key
            (call-with-input-file (string-append home "/.env")
              (lambda (port)
                (let loop ((line (read-line port)) (value #f))
                  (if (eof-object? line)
                    value
                    (loop (read-line port)
                      (if (string-prefix? prefix line)
                        (substring line (string-length prefix))
                        value))))))))
          (unless (and key (not (string-null? key)))
            (error "LITELLM_MASTER_KEY is missing from ~/.env"))
          ((make-forkexec-constructor
            (list
              (string-append home "/.local/bin/litellm")
              "--config" (string-append home config)
              "--host" "127.0.0.1"
              "--port" port)
            #:environment-variables
            (cons (string-append prefix key)
              (filter
                (lambda (variable)
                  (not (string-prefix? prefix variable)))
                (default-environment-variables)))
            #:log-file (string-append home log-file)))))
      #:stop (make-kill-destructor)
      #:respawn? #t)))
