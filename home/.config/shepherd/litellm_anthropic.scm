(define litellm-anthropic-service
  (make-litellm-service
    'litellm-anthropic
    "/.litellm/anthropic.yaml"
    "4000"
    "/.local/share/litellm.log"))
