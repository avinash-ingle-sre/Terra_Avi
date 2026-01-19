#!/bin/bash
set -e

echo "=== YAML Validation Suite ==="

# Function to validate YAML files
validate_yaml() {
    local file="$1"
    echo -n "Validating $file: "
    
    # Basic syntax check
    if yamllint "$file" >/dev/null 2>&1; then
        echo -n "✓ Lint "
    else
        echo "✗ Lint failed"
        return 1
    fi
    
    # Python parsing check
    if python3 -c "import yaml; yaml.safe_load(open('$file'))" >/dev/null 2>&1; then
        echo -n "✓ Parse "
    else
        echo "✗ Parse failed"
        return 1
    fi
    
    echo "✓ All checks passed"
    return 0
}

# Validate all YAML files
failed=0
for file in *.yaml *.yml; do
    if [ -f "$file" ]; then
        if ! validate_yaml "$file"; then
            failed=$((failed + 1))
        fi
    fi
done

echo "=== Summary ==="
if (( failed == 0 )); then
    echo "All YAML files are valid ✓"
    exit 0
else
    echo "$failed files failed validation ✗"
    exit 1
fi
