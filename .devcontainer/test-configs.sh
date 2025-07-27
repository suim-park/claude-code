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

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VARIANT_DIR="$SCRIPT_DIR/variants"

# Available configurations
CONFIGS_linux="Linux Development Environment (Ubuntu 22.04)"
CONFIGS_windows="Windows WSL2 Development Environment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
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

# Function to get configuration description
get_config_desc() {
    local config_name="$1"
    local config_desc=""
    
    case "$config_name" in
        "linux") config_desc="$CONFIGS_linux" ;;
        "windows") config_desc="$CONFIGS_windows" ;;
        *)
            print_error "Unknown configuration: $config_name"
            return 1
            ;;
    esac
    
    echo "$config_desc"
}

# Function to test a single configuration
test_config() {
    local config_name="$1"
    local config_desc="$2"
    local variant_dir="$VARIANT_DIR/$config_name"
    
    echo
    echo "Testing: $config_name - $config_desc"
    echo "=================================================="
    
    # Test 1: Check if variant directory exists
    if [[ -d "$variant_dir" ]]; then
        print_info "✓ Variant directory exists: $variant_dir"
    else
        print_error "✗ Variant directory not found: $variant_dir"
        return 1
    fi
    
    # Test 2: Check if devcontainer.json exists
    if [[ -f "$variant_dir/devcontainer.json" ]]; then
        print_info "✓ devcontainer.json exists"
    else
        print_error "✗ devcontainer.json not found"
        return 1
    fi
    
    # Test 3: Validate JSON syntax
    if python3 -m json.tool "$variant_dir/devcontainer.json" > /dev/null 2>&1; then
        print_info "✓ devcontainer.json has valid JSON syntax"
    else
        print_error "✗ Invalid JSON in devcontainer.json"
        return 1
    fi
    
    # Test 4: Check if Dockerfile exists (for Linux)
    if [[ "$config_name" == "linux" ]]; then
        if [[ -f "$variant_dir/Dockerfile" ]]; then
            print_info "✓ Dockerfile exists"
            
            # Try to determine base image
            local base_image=$(head -1 "$variant_dir/Dockerfile" | sed 's/FROM //' 2>/dev/null || echo "")
            if [[ -n "$base_image" ]]; then
                print_info "✓ Base image: $base_image"
            else
                print_warning "Could not determine base image"
            fi
        else
            print_error "✗ Dockerfile not found for Linux configuration"
            return 1
        fi
    fi
    
    # Test 5: Check if setup script exists (for Windows)
    if [[ "$config_name" == "windows" ]]; then
        if [[ -f "$variant_dir/setup-windows.sh" ]]; then
            print_info "✓ setup-windows.sh exists"
            
            # Check if script is executable
            if [[ -x "$variant_dir/setup-windows.sh" ]]; then
                print_info "✓ setup-windows.sh is executable"
            else
                print_warning "setup-windows.sh is not executable"
            fi
        else
            print_error "✗ setup-windows.sh not found for Windows configuration"
            return 1
        fi
    fi
    
    # Test 6: Check timezone configuration
    if grep -q "America/New_York" "$variant_dir/devcontainer.json" 2>/dev/null; then
        print_info "✓ Timezone configured: America/New_York"
    else
        print_warning "Timezone not found or not set to America/New_York"
    fi
    
    # Test 7: Check environment variables
    if grep -q "NODE_OPTIONS" "$variant_dir/devcontainer.json" 2>/dev/null; then
        print_info "✓ NODE_OPTIONS environment variable configured"
    else
        print_warning "NODE_OPTIONS environment variable not found"
    fi
    
    if grep -q "CLAUDE_CONFIG_DIR" "$variant_dir/devcontainer.json" 2>/dev/null; then
        print_info "✓ CLAUDE_CONFIG_DIR environment variable configured"
    else
        print_warning "CLAUDE_CONFIG_DIR environment variable not found"
    fi
    
    # Test 8: Check VS Code extensions
    if grep -q "anthropic.claude-code" "$variant_dir/devcontainer.json" 2>/dev/null; then
        print_info "✓ Required VS Code extensions configured"
    else
        print_warning "Required VS Code extensions not found"
    fi
    
    # Test 9: Test Docker build (if Docker is available)
    if command -v docker &> /dev/null; then
        if [[ "$config_name" == "linux" ]]; then
            print_info "Testing Docker build..."
            if docker build --dry-run -f "$variant_dir/Dockerfile" "$variant_dir" > /dev/null 2>&1; then
                print_info "✓ Docker build test passed"
            else
                print_warning "Docker build test failed"
            fi
        fi
    else
        print_warning "Docker not available - skipping build test"
    fi
    
    print_info "Configuration $config_name test completed successfully!"
    return 0
}

# Function to test all configurations
test_all_configs() {
    print_header
    echo "Testing all devcontainer configurations..."
    echo
    
    local total_tests=0
    local passed_tests=0
    
    # Test each configuration
    for config in linux windows; do
        total_tests=$((total_tests + 1))
        if test_config "$config" "$(get_config_desc "$config")"; then
            passed_tests=$((passed_tests + 1))
        fi
    done
    
    echo
    echo "=================================================="
    echo "Test Results: $passed_tests/$total_tests configurations passed"
    
    if [[ $passed_tests -eq $total_tests ]]; then
        print_info "🎉 All configurations are working correctly!"
    else
        print_error "⚠️  Some configurations have issues. Check the output above."
        exit 1
    fi
}

# Function to test switch script
test_switch_script() {
    print_header
    echo "Testing switch script functionality..."
    echo
    
    local switch_script="$SCRIPT_DIR/switch-config.sh"
    
    if [[ -f "$switch_script" ]]; then
        print_info "✓ Switch script exists"
        
        if [[ -x "$switch_script" ]]; then
            print_info "✓ Switch script is executable"
        else
            print_warning "Switch script is not executable"
        fi
        
        # Test list command
        if "$switch_script" list > /dev/null 2>&1; then
            print_info "✓ Switch script list command works"
        else
            print_error "✗ Switch script list command failed"
        fi
        
        # Test help command
        if "$switch_script" help > /dev/null 2>&1; then
            print_info "✓ Switch script help command works"
        else
            print_error "✗ Switch script help command failed"
        fi
        
    else
        print_error "✗ Switch script not found"
        return 1
    fi
    
    print_info "Switch script test completed successfully!"
}

# Main script logic
main() {
    case "${1:-}" in
        "all")
            test_all_configs
            test_switch_script
            ;;
        "linux"|"windows")
            test_config "$1" "$(get_config_desc "$1")"
            ;;
        "switch")
            test_switch_script
            ;;
        "help"|"-h"|"--help")
            print_header
            echo
            echo "Usage: $0 <command>"
            echo
            echo "Commands:"
            echo "  all     - Test all configurations"
            echo "  linux   - Test Linux configuration"
            echo "  windows - Test Windows configuration"
            echo "  switch  - Test switch script functionality"
            echo "  help    - Show this help message"
            echo
            echo "Examples:"
            echo "  $0 all     # Test all configurations"
            echo "  $0 linux   # Test Linux configuration only"
            echo "  $0 switch  # Test switch script only"
            ;;
        "")
            test_all_configs
            ;;
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 