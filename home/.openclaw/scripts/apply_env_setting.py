import json
import os
import re

def load_env(file_path):
  env_vars = {}
  path = os.path.expanduser(file_path)
  if not os.path.exists(path):
    return env_vars
  with open(path, 'r') as f:
    for line in f:
      line = line.strip()
      if not line or line.startswith('#'):
        continue
      if '=' in line:
        key, value = line.split('=', 1)
        env_vars[key.strip()] = value.strip()
  return env_vars

def main():
  env_path = '~/.env'
  json_path = '~/.openclaw/openclaw.json'
  
  env_vars = load_env(env_path)
  full_json_path = os.path.expanduser(json_path)
  
  if not os.path.exists(full_json_path):
    return

  with open(full_json_path, 'r') as f:
    content = f.read()

  for key in sorted(env_vars.keys(), key=len, reverse=True):
    value = env_vars[key]
    pattern = r'(?<!")' + re.escape(key) + r'(?!")'
    
    if value.startswith('[') and value.endswith(']'):
      content = re.sub(pattern, value, content)
    elif value.startswith('~/'):
      expanded_path = os.path.expanduser(value)
      content = re.sub(pattern, f'"{expanded_path}"', content)
    else:
      content = re.sub(pattern, f'"{value}"', content)

  try:
    config = json.loads(content)
    with open(full_json_path, 'w') as f:
      json.dump(config, f, indent=2)
  except json.JSONDecodeError:
    pass

if __name__ == "__main__":
  main()

