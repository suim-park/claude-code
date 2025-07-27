# Claude Code DevContainer Configurations

This directory contains multiple devcontainer configurations for different operating system environments, optimized for Claude Code development.

## Directory Structure

```
.devcontainer/
├── devcontainer.json          # Active configuration (copied from variants/)
├── Dockerfile                 # Active Dockerfile (copied from variants/)
├── init-firewall.sh           # Firewall initialization script
├── switch-config.sh           # Configuration switching script
├── test-configs.sh            # Configuration testing script
├── README.md                  # This file
└── variants/                  # Configuration variants
    ├── linux/                 # Linux Development Environment
    │   ├── devcontainer.json
    │   └── Dockerfile
    └── windows/               # Windows WSL2 Development Environment
        ├── devcontainer.json
        └── setup-windows.sh
```

## Available Configurations

### 1. **Linux** (Ubuntu 22.04 Development)
- **Base**: `ubuntu:22.04`
- **Best for**: Linux development, server environments, Docker-native development
- **Size**: ~2.5GB
- **Features**: Full Ubuntu ecosystem, comprehensive development tools, Jupyter support

### 2. **Windows** (WSL2 Development)
- **Base**: `mcr.microsoft.com/devcontainers/base:ubuntu`
- **Best for**: Windows developers using WSL2, Windows integration
- **Size**: ~2.0GB
- **Features**: Windows WSL2 integration, Microsoft devcontainer features, cross-platform development

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
cp .devcontainer/variants/linux/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/variants/linux/Dockerfile .devcontainer/Dockerfile

# For Windows WSL2
cp .devcontainer/variants/windows/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/variants/windows/setup-windows.sh .devcontainer/setup-windows.sh
chmod +x .devcontainer/setup-windows.sh
```

## Features

All configurations include:

- **Claude Code** extension and global installation
- **Node.js 20** runtime with enhanced memory allocation
- **Python 3.11** with scientific computing packages
- **Jupyter Notebook & JupyterLab** support
- **Comprehensive VS Code extensions** for development
- **Enhanced shell environment** (zsh + powerline10k)
- **Persistent bash history** across container restarts
- **Claude configuration persistence**
- **Firewall initialization** for security
- **Eastern Time (New York) timezone**

## Configuration Documentation

Each variant includes detailed comments explaining:
- **Key differences** from other configurations
- **OS-specific optimizations** and features
- **Performance characteristics** and use cases
- **User and path differences** (node vs vscode user)
- **Setup approach** (Dockerfile vs postCreateCommand)

## Environment Variables

All configurations set these environment variables:

- `NODE_OPTIONS=--max-old-space-size=4096` - Increased Node.js memory limit
- `CLAUDE_CONFIG_DIR=/home/node/.claude` - Claude configuration directory (Windows: `/home/vscode/.claude`)
- `POWERLEVEL9K_DISABLE_GITSTATUS=true` - Disable git status in prompt for performance
- `DEVCONTAINER=true` - Indicates running in devcontainer
- `TZ=America/New_York` - Timezone set to Eastern Time (New York)

## Volume Mounts

- `claude-code-bashhistory-${devcontainerId}` - Persistent command history
- `claude-code-config-${devcontainerId}` - Claude configuration persistence
- `claude-code-cache-${devcontainerId}` - Cache persistence

## Performance Considerations

- **Linux**: Best performance, full Ubuntu ecosystem, largest size (~2.5GB)
- **Windows WSL2**: Good performance with Windows integration, optimized for WSL2

## Troubleshooting

### Common Issues

1. **Container fails to build**: Check Docker has enough disk space and memory
2. **Permission issues**: Ensure Docker is running with proper permissions
3. **Network issues**: Verify firewall script execution in postCreateCommand
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
2. Verify the variants directory structure
3. Check file permissions in the variants directories

### Understanding Configuration Differences

To understand what's different between variants:

1. **Read the comments** at the top of each Dockerfile for detailed explanations
2. **Check user differences**: node (Linux) vs vscode (Windows)
3. **Review paths**: /home/node/.claude (Linux) vs /home/vscode/.claude (Windows)
4. **Note setup approach**: Dockerfile (Linux) vs postCreateCommand (Windows)

## Security Features

- Non-root user execution (`node` or `vscode`)
- Firewall initialization with iptables/ipset
- Sudo access limited to specific commands
- Network capabilities for firewall management

## Contributing

When adding new configurations:

1. Create a new directory in `.devcontainer/variants/<name>/`
2. Add `devcontainer.json` and required files (Dockerfile, setup script, etc.)
3. Update the `CONFIGS` array in `switch-config.sh`
4. Test the configuration thoroughly
5. Update this README with the new option

## Support

For issues with devcontainer configurations:
- Check the [Dev Containers documentation](https://containers.dev/)
- Review VS Code Dev Containers extension logs
- Ensure Docker Desktop is running and properly configured
- Use `switch-config.sh help` for script usage information 