# VS Code Devcontainer Usage Guide

## 1. Prerequisites

### Install VS Code Extensions
1. Open VS Code
2. Open Extensions tab (Cmd+Shift+X)
3. Install the following extensions:
   - **Dev Containers** (ms-vscode-remote.remote-containers)
   - **Docker** (ms-azuretools.vscode-docker)
   - **Claude Code** (anthropic.claude-code)

### Install and Start Docker Desktop
```bash
# Install Docker Desktop (already completed)
brew install --cask docker

# Start Docker Desktop
# Run Docker.app from Applications folder
# Or search for "Docker" in Spotlight (Cmd+Space) and run it
```

## 2. Starting Devcontainer Environment

### Method 1: Start directly from VS Code (Recommended)
1. Open project folder in VS Code
2. Open Command Palette (Cmd+Shift+P)
3. Type "Dev Containers: Reopen in Container" and execute
4. Wait for container build to complete (takes 5-10 minutes)

### Method 2: Using Docker Compose (if available)
```bash
# If docker-compose.yml exists in .devcontainer/
docker-compose up -d
```

## 3. M3 Optimization Settings

### Docker Desktop Settings
1. Docker Desktop > Settings > Resources
2. Memory: Allocate 8GB or more
3. CPUs: Allocate 2 or more (matches current devcontainer.json)
4. Swap: Set 2GB or more
5. Disk image size: 64GB or more

### VS Code Settings
The current `.devcontainer/devcontainer.json` already includes optimized settings:
```json
{
  "runArgs": [
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_RAW",
    "--shm-size=2g",
    "--memory=8g",
    "--cpus=2"
  ],
  "customizations": {
    "vscode": {
      "extensions": [
        "anthropic.claude-code",
        "ms-python.python",
        "ms-toolsai.jupyter",
        "charliermarsh.ruff",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.flake8"
      ]
    }
  }
}
```

## 4. Container Features (Pre-installed)

The current `.devcontainer/Dockerfile` includes:

### Pre-installed Tools
- ✅ **Ubuntu 22.04 LTS** base
- ✅ **Node.js 20** (optimized for Claude Code)
- ✅ **Python 3.11** with scientific computing stack
- ✅ **UV** (fast Python package manager)
- ✅ **Pixi** (conda-like package manager)
- ✅ **Claude Code** (globally installed)
- ✅ **Jupyter** notebook and lab support
- ✅ **Zsh** with enhanced shell environment
- ✅ **Development tools** (git, vim, nano, etc.)

### Pre-installed Python Packages
- Scientific computing: numpy, pandas, matplotlib, seaborn, scipy, scikit-learn
- Deep learning: torch, torchvision, transformers, datasets
- Web frameworks: flask, fastapi, uvicorn
- Data processing: sqlalchemy, redis, pymongo
- Cloud tools: boto3, kubernetes, docker
- Development tools: black, pylint, mypy, pytest

## 5. Using Claude Code

### Basic Usage
```bash
# Run Claude Code
claude-code

# Or use the quick start script
./quick-start.sh

# Check installation
which claude-code
claude-code --version
```

### Available Commands
```bash
# Start Claude Code
claude-code

# Start with specific workspace
claude-code /workspace

# Check help
claude-code --help
```

## 6. Development Workflow

### 1. Starting a New Project
```bash
# The container is ready to use immediately
# All tools are pre-installed and configured

# Use the quick start script
./quick-start.sh
```

### 2. Code Development
```bash
# Python development
python3 --version
pip3 list

# Node.js development
node --version
npm --version

# Package managers
uv --version
pixi --version
```

### 3. Jupyter Notebooks
```bash
# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Or use the pre-configured setup
# Jupyter is already configured in the container
```

## 7. Troubleshooting

### Common Issues

#### 1. Permission Issues
```bash
# Fix permissions inside container
sudo chown -R developer:developer /workspace
sudo chown -R developer:developer /home/developer
```

#### 2. Memory Issues
```bash
# Increase Node.js memory (already set in devcontainer.json)
export NODE_OPTIONS="--max-old-space-size=4096"

# Python memory optimization
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1
```

#### 3. Network Issues
```bash
# Reset firewall (pre-configured script)
sudo /usr/local/bin/init-firewall.sh
```

#### 4. Container Issues
```bash
# Rebuild container
# In VS Code: Cmd+Shift+P > "Dev Containers: Rebuild Container"

# Or clean up Docker
docker system prune -a
```

## 8. Useful Tips

### VS Code Shortcuts
- `Cmd+Shift+P`: Command Palette
- `Cmd+Shift+E`: Explorer
- `Cmd+Shift+X`: Extensions
- `Cmd+J`: Terminal
- `Cmd+Shift+F`: Search

### Devcontainer Commands
- `Cmd+Shift+P` > "Dev Containers: Reopen in Container"
- `Cmd+Shift+P` > "Dev Containers: Rebuild Container"
- `Cmd+Shift+P` > "Dev Containers: Show Container Log"

### Available Scripts
- `./quick-start.sh`: Interactive startup script
- `sudo /usr/local/bin/init-firewall.sh`: Firewall configuration
- `/usr/local/bin/setup-dev-environment.sh`: Environment setup (runs automatically)

### Environment Variables (Pre-configured)
```bash
# Already set in devcontainer.json
NODE_OPTIONS="--max-old-space-size=4096"
CLAUDE_CONFIG_DIR="/home/developer/.claude"
CUDA_HOME="/usr/local/cuda"
PATH="/usr/local/cuda/bin:$PATH"
```

## 9. Project Structure

```
claude-code/
├── .devcontainer/
│   ├── devcontainer.json    # VS Code devcontainer configuration
│   ├── Dockerfile          # Container image definition
│   ├── init-firewall.sh    # Firewall setup script
│   └── README.md           # Devcontainer documentation
├── .devcontainer-templates/
│   └── src/
│       ├── linux/          # Linux template
│       └── windows/        # Windows template
├── quick-start.sh          # Interactive startup script
├── CLAUDE_CODE_STARTUP_GUIDE.md
├── UV_PIXI_DEVCONTAINER_GUIDE.md
└── VSCODE_DEVCONTAINER_GUIDE.md
```

## 10. Quick Start

1. **Start Devcontainer**: `Cmd+Shift+P` > "Dev Containers: Reopen in Container"
2. **Run Quick Start**: `./quick-start.sh`
3. **Start Claude Code**: `claude-code`
4. **Begin Development**: All tools are ready to use!

The devcontainer environment is fully configured and ready for Claude Code development with all necessary tools pre-installed! 