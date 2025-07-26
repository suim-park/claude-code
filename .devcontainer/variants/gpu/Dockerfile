# =============================================================================
# CLAUDE CODE DEVCONTAINER - GPU VARIANT WITH BUILD BLOCKS
# =============================================================================
# This variant builds GPU support from scratch using build blocks instead of
# pre-built images for maximum customization and control.
# 
# BUILD BLOCK APPROACH:
# - Start with Ubuntu base and build CUDA support manually
# - Install NVIDIA drivers and CUDA toolkit from source
# - Configure GPU environment step by step
# - Build Python ML stack with GPU support
# - Optimize for development and performance
# 
# ADVANTAGES:
# - Full control over CUDA version and configuration
# - Customizable build process and optimizations
# - Smaller final image size (no pre-built overhead)
# - Better security (build from trusted sources)
# =============================================================================

# Build block 1: Base Ubuntu system
FROM ubuntu:20.04 as base-system

# Build arguments
ARG TZ
ARG CUDA_VERSION=11.8
ARG CUDNN_VERSION=8
ARG PYTHON_VERSION=3.11
ARG UBUNTU_VERSION=20.04

# Set environment variables
ENV TZ="$TZ"
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_VERSION=$CUDA_VERSION
ENV CUDNN_VERSION=$CUDNN_VERSION
ENV PYTHON_VERSION=$PYTHON_VERSION

# Build block 2: System dependencies and tools
FROM base-system as system-deps

# Install essential system packages
RUN apt update && apt install -y \
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
    libhdf5-dev libhdf5-serial-dev libhdf5-103 \
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

# Build block 3: NVIDIA driver and CUDA installation
FROM system-deps as cuda-install

# Add NVIDIA repository and install CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt update && \
    apt install -y cuda-toolkit-11-8 cuda-libraries-11-8 cuda-libraries-dev-11-8 && \
    rm -rf /var/lib/apt/lists/* && \
    rm cuda-keyring_1.0-1_all.deb

# Set CUDA environment variables
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# Build block 4: Node.js installation
FROM cuda-install as node-install

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share

# Build block 5: Python environment setup
FROM node-install as python-env

# Set Python environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONPATH=/workspace:/usr/local/lib/python3.11/site-packages

# Install Python packages for scientific computing and ML
RUN pip3 install --no-cache-dir \
    # Core scientific computing
    numpy scipy pandas matplotlib seaborn \
    # Jupyter ecosystem
    jupyter ipykernel jupyterlab \
    # Machine learning
    scikit-learn \
    # Deep learning frameworks
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 \
    tensorflow-gpu \
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
    psutil nvidia-ml-py3 gpustat \
    # Code quality
    black pylint mypy \
    && python3 -m ipykernel install --user --name=claude-code-gpu --display-name="Claude Code GPU"

# Build block 6: Development environment setup
FROM python-env as dev-env

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

# Build block 7: Final configuration
FROM dev-env as final

# Set performance optimization variables
ENV OMP_NUM_THREADS=4
ENV MKL_NUM_THREADS=4
ENV NUMBA_NUM_THREADS=4

# Set GPU memory management variables
ENV TF_FORCE_GPU_ALLOW_GROWTH=true
ENV TF_CPP_MIN_LOG_LEVEL=2
ENV CUDA_LAUNCH_BLOCKING=0

# Set NVIDIA GPU configuration
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics
ENV NVIDIA_REQUIRE_CUDA=cuda>=11.8

# Copy and set up scripts
USER root
COPY init-firewall.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-firewall.sh && \
    echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
    chmod 0440 /etc/sudoers.d/node-firewall

COPY setup-gpu.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-gpu.sh && \
    echo "node ALL=(root) NOPASSWD: /usr/local/bin/setup-gpu.sh" > /etc/sudoers.d/node-gpu && \
    chmod 0440 /etc/sudoers.d/node-gpu

USER node

# Verify CUDA installation
RUN nvcc --version && \
    python3 -c "import torch; print(f'PyTorch version: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}')" && \
    python3 -c "import tensorflow as tf; print(f'TensorFlow version: {tf.__version__}'); print(f'GPU available: {tf.config.list_physical_devices(\"GPU\")}')" 