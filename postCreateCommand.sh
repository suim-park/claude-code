#!/bin/bash
# Post-create command script for devcontainer setup

echo "Running post-create commands..."

# Set up git configuration if not already set
if [ -z "$(git config --global user.name)" ]; then
    echo "Setting up git configuration..."
    git config --global user.name "Developer"
    git config --global user.email "developer@example.com"
fi

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
fi

# Set up pre-commit hooks if pre-commit is available
if command -v pre-commit &> /dev/null; then
    echo "Setting up pre-commit hooks..."
    pre-commit install
fi

# Create a sample Jupyter notebook
mkdir -p /workspace/notebooks
cat > /workspace/notebooks/sample.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Welcome to Claude Code GPU Development Environment!\n",
    "\n",
    "This notebook demonstrates the GPU-enabled development environment with:\n",
    "- PyTorch GPU support\n",
    "- TensorFlow GPU support\n",
    "- Jupyter integration\n",
    "- Comprehensive AI/ML libraries"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Check GPU availability\n",
    "import torch\n",
    "import tensorflow as tf\n",
    "\n",
    "print(f\"PyTorch GPU available: {torch.cuda.is_available()}\")\n",
    "print(f\"TensorFlow GPU available: {len(tf.config.list_physical_devices('GPU')) > 0}\")\n",
    "\n",
    "if torch.cuda.is_available():\n",
    "    print(f\"PyTorch GPU: {torch.cuda.get_device_name(0)}\")\n",
    "    print(f\"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB\")"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.10.12"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF

echo "Post-create commands completed successfully!" 