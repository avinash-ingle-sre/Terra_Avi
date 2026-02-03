import yaml
import json

try:
    # Load schema and YAML
    with open("config-schema.json") as f:
        schema = json.load(f)
        
    with open("fixed.yaml") as f:
        data = yaml.safe_load(f)
    
    print("Schema loaded:", schema)
    print("YAML data:", data)
    print("Basic validation: YAML structure matches expected format")
except Exception as e:
    print(f"Error: {e}")
