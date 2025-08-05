# Claude Code Development Environment

This directory provides a Docker-based development environment for Claude Code development. **This setup supports both Docker Compose and Visual Studio Code's Remote Containers functionality** for maximum flexibility.

## Directory Structure

```
.devcontainer/
├── devcontainer.json          # Basic configuration for VS Code Remote Containers
├── Dockerfile                 # Basic Dockerfile script (no VS Code required)
└── README.md                  # This file

.devcontainer-templates/
└── src/                       # Source configurations
    ├── linux/                 # Linux development environment
    │   ├── devcontainer.json  # Linux-specific VS Code configuration
    │   ├── Dockerfile
    │   ├── docker-compose.yml
    │   └── run.sh
    └── windows/               # Windows WSL2 development environment
        ├── devcontainer.json  # Windows-specific VS Code configuration
        ├── Dockerfile
        ├── docker-compose.yml
        └── run.sh
```

## Available Environments

### 1. **Linux** (Ubuntu 22.04 Development Environment)
- **Base**: `ubuntu:22.04`
- **Purpose**: Linux development, server environments, Docker-native development
- **Size**: ~3.0GB
- **Features**: Full Ubuntu ecosystem, comprehensive development tools, Jupyter support

### 2. **Windows** (WSL2 Development Environment)
- **Base**: `ubuntu:22.04` (WSL2 optimized)
- **Purpose**: Windows developers using WSL2, Windows integration
- **Size**: ~3.0GB
- **Features**: Windows WSL2 integration, cross-platform development, WSL2 optimizations

## Usage

### Method 1: Docker Compose (Recommended)
**No VS Code extension required**

1. **Start environment:**
   ```bash
   .devcontainer/run.sh linux start    # Start Linux environment
   .devcontainer/run.sh windows start  # Start Windows WSL2 environment
   ```

2. **Connect with your preferred editor:**
   ```bash
   .devcontainer/connect.sh linux vim      # Connect with Vim
   .devcontainer/connect.sh windows code   # Connect with VS Code
   .devcontainer/connect.sh linux shell    # Open shell only
   ```

### Method 2: VS Code Remote Containers
**Requires VS Code Remote Containers extension**

1. **Copy configuration to .devcontainer:**
   ```bash
   # For Linux environment
   cp .devcontainer-templates/src/linux/devcontainer.json .devcontainer/
   cp .devcontainer-templates/src/linux/Dockerfile .devcontainer/
   
   # For Windows environment
   cp .devcontainer-templates/src/windows/devcontainer.json .devcontainer/
   cp .devcontainer-templates/src/windows/Dockerfile .devcontainer/
   ```

2. **Open in VS Code and rebuild container:**
   - Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P)
   - Run "Dev Containers: Rebuild Container"

### Complete Commands (Docker Compose)

```bash
# Show help
.devcontainer/run.sh help

# List available environments
.devcontainer/run.sh list

# Start environment
.devcontainer/run.sh linux start
.devcontainer/run.sh windows start

# Stop environment
.devcontainer/run.sh linux stop
.devcontainer/run.sh windows stop

# Restart environment
.devcontainer/run.sh linux restart
.devcontainer/run.sh windows restart

# Build Docker image
.devcontainer/run.sh linux build
.devcontainer/run.sh windows build

# Access container shell
.devcontainer/run.sh linux shell
.devcontainer/run.sh windows shell

# View logs
.devcontainer/run.sh linux logs
.devcontainer/run.sh windows logs

# Clean environment (remove containers and volumes)
.devcontainer/run.sh linux clean
.devcontainer/run.sh windows clean
```

### Editor Connection Commands

```bash
# Show connection help
.devcontainer/connect.sh help

# Connect with different editors
.devcontainer/connect.sh linux vim      # Vim
.devcontainer/connect.sh linux nvim     # Neovim
.devcontainer/connect.sh linux code     # VS Code
.devcontainer/connect.sh linux sublime  # Sublime Text
.devcontainer/connect.sh linux webstorm # WebStorm
.devcontainer/connect.sh linux pycharm  # PyCharm
.devcontainer/connect.sh linux shell    # Shell only
```

