(use-modules (shepherd service))

(define config-dir (string-append (getenv "HOME") "/.config/shepherd/"))

(load (string-append config-dir "cloudflared.scm"))
(load (string-append config-dir "redis.scm"))

(define services-list
  (list dns-service 
        redis-service))

(register-services services-list)

(define daemon-list '(dns redis))

(start-in-the-background daemon-list)
