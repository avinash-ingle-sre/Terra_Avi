import yaml
import os

def safe_yaml_load(filename, max_size=1024):
    file_size = os.path.getsize(filename)
    if file_size > max_size:
        print(f"File too large: {file_size} bytes")
        return None
    
    with open(filename) as f:
        return yaml.safe_load(f)

data = safe_yaml_load("yaml-bomb-demo.yaml")
if data:
    print(f"Safely loaded YAML file")
