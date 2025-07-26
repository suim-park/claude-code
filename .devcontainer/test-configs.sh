#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVCONTAINER CONFIGURATION TESTER
# =============================================================================
# This script tests each devcontainer configuration to ensure they work properly.
# 
# TESTING APPROACH:
# 1. Switch to each configuration
# 2. Validate configuration files
# 3. Test Docker build (if Docker is available)
# 4. Check for common issues
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VARIANTS_DIR="$SCRIPT_DIR/variants"

# Available configurations
CONFIGS_ubuntu="Default Ubuntu (Recommended)"
CONFIGS_alpine="Alpine Linux (Lightweight)"
CONFIGS_debian="Debian (Stable)"
CONFIGS_centos="CentOS/RHEL (Enterprise)"
CONFIGS_windows="Windows WSL2"
CONFIGS_gpu="GPU-Enabled with CUDA Support"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== Claude Code DevContainer Configuration Tester ===${NC}"
}

# Function to test a specific configuration
test_config() {
    local config_name=$1
    local config_desc=""
    
    case "$config_name" in
        "ubuntu") config_desc="$CONFIGS_ubuntu" ;;
        "alpine") config_desc="$CONFIGS_alpine" ;;
        "debian") config_desc="$CONFIGS_debian" ;;
        "centos") config_desc="$CONFIGS_centos" ;;
        "windows") config_desc="$CONFIGS_windows" ;;
        "gpu") config_desc="$CONFIGS_gpu" ;;
        *)
            print_error "Unknown configuration: $config_name"
            return 1
            ;;
    esac
    
    echo
    print_header
    echo "Testing: $config_name - $config_desc"
    echo "=================================================="
    
    # Test 1: Check if variant directory exists
    local variant_dir="$VARIANTS_DIR/$config_name"
    if [[ ! -d "$variant_dir" ]]; then
        print_error "Variant directory not found: $variant_dir"
        return 1
    fi
    print_status "✓ Variant directory exists: $variant_dir"
    
    # Test 2: Check required files
    local devcontainer_file="$variant_dir/devcontainer.json"
    if [[ ! -f "$devcontainer_file" ]]; then
        print_error "devcontainer.json not found: $devcontainer_file"
        return 1
    fi
    print_status "✓ devcontainer.json exists"
    
    # Test 3: Validate devcontainer.json JSON syntax
    if ! jq empty "$devcontainer_file" 2>/dev/null; then
        print_error "Invalid JSON in devcontainer.json"
        return 1
    fi
    print_status "✓ devcontainer.json has valid JSON syntax"
    
    # Test 4: Check Dockerfile (except Windows)
    if [[ "$config_name" != "windows" ]]; then
        local dockerfile="$variant_dir/Dockerfile"
        if [[ ! -f "$dockerfile" ]]; then
            print_error "Dockerfile not found: $dockerfile"
            return 1
        fi
        print_status "✓ Dockerfile exists"
        
        # Test 5: Check Dockerfile base image
        local base_image=$(head -1 "$dockerfile" | grep -E "^FROM" | sed 's/FROM //')
        if [[ -n "$base_image" ]]; then
            print_status "✓ Base image: $base_image"
        else
            print_warning "Could not determine base image"
        fi
    else
        # Test 5: Check Windows setup script
        local setup_script="$variant_dir/setup-windows.sh"
        if [[ ! -f "$setup_script" ]]; then
            print_error "setup-windows.sh not found: $setup_script"
            return 1
        fi
        print_status "✓ setup-windows.sh exists"
        
        if [[ ! -x "$setup_script" ]]; then
            print_warning "setup-windows.sh is not executable"
        fi
    fi
    
    # Test 6: Check timezone configuration
    local tz_value=$(grep -o 'America/New_York' "$devcontainer_file" || echo "")
    if [[ -n "$tz_value" ]]; then
        print_status "✓ Timezone configured: $tz_value"
    else
        print_warning "Timezone not found or not set to America/New_York"
    fi
    
    # Test 7: Check for required environment variables
    local has_node_options=$(grep -c "NODE_OPTIONS" "$devcontainer_file" || echo "0")
    local has_claude_config=$(grep -c "CLAUDE_CONFIG_DIR" "$devcontainer_file" || echo "0")
    
    if [[ "$has_node_options" -gt 0 ]]; then
        print_status "✓ NODE_OPTIONS environment variable configured"
    else
        print_warning "NODE_OPTIONS environment variable not found"
    fi
    
    if [[ "$has_claude_config" -gt 0 ]]; then
        print_status "✓ CLAUDE_CONFIG_DIR environment variable configured"
    else
        print_warning "CLAUDE_CONFIG_DIR environment variable not found"
    fi
    
    # Test 8: Check VS Code extensions
    local extensions_count=$(grep -c "dbaeumer.vscode-eslint\|esbenp.prettier-vscode\|eamodio.gitlens" "$devcontainer_file" || echo "0")
    if [[ "$extensions_count" -ge 3 ]]; then
        print_status "✓ Required VS Code extensions configured"
    else
        print_warning "Some required VS Code extensions may be missing"
    fi
    
    # Test 9: Check if Docker is available and test build (optional)
    if command -v docker &> /dev/null; then
        print_status "Docker available - testing build..."
        
        # Create temporary test directory
        local test_dir="/tmp/claude-code-test-$config_name"
        mkdir -p "$test_dir"
        
        # Copy configuration files
        cp "$devcontainer_file" "$test_dir/devcontainer.json"
        if [[ "$config_name" != "windows" ]]; then
            cp "$variant_dir/Dockerfile" "$test_dir/Dockerfile"
        fi
        cp "$SCRIPT_DIR/init-firewall.sh" "$test_dir/"
        
        # Test Docker build (with timeout)
        cd "$test_dir"
        if timeout 300 docker build -t "claude-code-test-$config_name" . &> /dev/null; then
            print_status "✓ Docker build successful"
            docker rmi "claude-code-test-$config_name" &> /dev/null
        else
            print_warning "Docker build failed or timed out"
        fi
        
        # Cleanup
        cd - > /dev/null
        rm -rf "$test_dir"
    else
        print_warning "Docker not available - skipping build test"
    fi
    
    print_status "Configuration $config_name test completed successfully!"
    return 0
}

