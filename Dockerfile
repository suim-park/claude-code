# FROM node:18
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ARG TZ
ARG NODE_VERSION=20
ARG PYTHON_VERSION=3.11
ARG UBUNTU_VERSION=22.04

ENV TZ="$TZ"
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=$NODE_VERSION
ENV PYTHON_VERSION=$PYTHON_VERSION
ENV UBUNTU_VERSION=$UBUNTU_VERSION

# Install comprehensive development tools and scientific computing packages
RUN apt update && apt upgrade -y && apt install -y \
    curl wget ca-certificates gnupg2 lsb-release software-properties-common \
    build-essential cmake pkg-config git vim nano less man-db \
    iptables ipset iproute2 dnsutils procps sudo fzf zsh unzip jq \
    python3 python3-pip python3-dev python3-venv python3-setuptools python3-wheel \
    libblas-dev liblapack-dev libatlas-base-dev gfortran \
    libhdf5-dev libhdf5-serial-dev \
    python3-pyqt5 libgtk-3-0 \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 libgtk2.0-dev \
    libtbb2 libtbb-dev libopenexr-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools \
    gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 gstreamer1.0-pulseaudio \
    libgirepository1.0-dev libcairo2-dev libpango1.0-dev libatk1.0-dev \
    libgdk-pixbuf2.0-dev libgtk-3-dev \
    nvidia-utils-535 nvidia-settings \
    gh \
    aggregate \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and Claude in one step to ensure npm is available
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm install -g @anthropic-ai/claude-code

# Create developer user with sudo privileges
RUN useradd -m -s /bin/zsh -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

# Install uv (fast Python package manager)
USER developer
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/developer/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/developer/.zshrc

# Install pixi (conda-like package manager)
RUN curl -fsSL https://pixi.sh/install.sh | bash && \
    echo 'export PATH="$HOME/.pixi/bin:$PATH"' >> /home/developer/.bashrc && \
    echo 'export PATH="$HOME/.pixi/bin:$PATH"' >> /home/developer/.zshrc

# Set environment variables for PATH
ENV PATH="/home/developer/.local/bin:/home/developer/.pixi/bin:$PATH"

# Set up developer environment
USER developer
WORKDIR /home/developer

# Create necessary directories
USER root
RUN mkdir -p /commandhistory /workspace /home/developer/.claude /home/developer/.cache && \
    chown -R developer:developer /commandhistory /workspace /home/developer/.claude /home/developer/.cache

# Set up npm global packages
USER developer
ENV NPM_CONFIG_PREFIX=/home/developer/.npm-global
ENV PATH=$PATH:/home/developer/.npm-global/bin

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

# Install Python packages with GPU support
RUN pip3 install --user \
    # Core scientific computing
    numpy pandas matplotlib seaborn scipy scikit-learn \
    # Jupyter ecosystem
    jupyter jupyterlab ipykernel \
    # Development tools
    black pylint mypy pytest pytest-cov \
    # Web frameworks
    requests beautifulsoup4 lxml \
    flask fastapi uvicorn sqlalchemy psycopg2-binary \
    # Data processing
    redis pymongo celery flower \
    # Cloud and deployment
    docker kubernetes boto3 azure-storage-blob google-cloud-storage \
    # Computer vision
    opencv-python pillow \
    # Web applications
    streamlit gradio \
    # Development tools
    pre-commit \
    # GPU monitoring
    nvidia-ml-py3 gpustat

# Install PyTorch with GPU support
RUN pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install TensorFlow with GPU support
RUN pip3 install --user tensorflow[and-cuda]

# Install AI/ML libraries
RUN pip3 install --user transformers datasets

# Set up Jupyter configuration
RUN mkdir -p /home/developer/.jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" > /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8888" >> /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /home/developer/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /home/developer/.jupyter/jupyter_notebook_config.py

# Create development environment setup script
USER root
RUN cat > /usr/local/bin/setup-dev-environment.sh << 'EOF'
#!/bin/bash
echo "Setting up Claude Code development environment..."

# Check GPU availability
if command -v nvidia-smi &> /dev/null; then
    echo "✅ NVIDIA GPU detected:"
    nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader,nounits
    echo ""
    echo "GPU Memory Usage:"
    nvidia-smi --query-gpu=memory.used,memory.free --format=csv,noheader,nounits
    
    # Check CUDA installation
    if command -v nvcc &> /dev/null; then
        echo "✅ CUDA Toolkit: $(nvcc --version | head -n1)"
    else
        echo "⚠️  CUDA Toolkit not found in PATH"
    fi
    
    # Check PyTorch GPU support
    python3 -c "import torch; print(f'✅ PyTorch GPU: {torch.cuda.is_available()}')" 2>/dev/null || echo "⚠️  PyTorch not available"
    
    # Check TensorFlow GPU support
    python3 -c "import tensorflow as tf; print(f'✅ TensorFlow GPU: {len(tf.config.list_physical_devices(\"GPU\")) > 0}')" 2>/dev/null || echo "⚠️  TensorFlow not available"
else
    echo "⚠️  No NVIDIA GPU detected - GPU features will not be available"
fi

echo ""
echo "🚀 Development environment ready!"
echo "Available tools:"
echo "  - Node.js $(node --version)"
echo "  - Python $(python3 --version)"
echo "  - Git $(git --version)"
echo "  - Claude Code $(claude-code --version 2>/dev/null || echo 'installed')"
echo "  - uv $(uv --version 2>/dev/null || echo 'installed')"
echo "  - pixi $(pixi --version 2>/dev/null || echo 'installed')"
echo ""
echo "Package Managers:"
echo "  - uv: Fast Python package manager (uv add <package>)"
echo "  - pixi: Cross-platform package manager (pixi add <package>)"
echo "  - pip: Traditional Python package manager"
echo "  - npm: Node.js package manager"
echo ""
echo "GPU Monitoring:"
echo "  - nvidia-smi: GPU status and memory"
echo "  - gpustat: Real-time GPU monitoring"
echo "  - nvidia-settings: GPU configuration"
echo ""
echo "Development Tools:"
echo "  - Jupyter: http://localhost:8888"
echo "  - JupyterLab: http://localhost:8888/lab"
echo "  - VS Code: Available in devcontainer"
echo ""
echo "Quick Start:"
echo "  - uv init: Create new Python project"
echo "  - pixi init: Create new cross-platform project"
echo "  - jupyter lab: Start JupyterLab"
echo "  - claude-code: Start Claude Code"
EOF

RUN chmod +x /usr/local/bin/setup-dev-environment.sh

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
COPY postCreateCommand.sh /usr/local/bin/

# Deal with possible Windows line endings and ensure scripts are executable
RUN sed -i 's/\r$//' /usr/local/bin/init-firewall.sh && \
    chmod +x /usr/local/bin/init-firewall.sh
RUN sed -i 's/\r$//' /usr/local/bin/postCreateCommand.sh && \
    chmod +x /usr/local/bin/postCreateCommand.sh

RUN chmod +x /usr/local/bin/init-firewall.sh && \
    echo "developer ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/developer-firewall && \
    chmod 0440 /etc/sudoers.d/developer-firewall

# Persist bash history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && touch /commandhistory/.bash_history \
    && chown -R developer /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set Python environment variables
ENV PYTHONPATH=/workspace:/usr/local/lib/python3.11/site-packages
ENV JUPYTER_CONFIG_DIR=/home/developer/.jupyter

WORKDIR /workspace

EXPOSE 3000 8000 8080 8888

CMD ["/bin/zsh"] 