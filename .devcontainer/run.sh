#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVELOPMENT ENVIRONMENT - MAIN RUNNER
# =============================================================================
# Run development environment using Docker Compose without Remote Containers.
# Choose between Linux and Windows environments.
# =============================================================================

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function definitions
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
    echo -e "${BLUE}=== Claude Code Development Environment ===${NC}"
}

# Show help
show_help() {
    print_header
    echo
    echo "Usage: $0 <environment> [command]"
    echo
    echo "Environments:"
    echo "  linux    - Linux development environment (Ubuntu 22.04)"
    echo "  windows  - Windows WSL2 development environment"
    echo
    echo "Commands:"
    echo "  start     - Start the development environment (default)"
    echo "  stop      - Stop the development environment"
    echo "  restart   - Restart the development environment"
    echo "  build     - Build the Docker image"
    echo "  shell     - Open shell in running container"
    echo "  logs      - Show container logs"
    echo "  clean     - Remove containers and volumes"
    echo "  help      - Show this help message"
    echo
    echo "Examples:"
    echo "  $0 linux start    # Start Linux environment"
    echo "  $0 windows shell  # Open shell in Windows environment"
    echo "  $0 linux logs     # View Linux logs"
    echo "  $0 windows clean  # Clean Windows environment"
    echo
    echo "Environment Variables:"
    echo "  TZ              - Timezone (default: America/New_York)"
    echo "  NODE_VERSION    - Node.js version (default: 20)"
    echo "  PYTHON_VERSION  - Python version (default: 3.11)"
    echo
    echo "Features:"
    echo "  - Claude Code extension and global installation"
    echo "  - Node.js 20 with enhanced memory allocation"
    echo "  - Python 3.11 with scientific computing packages"
    echo "  - Jupyter Notebook & JupyterLab support"
    echo "  - Enhanced shell environment (zsh + powerline10k)"
    echo "  - Persistent storage (bash history, config, cache)"
    echo "  - New York timezone (America/New_York)"
}

# Check environment
check_environment() {
    local env="$1"
    local env_dir="$SRC_DIR/$env"
    
    if [[ ! -d "$env_dir" ]]; then
        print_error "Environment '$env' not found: $env_dir"
        echo "Available environments:"
        echo "  - linux"
        echo "  - windows"
        exit 1
    fi
    
    if [[ ! -f "$env_dir/run.sh" ]]; then
        print_error "Run script not found for environment '$env': $env_dir/run.sh"
        exit 1
    fi
    
    if [[ ! -f "$env_dir/docker-compose.yml" ]]; then
        print_error "Docker Compose file not found for environment '$env': $env_dir/docker-compose.yml"
        exit 1
    fi
    
    if [[ ! -f "$env_dir/Dockerfile" ]]; then
        print_error "Dockerfile not found for environment '$env': $env_dir/Dockerfile"
        exit 1
    fi
}

# Run environment
run_environment() {
    local env="$1"
    local command="$2"
    local env_dir="$SRC_DIR/$env"
    
    print_info "Running $env environment with command: ${command:-start}"
    
    # Check environment
    check_environment "$env"
    
    # Call environment-specific run script
    "$env_dir/run.sh" "${command:-start}"
}

# List available environments
list_environments() {
    print_header
    echo "Available environments:"
    echo
    echo "  linux - Linux Development Environment (Ubuntu 22.04)"
    echo "    - Full Ubuntu ecosystem"
    echo "    - Comprehensive development tools"
    echo "    - Jupyter support"
    echo "    - Size: ~3.0GB"
    echo
    echo "  windows - Windows WSL2 Development Environment"
    echo "    - WSL2 integration"
    echo "    - Cross-platform development"
    echo "    - Windows optimizations"
    echo "    - Size: ~3.0GB"
    echo
    echo "Use '$0 <environment> [command]' to run an environment"
}

# Main logic
main() {
    case "${1:-}" in
        "help"|"-h"|"--help"|"")
            show_help
            ;;
        "list"|"ls")
            list_environments
            ;;
        "linux"|"windows")
            local env="$1"
            local command="${2:-start}"
            run_environment "$env" "$command"
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@" 