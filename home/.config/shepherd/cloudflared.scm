(define dns-service
  (service
    '(dns cloudflared) 
    #:start (make-forkexec-constructor
             (list "cloudflared" "proxy-dns" 
                   "--address" "127.0.0.1" 
                   "--port" "5354" 
                   "--upstream" "https://1.1.1.1/dns-query"))
    #:stop (make-kill-destructor)
    #:respawn? #t)) 
