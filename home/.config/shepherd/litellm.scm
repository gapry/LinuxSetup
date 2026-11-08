(use-modules
  (ice-9 rdelim)
  (srfi srfi-1))

(define litellm-service
  (let ((home (getenv "HOME")))
    (service
      '(litellm)
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
              "--config" (string-append home "/.litellm/anthropic.yaml")
              "--host" "127.0.0.1"
              "--port" "4000")
            #:environment-variables
            (cons (string-append prefix key)
              (filter
                (lambda (variable)
                  (not (string-prefix? prefix variable)))
                (default-environment-variables)))
            #:log-file (string-append home "/.local/share/litellm.log")))))
      #:stop (make-kill-destructor)
      #:respawn? #t)))
