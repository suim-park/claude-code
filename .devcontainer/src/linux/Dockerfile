# =============================================================================
# CLAUDE CODE DEVELOPMENT ENVIRONMENT - LINUX
# =============================================================================
# Custom Dockerfile for Claude Code development on Linux
# 
# FEATURES:
# - Ubuntu 22.04 LTS base with latest updates
# - Node.js 20 runtime optimized for Claude Code
# - Python 3.11 with scientific computing stack
# - Comprehensive development toolchain
# - Enhanced shell environment with zsh and powerline10k
# - Jupyter notebook and lab support
# - Security and networking tools
# - Custom developer user with sudo access
# =============================================================================

FROM ubuntu:22.04

# Build arguments
ARG TZ
ARG NODE_VERSION=20
ARG PYTHON_VERSION=3.11
ARG UBUNTU_VERSION=22.04

# Set environment variables
ENV TZ="$TZ"
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=$NODE_VERSION
ENV PYTHON_VERSION=$PYTHON_VERSION
ENV UBUNTU_VERSION=$UBUNTU_VERSION

# Update system and install core packages
RUN apt update && apt upgrade -y && apt install -y \
    # Essential system tools
    curl wget ca-certificates gnupg2 lsb-release software-properties-common \
    # Build and development tools
    build-essential cmake pkg-config git vim nano less man-db \
    # Network and security tools
    iptables ipset iproute2 dnsutils procps sudo fzf zsh unzip jq \
    # Python and scientific computing dependencies
    python3 python3-pip python3-dev python3-venv python3-setuptools python3-wheel \
    libblas-dev liblapack-dev libatlas-base-dev gfortran \
    libhdf5-dev libhdf5-serial-dev \
    # Graphics and multimedia libraries
    libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5 libgtk-3-0 \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    # Additional development libraries
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

# Create developer user
RUN useradd -m -s /bin/zsh -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

# Set up developer environment
USER developer
WORKDIR /home/developer

# Create necessary directories
RUN mkdir -p /commandhistory /workspace /home/developer/.claude /home/developer/.cache && \
    chown -R developer:developer /commandhistory /workspace /home/developer/.claude /home/developer/.cache

# Set up npm global packages
ENV NPM_CONFIG_PREFIX=/home/developer/.npm-global
ENV PATH=$PATH:/home/developer/.npm-global/bin

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Install git-delta
USER root
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
    dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
    rm "git-delta_0.18.2_${ARCH}.deb"

# Set up zsh with powerline10k
USER developer
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -p git \
    -p fzf \
    -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
    -a "source /usr/share/doc/fzf/examples/completion.zsh" \
    -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    -x

# Install Python packages
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

# Create environment initialization script
RUN tee /usr/local/bin/init-environment.sh > /dev/null << 'EOF'
#!/bin/bash
# Environment initialization script for Claude Code development

echo "🚀 Initializing Claude Code development environment..."

# Set up bash history
mkdir -p /commandhistory
touch /commandhistory/.bash_history
chown -R developer:developer /commandhistory

# Set up Claude configuration
mkdir -p /home/developer/.claude
chown -R developer:developer /home/developer/.claude

# Initialize firewall (if needed)
if command -v iptables &> /dev/null; then
    echo "🔒 Setting up basic firewall rules..."
    # Add any specific firewall rules here
fi

# Set environment variables
export DEVCONTAINER=true
export TZ=America/New_York
export PYTHONPATH=/workspace:/usr/local/lib/python3.11/site-packages
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

echo "✅ Environment initialization complete!"
echo "🎯 Ready for Claude Code development!"
EOF

RUN chmod +x /usr/local/bin/init-environment.sh && \
    chown developer:developer /usr/local/bin/init-environment.sh

# Switch back to developer user
USER developer
WORKDIR /workspace

# Verify installations
RUN node --version && \
    npm --version && \
    python3 --version && \
    pip3 --version

# Set default shell
ENV SHELL=/bin/zsh

# Expose ports
EXPOSE 8888 8889 3000 8080 5173

# Default command
CMD ["/bin/zsh"] 