# =============================================================================
# CLAUDE CODE DEVCONTAINER - LINUX VARIANT
# =============================================================================
# This variant is optimized for Linux development environments.
# 
# KEY FEATURES:
# - Ubuntu 22.04 LTS base with latest updates
# - Node.js 20 runtime for Claude Code
# - Python 3.11 with scientific computing packages
# - Comprehensive development tools and utilities
# - Jupyter notebook support
# - Enhanced shell environment (zsh + powerline10k)
# 
# LINUX-SPECIFIC FEATURES:
# - Full Linux package ecosystem
# - Native performance and compatibility
# - Comprehensive development toolchain
# - Network and security tools
# =============================================================================

FROM ubuntu:22.04

# Build arguments
ARG TZ
ARG UBUNTU_VERSION=22.04
ARG NODE_VERSION=20
ARG PYTHON_VERSION=3.11

# Set environment variables
ENV TZ="$TZ"
ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_VERSION=$UBUNTU_VERSION
ENV NODE_VERSION=$NODE_VERSION
ENV PYTHON_VERSION=$PYTHON_VERSION

# Update system and install essential packages
RUN apt update && apt upgrade -y && apt install -y \
    # Core system tools
    curl wget ca-certificates gnupg2 lsb-release software-properties-common \
    # Build tools
    build-essential cmake pkg-config \
    # Development tools
    git vim nano less man-db \
    # Network tools
    iptables ipset iproute2 dnsutils \
    # System utilities
    procps sudo fzf zsh unzip jq \
    # Python dependencies
    python3 python3-pip python3-dev python3-venv python3-setuptools python3-wheel \
    # Scientific computing dependencies
    libblas-dev liblapack-dev libatlas-base-dev gfortran \
    libhdf5-dev libhdf5-serial-dev \
    # Graphics and multimedia
    libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5 libgtk-3-0 \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    # Additional libraries
    libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libgtk2.0-dev \
    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools \
    gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
    libgirepository1.0-dev libcairo2-dev libpango1.0-dev libatk1.0-dev \
    libgdk-pixbuf2.0-dev libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share

# Set up non-root user
ARG USERNAME=node

# Persist bash history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory

# Set development environment variables
ENV DEVCONTAINER=true
ENV SHELL=/bin/zsh

# Create workspace and config directories
RUN mkdir -p /workspace /home/node/.claude /home/node/.cache && \
    chown -R node:node /workspace /home/node/.claude /home/node/.cache

WORKDIR /workspace

# Install git-delta
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
    dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
    rm "git-delta_0.18.2_${ARCH}.deb"

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Set up zsh with powerline10k
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
    -a "source /usr/share/doc/fzf/examples/completion.zsh" \
    -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    -x

# Install Python packages for development
USER root
RUN pip3 install --no-cache-dir \
    # Core scientific computing
    numpy scipy pandas matplotlib seaborn \
    # Jupyter ecosystem
    jupyter ipykernel jupyterlab \
    # Machine learning
    scikit-learn \
    # AI/ML libraries
    transformers datasets accelerate diffusers \
    # Computer vision
    opencv-python pillow \
    # Utilities
    requests tqdm \
    # Experiment tracking
    wandb mlflow optuna \
    # Distributed computing
    ray[tune] \
    # Monitoring
    psutil \
    # Code quality
    black pylint mypy \
    && python3 -m ipykernel install --user --name=claude-code-linux --display-name="Claude Code Linux"

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-firewall.sh && \
    echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
    chmod 0440 /etc/sudoers.d/node-firewall

USER node

# Verify installations
RUN node --version && \
    npm --version && \
    python3 --version && \
    pip3 --version 