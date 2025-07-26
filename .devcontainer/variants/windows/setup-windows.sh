#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVCONTAINER - WINDOWS WSL2 SETUP SCRIPT
# =============================================================================
# This script sets up the Windows WSL2 devcontainer environment.
# 
# KEY DIFFERENCES FROM UBUNTU BASE:
# - Uses Microsoft's base Ubuntu image with devcontainer features
# - Uses 'vscode' user instead of 'node' user
# - Relies on postCreateCommand instead of Dockerfile
# - Windows-specific optimizations and integrations
# - Different user paths (/home/vscode vs /home/node)
# 
# WINDOWS-SPECIFIC CHANGES:
# - User: vscode instead of node
# - Paths: /home/vscode/.claude instead of /home/node/.claude
# - Setup: Runtime installation vs build-time installation
# - Integration: WSL2-specific optimizations
# - Timezone: America/New_York (Eastern Time)
# =============================================================================

# Setup script for Windows WSL2 devcontainer

# Install additional packages
# Windows-specific: Uses apt like Ubuntu but with different user context
sudo apt update && sudo apt install -y \
  less \
  procps \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  jq \
  wget \
  ca-certificates

# Create command history directory
# Windows-specific: Uses vscode user instead of node
mkdir -p /commandhistory
touch /commandhistory/.bash_history
chown -R vscode:vscode /commandhistory

# Create Claude config directory
# Windows-specific: Different user path
mkdir -p /home/vscode/.claude
chown -R vscode:vscode /home/vscode/.claude

# Install git-delta
# Windows-specific: Same method as Ubuntu (.deb) but different user context
ARCH=$(dpkg --print-architecture)
wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb"
sudo dpkg -i "git-delta_0.18.2_${ARCH}.deb"
rm "git-delta_0.18.2_${ARCH}.deb"

# Set up npm global directory
# Windows-specific: Uses vscode user
mkdir -p /usr/local/share/npm-global
chown -R vscode:vscode /usr/local/share/npm-global

# Set environment variables
# Windows-specific: Different user path and shell setup
echo 'export NPM_CONFIG_PREFIX=/usr/local/share/npm-global' >> /home/vscode/.bashrc
echo 'export PATH=$PATH:/usr/local/share/npm-global/bin' >> /home/vscode/.bashrc
echo 'export SHELL=/bin/zsh' >> /home/vscode/.bashrc
echo 'export PROMPT_COMMAND="history -a"' >> /home/vscode/.bashrc
echo 'export HISTFILE=/commandhistory/.bash_history' >> /home/vscode/.bashrc

# Install zsh and powerline10k theme
# Windows-specific: Same installation but different user context
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude Code globally
# Windows-specific: Same installation but different user context
npm install -g @anthropic-ai/claude-code

# Copy and set up firewall script
# Windows-specific: Different user permissions and paths
sudo cp /workspace/.devcontainer/init-firewall.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/init-firewall.sh
echo "vscode ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" | sudo tee /etc/sudoers.d/vscode-firewall
sudo chmod 0440 /etc/sudoers.d/vscode-firewall

# Run firewall initialization
# Windows-specific: Same firewall setup but different user
sudo /usr/local/bin/init-firewall.sh

echo "Windows WSL2 devcontainer setup complete!" 