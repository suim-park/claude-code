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
RUN pip3 install --user \
    numpy pandas matplotlib seaborn scipy scikit-learn \
    jupyter jupyterlab ipykernel \
    black pylint mypy pytest pytest-cov \
    requests beautifulsoup4 lxml \
    flask fastapi uvicorn \
    sqlalchemy psycopg2-binary \
    redis pymongo \
    celery flower \
    docker kubernetes \
    boto3 azure-storage-blob google-cloud-storage \
    opencv-python pillow \
    tensorflow torch torchvision \
    transformers datasets \
    streamlit gradio \
    pre-commit

# Set up Jupyter configuration
RUN mkdir -p /home/developer/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" > /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8888" >> /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /home/developer/.jupyter/jupyter_notebook_config.py

# Create setup script
USER root
RUN cat > /usr/local/bin/setup-dev-environment.sh << 'EOF'
#!/bin/bash
set -e

echo "Setting up development environment..."

# Create workspace directory if it doesn't exist
mkdir -p /workspace
chown -R developer:developer /workspace

# Set up git configuration
if [ ! -f /home/developer/.gitconfig ]; then
    cat > /home/developer/.gitconfig << 'GITCONFIG'
[user]
    name = Developer
    email = developer@example.com
[core]
    editor = vim
    autocrlf = input
[init]
    defaultBranch = main
[push]
    default = simple
[pull]
    rebase = false
[merge]
    tool = vimdiff
[color]
    ui = auto
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    ca = commit -a
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
GITCONFIG
    chown developer:developer /home/developer/.gitconfig
fi

# Set up Python virtual environment
if [ ! -d /workspace/.venv ]; then
    echo "Creating Python virtual environment..."
    cd /workspace
    python3 -m venv .venv
    chown -R developer:developer .venv
fi

echo "Development environment setup complete!"
EOF

RUN chmod +x /usr/local/bin/setup-dev-environment.sh

# Create firewall initialization script
RUN cat > /usr/local/bin/init-firewall.sh << 'EOF'
#!/bin/bash
set -e

echo "Initializing firewall rules..."

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Set default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (if needed)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow Jupyter
iptables -A INPUT -p tcp --dport 8888 -j ACCEPT

# Allow development ports
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

echo "Firewall rules initialized successfully!"
EOF

RUN chmod +x /usr/local/bin/init-firewall.sh && \
    echo "developer ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/developer-firewall && \
    chmod 0440 /etc/sudoers.d/developer-firewall

# Set final user and working directory
USER developer
WORKDIR /workspace

# Set environment variables
ENV DEVCONTAINER=true
ENV SHELL=/bin/zsh
ENV PYTHONPATH=/workspace:/usr/local/lib/python3.11/site-packages
ENV JUPYTER_CONFIG_DIR=/home/developer/.jupyter

# Expose common development ports
EXPOSE 3000 8000 8080 8888

# Default command
CMD ["/bin/zsh"] 