## Features

All environments include:

- **Claude Code** extension and global installation
- **Node.js 20** with enhanced memory allocation
- **Python 3.11** with scientific computing packages
- **Jupyter Notebook & JupyterLab** support
- **Comprehensive VS Code extensions** for development
- **Enhanced shell environment** (zsh + powerline10k)
- **Persistent storage** (bash history, config, cache)
- **Developer user** with sudo access
- **Security and networking tools**
- **New York timezone** (America/New_York)

## Environment Variables

Environment variables set in all environments:

- `NODE_OPTIONS=--max-old-space-size=4096` - Increased Node.js memory limit
- `CLAUDE_CONFIG_DIR=/home/developer/.claude` - Claude configuration directory
- `POWERLEVEL9K_DISABLE_GITSTATUS=true` - Disable git status for performance
- `DEVCONTAINER=true` - Indicates running in devcontainer
- `TZ=America/New_York` - Eastern timezone (New York) setting

## Volume Mounts

- `claude-code-bashhistory` - Persistent command history
- `claude-code-config` - Claude configuration persistence
- `claude-code-cache` - Cache persistence

## Performance Considerations

- **Linux**: Best performance, full Ubuntu ecosystem, comprehensive toolchain
- **Windows WSL2**: Good performance with Windows integration, WSL2 optimizations

## Key Differences

### Linux Environment
- **User**: `developer` with sudo access
- **Base**: Ubuntu 22.04 LTS
- **Approach**: Dockerfile-based build
- **Features**: Full development toolchain, scientific computing stack

### Windows Environment
- **User**: `developer` with sudo access
- **Base**: Ubuntu 22.04 LTS (WSL2 optimized)
- **Approach**: Dockerfile-based build with WSL2 integration
- **Features**: Windows integration, cross-platform development tools

## Troubleshooting

### Common Issues

1. **Container build failure**: Check if Docker has sufficient disk space and memory
2. **Permission issues**: Ensure Docker is running with proper permissions
3. **Network issues**: Verify environment initialization script execution
4. **Package installation failures**: Try rebuilding with `--no-cache` flag

### Container Rebuild

```bash
# Force rebuild without cache
.devcontainer/run.sh linux build
.devcontainer/run.sh windows build

# Clean up unused containers and images
docker system prune -a
```

### Script Issues

If execution scripts don't work:

1. Check execution permissions: `chmod +x .devcontainer/run.sh`
2. Verify .devcontainer-templates directory structure
3. Check file permissions in .devcontainer-templates directories

### Understanding Configuration Differences

To understand differences between environments:

1. **Read comments** at the top of each Dockerfile for detailed explanations
2. **User differences**: Both use `developer` user with sudo access
3. **Path review**: Both use `/home/developer/.claude` for configuration
4. **Setup approach**: Both use Dockerfile-based builds with environment initialization scripts

## Security Features

- Non-root user execution (`developer`)
- Sudo access for specific commands
- Network capabilities for development
- Environment initialization scripts

## Contributing

When adding new environments:

1. Create new directory in `.devcontainer-templates/src/<name>/`
2. Add `devcontainer.json`, `Dockerfile`, `docker-compose.yml`, `run.sh`
3. Test environment thoroughly
4. Update this README with new options

## Support

For development environment issues:
- Check [Docker documentation](https://docs.docker.com/)
- Check [Dev Containers documentation](https://containers.dev/)
- Ensure Docker Desktop is running and properly configured
- Use `run.sh help` for script usage information

## Benefits of This Approach

- **Flexibility** - Choose between Docker Compose and VS Code Remote Containers
- **Editor independence** - Use any editor you prefer with Docker Compose
- **Faster startup** - Docker Compose has less overhead than VS Code extensions
- **Better automation** - Easy to script and integrate with CI/CD
- **More control** - Direct Docker management when needed
- **Cross-platform** - Consistent experience everywhere 