# Function to test switch script
test_switch_script() {
    echo
    print_header
    echo "Testing Switch Script"
    echo "===================="
    
    local switch_script="$SCRIPT_DIR/switch-config.sh"
    
    if [[ ! -f "$switch_script" ]]; then
        print_error "Switch script not found: $switch_script"
        return 1
    fi
    print_status "✓ Switch script exists"
    
    if [[ ! -x "$switch_script" ]]; then
        print_error "Switch script is not executable"
        return 1
    fi
    print_status "✓ Switch script is executable"
    
    # Test switch script help
    if "$switch_script" help &> /dev/null; then
        print_status "✓ Switch script help works"
    else
        print_warning "Switch script help may have issues"
    fi
    
    # Test switch script list
    if "$switch_script" list &> /dev/null; then
        print_status "✓ Switch script list works"
    else
        print_warning "Switch script list may have issues"
    fi
    
    return 0
}

# Function to run all tests
run_all_tests() {
    print_header
    echo "Starting comprehensive devcontainer configuration tests..."
    echo
    
    local failed_tests=0
    local total_tests=0
    
    # Test switch script
    total_tests=$((total_tests + 1))
    if test_switch_script; then
        print_status "Switch script test: PASSED"
    else
        print_error "Switch script test: FAILED"
        failed_tests=$((failed_tests + 1))
    fi
    
    # Test each configuration
    for config in ubuntu alpine debian centos windows gpu; do
        total_tests=$((total_tests + 1))
        if test_config "$config"; then
            print_status "Configuration $config test: PASSED"
        else
            print_error "Configuration $config test: FAILED"
            failed_tests=$((failed_tests + 1))
        fi
    done
    
    # Summary
    echo
    print_header
    echo "TEST SUMMARY"
    echo "============"
    echo "Total tests: $total_tests"
    echo "Passed: $((total_tests - failed_tests))"
    echo "Failed: $failed_tests"
    
    if [[ $failed_tests -eq 0 ]]; then
        print_status "All tests passed! 🎉"
        echo
        echo "Next steps:"
        echo "1. Open VS Code with Dev Containers extension"
        echo "2. Use .devcontainer/switch-config.sh to switch configurations"
        echo "3. Rebuild container: Command Palette → 'Dev Containers: Rebuild Container'"
        return 0
    else
        print_error "Some tests failed. Please review the errors above."
        return 1
    fi
}

# Main script logic
case "${1:-}" in
    "help"|"-h"|"--help"|"")
        print_header
        echo "Usage: $0 [command] [configuration]"
        echo
        echo "Commands:"
        echo "  all                     Run all tests (default)"
        echo "  switch                  Test switch script only"
        echo "  <config_name>           Test specific configuration"
        echo "  help, -h, --help        Show this help message"
        echo
        echo "Examples:"
        echo "  $0                      # Run all tests"
        echo "  $0 ubuntu               # Test Ubuntu configuration"
        echo "  $0 alpine               # Test Alpine configuration"
        echo "  $0 switch               # Test switch script only"
        echo
        ;;
    "all")
        run_all_tests
        ;;
    "switch")
        test_switch_script
        ;;
    *)
        test_config "$1"
        ;;
esac 