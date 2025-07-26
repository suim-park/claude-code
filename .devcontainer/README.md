# Claude Code DevContainer Configurations

This directory contains multiple devcontainer configurations for the Claude Code project, organized in a clean and maintainable structure.

## Directory Structure

```
.devcontainer/
├── devcontainer.json          # Active configuration (copied from variants)
├── Dockerfile                 # Active Dockerfile (copied from variants)
├── init-firewall.sh           # Firewall initialization script
├── switch-config.sh           # Helper script to switch configurations
├── README.md                  # This file
└── variants/                  # All available configurations
    ├── ubuntu/                # Default Ubuntu (Recommended)
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── alpine/                # Alpine Linux (Lightweight)
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── debian/                # Debian (Stable)
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── centos/                # CentOS/RHEL (Enterprise)
    │   ├── devcontainer.json
    │   └── Dockerfile
    ├── windows/               # Windows WSL2
    │   ├── devcontainer.json
    │   └── setup-windows.sh
    └── gpu/                   # GPU-Enabled with CUDA
        ├── devcontainer.json
        ├── Dockerfile
        └── setup-gpu.sh
```

## Available Configurations

### 1. **Ubuntu** (Default - Recommended)
- **Base**: `node:20` (Ubuntu-based)
- **Best for**: General development, most stable
- **Size**: ~1.2GB
- **Features**: Full Ubuntu toolchain, comprehensive package support

### 2. **Alpine Linux** (Lightweight)
- **Base**: `node:20-alpine`
- **Best for**: Resource-constrained environments, CI/CD
- **Size**: ~800MB
- **Features**: Minimal footprint, fast startup, security-focused

### 3. **Debian** (Stable)
- **Base**: `node:20-bullseye`
- **Best for**: Enterprise environments, long-term stability
- **Size**: ~1.1GB
- **Features**: Debian stability, conservative package versions

### 4. **CentOS/RHEL** (Enterprise)
- **Base**: `node:20` (CentOS-based)
- **Best for**: Enterprise Linux environments, RHEL compatibility
- **Size**: ~1.3GB
- **Features**: Enterprise-grade security, SELinux support

### 5. **Windows WSL2** (Windows Development)
- **Base**: `mcr.microsoft.com/devcontainers/base:ubuntu`
- **Best for**: Windows developers using WSL2
- **Size**: ~1.0GB
- **Features**: Windows integration, WSL2 optimization

### 6. **GPU-Enabled** (CUDA Support - Build Block)
- **Base**: `ubuntu:20.04` (built from scratch)
- **Best for**: GPU-accelerated development, ML/AI workloads
- **Size**: ~6.0GB
- **Features**: CUDA 11.8, PyTorch, TensorFlow, Jupyter, GPU monitoring
- **Approach**: Build block method for maximum customization and control

## How to Use

### Option 1: Use the Switch Script (Recommended)

The easiest way to switch between configurations is using the provided script:

```bash
# Make the script executable (if not already)
chmod +x .devcontainer/switch-config.sh

# List available configurations
.devcontainer/switch-config.sh list

# Switch to a specific configuration
.devcontainer/switch-config.sh ubuntu    # Default Ubuntu
.devcontainer/switch-config.sh alpine    # Alpine Linux
.devcontainer/switch-config.sh debian    # Debian
.devcontainer/switch-config.sh centos    # CentOS/RHEL
.devcontainer/switch-config.sh windows   # Windows WSL2
.devcontainer/switch-config.sh gpu       # GPU-Enabled with CUDA

# Show current configuration
.devcontainer/switch-config.sh current

# Show detailed info about a variant
.devcontainer/switch-config.sh info alpine

# Restore from backup
.devcontainer/switch-config.sh restore
```

### Option 2: Manual Configuration Switch

1. Copy your preferred configuration to the root of `.devcontainer/`:
   ```bash
   # For Alpine Linux
   cp .devcontainer/variants/alpine/devcontainer.json .devcontainer/devcontainer.json
   cp .devcontainer/variants/alpine/Dockerfile .devcontainer/Dockerfile
   
   # For Debian
   cp .devcontainer/variants/debian/devcontainer.json .devcontainer/devcontainer.json
   cp .devcontainer/variants/debian/Dockerfile .devcontainer/Dockerfile
   
   # For CentOS
   cp .devcontainer/variants/centos/devcontainer.json .devcontainer/devcontainer.json
   cp .devcontainer/variants/centos/Dockerfile .devcontainer/Dockerfile
   
   # For Windows WSL2
cp .devcontainer/variants/windows/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/variants/windows/setup-windows.sh .devcontainer/setup-windows.sh
chmod +x .devcontainer/setup-windows.sh

# For GPU-Enabled
cp .devcontainer/variants/gpu/devcontainer.json .devcontainer/devcontainer.json
cp .devcontainer/variants/gpu/Dockerfile .devcontainer/Dockerfile
cp .devcontainer/variants/gpu/setup-gpu.sh .devcontainer/setup-gpu.sh
chmod +x .devcontainer/setup-gpu.sh
   ```

