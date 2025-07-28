#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVELOPMENT ENVIRONMENT - LINUX
# =============================================================================
# Run Linux development environment using Docker Compose.
# Runs without Remote Containers using standard Docker.
# =============================================================================

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

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
    echo -e "${BLUE}=== Claude Code Linux Development Environment ===${NC}"
}

# Show help
show_help() {
    print_header
    echo
    echo "Usage: $0 [command]"
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
    echo "  $0 start    # Start development environment"
    echo "  $0 shell    # Open shell in container"
    echo "  $0 logs     # View logs"
    echo
    echo "Environment Variables:"
    echo "  TZ              - Timezone (default: America/New_York)"
    echo "  NODE_VERSION    - Node.js version (default: 20)"
    echo "  PYTHON_VERSION  - Python version (default: 3.11)"
    echo "  UBUNTU_VERSION  - Ubuntu version (default: 22.04)"
}

# Run Docker Compose
run_docker_compose() {
    local command="$1"
    cd "$SCRIPT_DIR"
    
    if [[ "$command" == "build" ]]; then
        print_info "Building Docker image..."
        docker-compose build --no-cache
    elif [[ "$command" == "start" ]]; then
        print_info "Starting development environment..."
        docker-compose up -d
        print_info "Development environment started!"
        echo
        echo "Available services:"
        echo "  - Jupyter Notebook: http://localhost:8888"
        echo "  - JupyterLab: http://localhost:8889"
        echo "  - Development server: http://localhost:3000"
        echo "  - Alternative server: http://localhost:8080"
        echo "  - Vite server: http://localhost:5173"
        echo
        echo "To open shell: $0 shell"
        echo "To view logs: $0 logs"
    elif [[ "$command" == "stop" ]]; then
        print_info "Stopping development environment..."
        docker-compose down
    elif [[ "$command" == "restart" ]]; then
        print_info "Restarting development environment..."
        docker-compose restart
    elif [[ "$command" == "shell" ]]; then
        print_info "Opening shell in container..."
        docker-compose exec claude-code-linux /bin/zsh
    elif [[ "$command" == "logs" ]]; then
        print_info "Showing container logs..."
        docker-compose logs -f
    elif [[ "$command" == "clean" ]]; then
        print_warning "This will remove all containers and volumes!"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cleaning up containers and volumes..."
            docker-compose down -v --remove-orphans
            docker system prune -f
            print_info "Cleanup completed!"
        else
            print_info "Cleanup cancelled."
        fi
    else
        print_error "Unknown command: $command"
        show_help
        exit 1
    fi
}

# Main logic
main() {
    case "${1:-start}" in
        "help"|"-h"|"--help")
            show_help
            ;;
        "start"|"stop"|"restart"|"build"|"shell"|"logs"|"clean")
            run_docker_compose "$1"
            ;;
        "")
            run_docker_compose "start"
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Execute main function
main "$@" 