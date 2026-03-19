(use-modules (shepherd service))

(load (string-append (getenv "HOME") "/.config/shepherd/cloudflared.scm"))

(register-services (list dns-service))

(start-in-the-background '(dns))
