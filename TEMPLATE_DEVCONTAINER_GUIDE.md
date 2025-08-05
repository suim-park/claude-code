# Template Devcontainer Usage Guide

## Overview

This guide shows you how to run the different devcontainer templates available in `.devcontainer-templates/src/`:

- **Linux Template**: `.devcontainer-templates/src/linux/`
- **Windows Template**: `.devcontainer-templates/src/windows/`

## Available Templates

### 1. Linux Template
**Location**: `.devcontainer-templates/src/linux/`
**Name**: "Claude Code - Linux Development"
**Features**:
- Ubuntu 22.04 LTS base
- Node.js 20 + Python 3.11
- Claude Code pre-installed
- UV & Pixi package managers
- Comprehensive data science stack
- GPU support (when available)
- Jupyter notebooks

### 2. Windows Template
**Location**: `.devcontainer-templates/src/windows/`
**Name**: "Claude Code - Windows Development"
**Features**:
- Same features as Linux template
- WSL2 compatibility
- Windows-specific optimizations
- Timezone: America/New_York (vs America/Los_Angeles for Linux)

## How to Run Template Devcontainers

### Method 1: VS Code Command Palette (Recommended)

#### For Linux Template:
1. Open VS Code
2. Open Command Palette (`Cmd+Shift+P`)
3. Type: `Dev Containers: Open Folder in Container`
4. Navigate to: `.devcontainer-templates/src/linux/`
5. Select the folder and wait for container to build

#### For Windows Template:
1. Open VS Code
2. Open Command Palette (`Cmd+Shift+P`)
3. Type: `Dev Containers: Open Folder in Container`
4. Navigate to: `.devcontainer-templates/src/windows/`
5. Select the folder and wait for container to build

### Method 2: Direct Folder Opening

#### For Linux Template:
```bash
# In terminal
cd .devcontainer-templates/src/linux/
code .
# VS Code will prompt to reopen in container
```

#### For Windows Template:
```bash
# In terminal
cd .devcontainer-templates/src/windows/
code .
# VS Code will prompt to reopen in container
```

### Method 3: Using Docker Compose (if available)

```bash
# For Linux template
cd .devcontainer-templates/src/linux/
docker-compose up -d

# For Windows template
cd .devcontainer-templates/src/windows/
docker-compose up -d
```

## Template Comparison

| Feature | Main Devcontainer | Linux Template | Windows Template |
|---------|------------------|----------------|------------------|
| **Base Image** | Ubuntu 22.04 | Ubuntu 22.04 | Ubuntu 22.04 |
| **Node.js** | 20 | 20 | 20 |
| **Python** | 3.11 | 3.11 | 3.11 |
| **Claude Code** | ✅ | ✅ | ✅ |
| **UV & Pixi** | ✅ | ✅ | ✅ |
| **Data Science** | ✅ | ✅ | ✅ |
| **GPU Support** | ✅ | ✅ | ✅ |
| **Jupyter** | ✅ | ✅ | ✅ |
| **Timezone** | America/Los_Angeles | America/Los_Angeles | America/New_York |
| **WSL2 Support** | ❌ | ❌ | ✅ |

## Quick Start Commands

### After Starting Template Devcontainer:

```bash
# Check environment
./quick-start.sh

# Start Claude Code
claude-code

# Check available tools
which uv
which pixi
python3 --version
node --version

# Start Jupyter
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

## Template-Specific Features

### Linux Template Features:
- Optimized for Linux development
- Standard Unix tools and utilities
- Native Linux performance

### Windows Template Features:
- WSL2 compatibility
- Windows-specific path handling
- Cross-platform development support
- Eastern Timezone (America/New_York)

## Resource Allocation

Both templates use the same resource allocation:
```json
"runArgs": [
  "--cap-add=NET_ADMIN",
  "--cap-add=NET_RAW",
  "--shm-size=2g",
  "--memory=8g",
  "--cpus=2"
]
```

## Troubleshooting

### Common Issues:

#### 1. Template Not Found
```bash
# Ensure you're in the correct directory
ls -la .devcontainer-templates/src/
```

#### 2. Build Failures
```bash
# Clean Docker cache
docker system prune -a

# Rebuild container
# In VS Code: Cmd+Shift+P > "Dev Containers: Rebuild Container"
```

#### 3. Permission Issues
```bash
# Fix permissions inside container
sudo chown -R developer:developer /workspace
```

#### 4. Port Conflicts
```bash
# Check what's using the ports
lsof -i :3000  # Claude Code
lsof -i :8888  # Jupyter
```

## Switching Between Templates

### From Main to Template:
1. Close current devcontainer
2. Open template folder in VS Code
3. Select "Reopen in Container"

### From Template to Main:
1. Close template devcontainer
2. Open main project folder
3. Select "Reopen in Container"

## Best Practices

### 1. Choose the Right Template:
- **Linux Template**: For Linux-specific development
- **Windows Template**: For Windows/WSL2 development
- **Main Devcontainer**: For general development

### 2. Resource Management:
- Monitor resource usage with `htop`
- Close unused containers
- Clean up Docker images periodically

### 3. Data Persistence:
- Use volume mounts for important data
- Commit changes frequently
- Use `.gitignore` for temporary files

## Example Workflows

### Data Science Workflow:
```bash
# 1. Start Linux template
cd .devcontainer-templates/src/linux/
code .

# 2. Start Jupyter
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser

# 3. Create notebook
mkdir notebooks
touch notebooks/analysis.ipynb

# 4. Use data science tools
python3 -c "
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
print('Data science environment ready!')
"
```

### Claude Code Development:
```bash
# 1. Start any template
cd .devcontainer-templates/src/linux/
code .

# 2. Start Claude Code
claude-code

# 3. Begin development
# Claude Code will be available in your browser
```

## Summary

The template devcontainers provide:
- ✅ **Consistent environments** across different platforms
- ✅ **Same features** as main devcontainer
- ✅ **Platform-specific optimizations**
- ✅ **Easy switching** between environments
- ✅ **Full data science stack** in each template

Choose the template that best fits your development needs and platform requirements! 