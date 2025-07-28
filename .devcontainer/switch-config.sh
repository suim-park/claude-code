#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVCONTAINER CONFIGURATION SWITCHER
# =============================================================================
# This script allows you to easily switch between different devcontainer
# configurations based on operating system requirements.
# 
# USAGE:
#   ./switch-config.sh <config_name>
#   ./switch-config.sh list
#   ./switch-config.sh help
# 
# AVAILABLE CONFIGURATIONS:
#   linux   - Linux development environment (Ubuntu 22.04)
#   windows - Windows WSL2 development environment
# =============================================================================

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"

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
    echo -e "${BLUE}=== Claude Code DevContainer Configuration Switcher ===${NC}"
}

# Function to show help
show_help() {
    print_header
    echo
    echo "Usage: $0 <config_name>"
    echo "       $0 list"
    echo "       $0 help"
    echo
    echo "Available configurations:"
    echo "  linux   - Linux development environment (Ubuntu 22.04)"
    echo "  windows - Windows WSL2 development environment"
    echo
    echo "Examples:"
    echo "  $0 linux    # Switch to Linux configuration"
    echo "  $0 windows  # Switch to Windows WSL2 configuration"
    echo "  $0 list     # List all available configurations"
    echo
    echo "After switching, rebuild your devcontainer:"
    echo "  Command Palette → 'Dev Containers: Rebuild Container'"
}

# Function to list available configurations
list_configs() {
    print_header
    echo "Available configurations:"
    echo
    echo "  linux - $CONFIGS_linux"
    echo "  windows - $CONFIGS_windows"
    echo
    echo "Use '$0 <config_name>' to switch to a configuration"
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
            echo "Use '$0 list' to see available configurations"
            exit 1
            ;;
    esac
    
    echo "$config_desc"
}

# Function to switch configuration
switch_config() {
    local config_name="$1"
    local config_desc="$2"
    local src_dir="$SRC_DIR/$config_name"
    
    print_header
    echo "Switching to: $config_desc"
    echo "=================================================="
    
    # Check if src directory exists
    if [[ ! -d "$src_dir" ]]; then
        print_error "Configuration directory not found: $src_dir"
        exit 1
    fi
    
    # Check if devcontainer.json exists
    if [[ ! -f "$src_dir/devcontainer.json" ]]; then
        print_error "devcontainer.json not found in $src_dir"
        exit 1
    fi
    
    # Create backup of current configuration
    if [[ -f "$SCRIPT_DIR/devcontainer.json" ]]; then
        local backup_file="$SCRIPT_DIR/devcontainer.json.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$SCRIPT_DIR/devcontainer.json" "$backup_file"
        print_info "Backup created: $(basename "$backup_file")"
    fi
    
    # Copy configuration files
    cp "$src_dir/devcontainer.json" "$SCRIPT_DIR/devcontainer.json"
    print_info "Copied devcontainer.json"
    
    # Copy Dockerfile if it exists
    if [[ -f "$src_dir/Dockerfile" ]]; then
        cp "$src_dir/Dockerfile" "$SCRIPT_DIR/Dockerfile"
        print_info "Copied Dockerfile"
    fi
    
    print_info "Successfully switched to $config_desc configuration!"
    echo
    echo "Next steps:"
    echo "1. Rebuild your devcontainer:"
    echo "   Command Palette → 'Dev Containers: Rebuild Container'"
    echo "2. Or restart VS Code and reopen in container"
    echo
    echo "Configuration files:"
    echo "  - devcontainer.json: Main configuration"
    if [[ -f "$SCRIPT_DIR/Dockerfile" ]]; then
        echo "  - Dockerfile: Container build instructions"
    fi
}

# Function to get current configuration
get_current_config() {
    local current_config=""
    
    if [[ -f "$SCRIPT_DIR/devcontainer.json" ]]; then
        # Try to determine current configuration based on content
        if grep -q '"name".*"Linux"' "$SCRIPT_DIR/devcontainer.json" 2>/dev/null; then
            current_config="linux"
        elif grep -q '"name".*"Windows"' "$SCRIPT_DIR/devcontainer.json" 2>/dev/null; then
            current_config="windows"
        else
            current_config="unknown"
        fi
    else
        current_config="none"
    fi
    
    echo "$current_config"
}

# Function to show current configuration
show_current_config() {
    local current_config=$(get_current_config)
    local config_desc=""
    
    case "$current_config" in
        "linux") config_desc="$CONFIGS_linux" ;;
        "windows") config_desc="$CONFIGS_windows" ;;
        "unknown") config_desc="Unknown configuration" ;;
        "none") config_desc="No configuration set" ;;
        *)
            print_error "Unknown configuration: $current_config"
            exit 1
            ;;
    esac
    
    print_header
    echo "Current configuration: $config_desc"
    echo
    echo "Use '$0 list' to see available configurations"
    echo "Use '$0 <config_name>' to switch configurations"
}

# Main script logic
main() {
    case "${1:-}" in
        "help"|"-h"|"--help")
            show_help
            ;;
        "list"|"-l"|"--list")
            list_configs
            ;;
        "current"|"-c"|"--current")
            show_current_config
            ;;
        "linux"|"windows")
            local config_desc=$(get_config_desc "$1")
            switch_config "$1" "$config_desc"
            ;;
        "")
            show_current_config
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 