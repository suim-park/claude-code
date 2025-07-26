#!/bin/bash

# Claude Code DevContainer Configuration Switcher
# This script helps you easily switch between different devcontainer configurations

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
    echo -e "${BLUE}=== Claude Code DevContainer Configuration Switcher ===${NC}"
}

# Function to show available configurations
show_configs() {
    print_header
    echo "Available configurations:"
    echo
    echo "  ubuntu - $CONFIGS_ubuntu"
    echo "  alpine - $CONFIGS_alpine"
    echo "  debian - $CONFIGS_debian"
    echo "  centos - $CONFIGS_centos"
    echo "  windows - $CONFIGS_windows"
    echo "  gpu - $CONFIGS_gpu"
    echo
}

# Function to switch to a specific configuration
switch_config() {
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
            echo "Use '$0 list' to see available configurations"
            exit 1
            ;;
    esac
    
    print_status "Switching to $config_desc configuration..."
    
    # Check if configuration files exist
    local variant_dir="$VARIANTS_DIR/$config_name"
    local devcontainer_file="$variant_dir/devcontainer.json"
    local dockerfile_file="$variant_dir/Dockerfile"
    
    if [[ ! -d "$variant_dir" ]]; then
        print_error "Variant directory not found: $variant_dir"
        exit 1
    fi
    
    if [[ ! -f "$devcontainer_file" ]]; then
        print_error "Configuration file not found: $devcontainer_file"
        exit 1
    fi
    
    # Backup current configuration if it exists
    if [[ -f "$SCRIPT_DIR/devcontainer.json" ]]; then
        cp "$SCRIPT_DIR/devcontainer.json" "$SCRIPT_DIR/devcontainer.json.backup"
        print_status "Backed up current configuration to devcontainer.json.backup"
    fi
    
    if [[ -f "$SCRIPT_DIR/Dockerfile" ]]; then
        cp "$SCRIPT_DIR/Dockerfile" "$SCRIPT_DIR/Dockerfile.backup"
        print_status "Backed up current Dockerfile to Dockerfile.backup"
    fi
    
    # Copy new configuration
    cp "$devcontainer_file" "$SCRIPT_DIR/devcontainer.json"
    print_status "Updated devcontainer.json"
    
    # Copy Dockerfile if it exists
    if [[ -f "$dockerfile_file" ]]; then
        cp "$dockerfile_file" "$SCRIPT_DIR/Dockerfile"
        print_status "Updated Dockerfile"
    else
        print_warning "No Dockerfile found for $config_name configuration"
    fi
    
    # Special handling for Windows configuration
    if [[ "$config_name" == "windows" ]]; then
        local setup_script="$variant_dir/setup-windows.sh"
        if [[ -f "$setup_script" ]]; then
            cp "$setup_script" "$SCRIPT_DIR/setup-windows.sh"
            chmod +x "$SCRIPT_DIR/setup-windows.sh"
            print_status "Copied and made setup-windows.sh executable"
        else
            print_warning "setup-windows.sh not found for Windows configuration"
        fi
    fi
    
    # Special handling for GPU configuration
    if [[ "$config_name" == "gpu" ]]; then
        local setup_script="$variant_dir/setup-gpu.sh"
        if [[ -f "$setup_script" ]]; then
            cp "$setup_script" "$SCRIPT_DIR/setup-gpu.sh"
            chmod +x "$SCRIPT_DIR/setup-gpu.sh"
            print_status "Copied and made setup-gpu.sh executable"
        else
            print_warning "setup-gpu.sh not found for GPU configuration"
        fi
    fi
    
    print_status "Successfully switched to $config_desc configuration!"
    echo
    print_warning "You need to rebuild your devcontainer for changes to take effect:"
    echo "  1. Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P)"
    echo "  2. Run 'Dev Containers: Rebuild Container'"
    echo "  3. Or close and reopen the project in VS Code"
}

