(use-modules (shepherd service))

(define config-dir (string-append (getenv "HOME") "/.config/shepherd/"))

(load (string-append config-dir "cloudflared.scm"))
(load (string-append config-dir "redis.scm"))
(load (string-append config-dir "glances.scm"))
(load (string-append config-dir "litellm.scm"))
(load (string-append config-dir "litellm_anthropic.scm"))
(load (string-append config-dir "litellm_openai.scm"))

(define services-list
  (list dns-service 
        redis-service
        glances-service
        litellm-anthropic-service
        litellm-openai-service))

(register-services services-list)

(define daemon-list '(dns redis glances))

(start-in-the-background daemon-list)
