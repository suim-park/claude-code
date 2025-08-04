# UV & Pixi Package Managers in GPU-Enabled Devcontainers

## 🚀 Overview

This guide explains how to use **uv** (fast Python package manager) and **pixi** (conda-like package manager) in the GPU-enabled devcontainer templates.

## 📦 Package Managers Included

### 1. **uv** - Fast Python Package Manager
- **What it is**: A lightning-fast Python package installer and resolver
- **Why use it**: 10-100x faster than pip, better dependency resolution
- **Installation**: Pre-installed in all devcontainer templates

### 2. **pixi** - Conda-like Package Manager
- **What it is**: A cross-platform package manager for Python, R, and other languages
- **Why use it**: Fast, reproducible environments, supports multiple languages
- **Installation**: Pre-installed in all devcontainer templates

## 🛠️ Usage Examples

### UV Commands

```bash
# Initialize a new project
uv init my-project
cd my-project

# Add packages
uv add numpy pandas matplotlib
uv add --dev pytest black mypy

# Install from requirements.txt
uv pip install -r requirements.txt

# Create virtual environment
uv venv
source .venv/bin/activate

# Run scripts
uv run python script.py
uv run pytest

# Sync dependencies
uv sync
```

### Pixi Commands

```bash
# Initialize a new project
pixi init my-project
cd my-project

# Add packages
pixi add python=3.11
pixi add numpy pandas matplotlib
pixi add --dev pytest black

# Add packages from different languages
pixi add r-base r-ggplot2
pixi add nodejs typescript

# Install project dependencies
pixi install

# Run commands in the environment
pixi run python script.py
pixi run pytest

# Activate environment
pixi shell
```

## 🔧 Devcontainer Integration

### Available in All Templates

Both `uv` and `pixi` are pre-installed in:
- `.devcontainer/Dockerfile` (main devcontainer)
- `.devcontainer-templates/src/linux/Dockerfile` (Linux template)
- `.devcontainer-templates/src/windows/Dockerfile` (Windows template)

### Environment Setup

The package managers are automatically configured with:
- PATH updates in `.bashrc` and `.zshrc`
- Version information in the setup script
- VS Code extensions for Python development

## 📋 Comparison Table

| Feature | uv | pixi | pip | conda |
|---------|----|----|-----|-------|
| Speed | ⚡⚡⚡⚡⚡ | ⚡⚡⚡⚡ | ⚡⚡ | ⚡⚡⚡ |
| Dependency Resolution | ✅ | ✅ | ⚠️ | ✅ |
| Multi-language | ❌ | ✅ | ❌ | ✅ |
| Lock Files | ✅ | ✅ | ❌ | ❌ |
| Virtual Environments | ✅ | ✅ | ✅ | ✅ |
| GPU Support | ✅ | ✅ | ✅ | ✅ |

## 🎯 Best Practices

### For Python Projects

```bash
# Use uv for Python-only projects
uv init my-python-project
uv add fastapi uvicorn
uv add --dev pytest black mypy

# Use pixi for mixed-language projects
pixi init my-ml-project
pixi add python=3.11 numpy pandas scikit-learn
pixi add r-base r-ggplot2
pixi add nodejs typescript
```

### For GPU Development

```bash
# Install GPU-enabled packages with uv
uv add torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
uv add tensorflow[and-cuda]

# Or with pixi
pixi add pytorch pytorch-cuda=12.1
pixi add tensorflow
```

### For Development Workflow

```bash
# 1. Initialize project
uv init my-project
cd my-project

# 2. Add dependencies
uv add numpy pandas matplotlib
uv add --dev pytest black mypy

# 3. Create lock file
uv lock

# 4. Install in devcontainer
uv sync

# 5. Run development commands
uv run python main.py
uv run pytest
uv run black .
```

## 🔍 Troubleshooting

### Common Issues

1. **PATH not found**: Restart terminal or run `source ~/.bashrc`
2. **Permission errors**: Ensure you're running as `developer` user
3. **GPU packages**: Use appropriate CUDA versions for your GPU

### Verification Commands

```bash
# Check installations
uv --version
pixi --version

# Check GPU support
nvidia-smi
python -c "import torch; print(torch.cuda.is_available())"

# Check package managers
which uv
which pixi
```

## 📚 Additional Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [Pixi Documentation](https://pixi.sh/)
- [GPU Devcontainer Guide](./GPU_DEVCONTAINER_SUMMARY.md)
- [VS Code Devcontainer Guide](./VSCODE_DEVCONTAINER_GUIDE.md)

## 🎉 Ready to Use!

Your GPU-enabled devcontainers now include both `uv` and `pixi` for fast, reliable package management. Choose the tool that best fits your project needs:

- **uv**: For Python-only projects requiring speed
- **pixi**: For multi-language projects requiring reproducibility
- **pip**: For traditional Python workflows
- **npm**: For Node.js dependencies

All tools work seamlessly with GPU acceleration! 🚀 