# Function to restore backup
restore_backup() {
    if [[ -f "$SCRIPT_DIR/devcontainer.json.backup" ]]; then
        cp "$SCRIPT_DIR/devcontainer.json.backup" "$SCRIPT_DIR/devcontainer.json"
        print_status "Restored devcontainer.json from backup"
    fi
    
    if [[ -f "$SCRIPT_DIR/Dockerfile.backup" ]]; then
        cp "$SCRIPT_DIR/Dockerfile.backup" "$SCRIPT_DIR/Dockerfile"
        print_status "Restored Dockerfile from backup"
    fi
    
    print_status "Backup restored successfully!"
}

# Function to show current configuration
show_current() {
    print_header
    echo "Current configuration:"
    echo
    
    if [[ -f "$SCRIPT_DIR/devcontainer.json" ]]; then
        local name=$(grep '"name"' "$SCRIPT_DIR/devcontainer.json" | head -1 | sed 's/.*"name": *"\([^"]*\)".*/\1/')
        echo "  Name: $name"
        
        local dockerfile=$(grep '"dockerfile"' "$SCRIPT_DIR/devcontainer.json" | head -1 | sed 's/.*"dockerfile": *"\([^"]*\)".*/\1/')
        if [[ -n "$dockerfile" ]]; then
            echo "  Dockerfile: $dockerfile"
        fi
        
        local image=$(grep '"image"' "$SCRIPT_DIR/devcontainer.json" | head -1 | sed 's/.*"image": *"\([^"]*\)".*/\1/')
        if [[ -n "$image" ]]; then
            echo "  Image: $image"
        fi
    else
        print_error "No devcontainer.json found"
    fi
    echo
}

# Function to show variant information
show_variant_info() {
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
            exit 1
            ;;
    esac
    
    local variant_dir="$VARIANTS_DIR/$config_name"
    
    print_header
    echo "Variant Information: $config_desc"
    echo
    
    if [[ -d "$variant_dir" ]]; then
        echo "Files in $config_name variant:"
        ls -la "$variant_dir"
        echo
        
        if [[ -f "$variant_dir/devcontainer.json" ]]; then
            local name=$(grep '"name"' "$variant_dir/devcontainer.json" | head -1 | sed 's/.*"name": *"\([^"]*\)".*/\1/')
            echo "Configuration name: $name"
        fi
        
        if [[ -f "$variant_dir/Dockerfile" ]]; then
            local base_image=$(head -1 "$variant_dir/Dockerfile" | sed 's/FROM //')
            echo "Base image: $base_image"
        fi
    else
        print_error "Variant directory not found: $variant_dir"
    fi
    echo
}

# Main script logic
case "${1:-}" in
    "list"|"ls")
        show_configs
        ;;
    "current"|"status")
        show_current
        ;;
    "restore"|"backup")
        restore_backup
        ;;
    "info")
        if [[ -n "$2" ]]; then
            show_variant_info "$2"
        else
            print_error "Please specify a variant name for info"
            echo "Usage: $0 info <variant_name>"
        fi
        ;;
    "help"|"-h"|"--help"|"")
        print_header
        echo "Usage: $0 <command> [configuration]"
        echo
        echo "Commands:"
        echo "  list, ls                    Show available configurations"
        echo "  current, status             Show current configuration"
        echo "  <config_name>               Switch to specified configuration"
        echo "  info <config_name>          Show detailed info about a variant"
        echo "  restore, backup             Restore from backup"
        echo "  help, -h, --help            Show this help message"
        echo
        echo "Examples:"
        echo "  $0 list                     # Show all configurations"
        echo "  $0 alpine                   # Switch to Alpine Linux"
        echo "  $0 ubuntu                   # Switch to Ubuntu"
        echo "  $0 info alpine              # Show Alpine variant details"
        echo "  $0 restore                  # Restore from backup"
        echo
        ;;
    *)
        switch_config "$1"
        ;;
esac 