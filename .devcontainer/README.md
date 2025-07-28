# Claude Code DevContainer Configurations

This directory contains multiple devcontainer configurations for different operating system environments, optimized for Claude Code development.

## Directory Structure

```
.devcontainer/
├── devcontainer.json          # Active configuration (copied from src/)
├── Dockerfile                 # Active Dockerfile (copied from src/)
├── switch-config.sh           # Configuration switching script
├── test-configs.sh            # Configuration testing script
├── README.md                  # This file
└── src/                       # Source configurations
    ├── linux/                 # Linux Development Environment
    │   ├── devcontainer.json
    │   └── Dockerfile
    └── windows/               # Windows WSL2 Development Environment
        ├── devcontainer.json
        └── Dockerfile
```

## Available Configurations

### 1. **Linux** (Ubuntu 22.04 Development)
- **Base**: `ubuntu:22.04`
- **Best for**: Linux development, server environments, Docker-native development
- **Size**: ~3.0GB
- **Features**: Full Ubuntu ecosystem, comprehensive development tools, Jupyter support

### 2. **Windows** (WSL2 Development)
- **Base**: `ubuntu:22.04` (optimized for WSL2)
- **Best for**: Windows developers using WSL2, Windows integration
- **Size**: ~3.0GB
- **Features**: Windows WSL2 integration, cross-platform development, WSL2 optimizations

## How to Use

### Quick Start

1. **Switch to a configuration:**
   ```bash
   .devcontainer/switch-config.sh linux    # Linux environment
   .devcontainer/switch-config.sh windows  # Windows WSL2 environment
   ```

2. **Rebuild the container:**
   - Open Command Palette (Ctrl+Shift+P / Cmd+Shift+P)
   - Run "Dev Containers: Rebuild Container"

### Manual Configuration

If you prefer to manually copy files:

```bash
# For Linux
cp .devcontainer/src/linux/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/src/linux/Dockerfile .devcontainer/Dockerfile

# For Windows WSL2
cp .devcontainer/src/windows/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/src/windows/Dockerfile .devcontainer/Dockerfile
```

## Features

All configurations include:

- **Claude Code** extension and global installation
- **Node.js 20** runtime with enhanced memory allocation
- **Python 3.11** with scientific computing packages
- **Jupyter Notebook & JupyterLab** support
- **Comprehensive VS Code extensions** for development
- **Enhanced shell environment** (zsh + powerline10k)
- **Persistent storage** (bash history, config, cache)
- **Custom developer user** with sudo access
- **Security and networking tools**
- **New York timezone** (America/New_York)

## Configuration Documentation

Each configuration includes detailed comments explaining:
- **Key differences** from other configurations
- **OS-specific optimizations** and features
- **Performance characteristics** and use cases
- **User and path differences** (developer user)
- **Setup approach** (Dockerfile-based builds)

## Environment Variables

All configurations set these environment variables:

- `NODE_OPTIONS=--max-old-space-size=4096` - Increased Node.js memory limit
- `CLAUDE_CONFIG_DIR=/home/developer/.claude` - Claude configuration directory
- `POWERLEVEL9K_DISABLE_GITSTATUS=true` - Disable git status in prompt for performance
- `DEVCONTAINER=true` - Indicates running in devcontainer
- `TZ=America/New_York` - Timezone set to Eastern Time (New York)

## Volume Mounts

- `claude-code-bashhistory-${devcontainerId}` - Persistent command history
- `claude-code-config-${devcontainerId}` - Claude configuration persistence
- `claude-code-cache-${devcontainerId}` - Cache persistence

## Performance Considerations

- **Linux**: Best performance, full Ubuntu ecosystem, comprehensive toolchain
- **Windows WSL2**: Good performance with Windows integration, WSL2 optimizations

## Key Differences

### Linux Configuration
- **User**: `developer` with sudo access
- **Base**: Ubuntu 22.04 LTS
- **Approach**: Dockerfile-based build
- **Features**: Full development toolchain, scientific computing stack

### Windows Configuration
- **User**: `developer` with sudo access
- **Base**: Ubuntu 22.04 LTS (WSL2 optimized)
- **Approach**: Dockerfile-based build with WSL2 integration
- **Features**: Windows integration, cross-platform development tools

## Troubleshooting

### Common Issues

1. **Container fails to build**: Check Docker has enough disk space and memory
2. **Permission issues**: Ensure Docker is running with proper permissions
3. **Network issues**: Verify environment initialization script execution
4. **Package installation failures**: Try rebuilding with `--no-cache` flag

### Rebuilding Containers

```bash
# Force rebuild without cache
docker build --no-cache -t claude-code-dev .

# Clean up unused containers and images
docker system prune -a
```

### Switch Script Issues

If the switch script doesn't work:

1. Check if it's executable: `chmod +x .devcontainer/switch-config.sh`
2. Verify the src directory structure
3. Check file permissions in the src directories

### Understanding Configuration Differences

To understand what's different between configurations:

1. **Read the comments** at the top of each Dockerfile for detailed explanations
2. **Check user differences**: Both use `developer` user with sudo access
3. **Review paths**: Both use `/home/developer/.claude` for configuration
4. **Note setup approach**: Both use Dockerfile-based builds with environment initialization scripts

## Security Features

- Non-root user execution (`developer`)
- Sudo access for specific commands
- Network capabilities for development
- Environment initialization scripts

## Contributing

When adding new configurations:

1. Create a new directory in `.devcontainer/src/<name>/`
2. Add `devcontainer.json` and `Dockerfile`
3. Update the `CONFIGS` array in `switch-config.sh`
4. Test the configuration thoroughly
5. Update this README with the new option

## Support

For issues with devcontainer configurations:
- Check the [Dev Containers documentation](https://containers.dev/)
- Review VS Code Dev Containers extension logs
- Ensure Docker Desktop is running and properly configured
- Use `switch-config.sh help` for script usage information 