2. Rebuild the container in VS Code (Command Palette → "Dev Containers: Rebuild Container")

### Option 3: Use VS Code Command Palette
1. Open Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Run "Dev Containers: Open Folder in Container"
3. The container will use the current configuration in `.devcontainer/`

## Common Features Across All Configurations

All configurations include:

- **Node.js 20** runtime
- **Claude Code** globally installed
- **Git** with delta diff viewer
- **Zsh** with Oh My Zsh and Powerlevel10k theme
- **FZF** for fuzzy finding
- **Essential development tools** (less, procps, sudo, etc.)
- **Network tools** (iptables, ipset, iproute2)
- **VS Code extensions**:
  - ESLint
  - Prettier
  - GitLens
- **Persistent bash history** across container restarts
- **Claude configuration persistence**
- **Firewall initialization** for security
- **Eastern Time (New York) timezone**

## Configuration Documentation

Each variant includes detailed comments explaining:
- **Key differences** from the base Ubuntu configuration
- **Variant-specific changes** in package names and installation methods
- **Performance characteristics** and use cases
- **Package manager differences** (apt, apk, yum)
- **git-delta installation methods** (.deb, .apk, tar.gz)
- **User and path differences** (node vs vscode user)
- **GPU-specific features** (CUDA, PyTorch, TensorFlow, monitoring tools, build blocks)

## Environment Variables

All configurations set these environment variables:

- `NODE_OPTIONS=--max-old-space-size=4096` - Increased Node.js memory limit (GPU: 8192)
- `CLAUDE_CONFIG_DIR=/home/node/.claude` - Claude configuration directory (Windows: `/home/vscode/.claude`)
- `POWERLEVEL9K_DISABLE_GITSTATUS=true` - Disable git status in prompt for performance
- `DEVCONTAINER=true` - Indicates running in devcontainer
- `TZ=America/New_York` - Timezone set to Eastern Time (New York)

**GPU-Specific Environment Variables:**
- `CUDA_HOME=/usr/local/cuda` - CUDA installation path
- `LD_LIBRARY_PATH` - CUDA library path
- `NVIDIA_VISIBLE_DEVICES=all` - GPU device visibility
- `NVIDIA_DRIVER_CAPABILITIES=compute,utility` - GPU driver capabilities

## Volume Mounts

- `claude-code-bashhistory-${devcontainerId}` - Persistent command history
- `claude-code-config-${devcontainerId}` - Claude configuration persistence
- `claude-code-gpu-cache-${devcontainerId}` - GPU cache persistence (GPU variant only)

## Performance Considerations

- **Alpine**: Fastest startup, smallest size, but some packages may not be available
- **Ubuntu/Debian**: Balanced performance and package availability
- **CentOS**: Slightly slower startup due to enterprise packages
- **Windows WSL2**: Good performance with Windows integration
- **GPU-Enabled**: Large size (~6GB) but full GPU acceleration with build block approach

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
2. **Compare package managers**: apt (Ubuntu/Debian), apk (Alpine), yum (CentOS)
3. **Check git-delta installation**: .deb (Ubuntu/Debian), .apk (Alpine), tar.gz (CentOS)
4. **Note user differences**: node (Linux variants) vs vscode (Windows)
5. **Review paths**: /home/node/.claude (Linux) vs /home/vscode/.claude (Windows)

## Security Features

- Non-root user execution (`node` or `vscode`)
- Firewall initialization with iptables/ipset
- Sudo access limited to specific commands
- Network capabilities for firewall management

## Contributing

When adding new configurations:

1. Create a new directory in `.devcontainer/variants/<name>/`
2. Add `devcontainer.json` and `Dockerfile` (or other required files)
3. Update the `CONFIGS` array in `switch-config.sh`
4. Test the configuration thoroughly
5. Update this README with the new option

## Support

For issues with devcontainer configurations:
- Check the [Dev Containers documentation](https://containers.dev/)
- Review VS Code Dev Containers extension logs
- Ensure Docker Desktop is running and properly configured
- Use `switch-config.sh help` for script usage information 