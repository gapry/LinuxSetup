(define litellm-openai-service
  (make-litellm-service
    'litellm-openai
    "/.litellm/openai.yaml"
    "4001"
    "/.local/share/litellm-openai.log"))
