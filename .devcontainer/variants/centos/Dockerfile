# =============================================================================
# CLAUDE CODE DEVCONTAINER - CENTOS/RHEL VARIANT
# =============================================================================
# This variant is optimized for enterprise Linux environments and RHEL compatibility.
# 
# KEY DIFFERENCES FROM UBUNTU BASE:
# - Uses CentOS/RHEL base image (node:20 on CentOS)
# - Uses yum package manager instead of apt
# - Enterprise-grade security features
# - SELinux support and enterprise package ecosystem
# - Largest image size (~1.3GB) due to enterprise packages
# - Slower startup but maximum compatibility
# 
# CENTOS-SPECIFIC CHANGES:
# - Package names: procps-ng, iproute, bind-utils, gnupg2
# - Network tools: bind-utils instead of dnsutils
# - git-delta installation via tar.gz (no package manager)
# - Additional which package for compatibility
# - Enterprise-focused package selection
# =============================================================================

FROM node:20

ARG TZ
ENV TZ="$TZ"

# Install basic development tools and iptables/ipset
# CentOS-specific: Uses yum package manager, different package names
RUN yum update -y && yum install -y less \
  git \
  procps-ng \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  iptables \
  ipset \
  iproute \
  bind-utils \
  jq \
  wget \
  ca-certificates \
  which

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

# CentOS-specific: Install git-delta using tar.gz (no package manager)
# Different from Ubuntu/Debian (.deb) and Alpine (.apk)
RUN wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" && \
  tar -xzf "git-delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" && \
  cp git-delta-0.18.2-x86_64-unknown-linux-gnu/git-delta /usr/local/bin/ && \
  rm -rf "git-delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" "git-delta-0.18.2-x86_64-unknown-linux-gnu"

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Default powerline10k theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude
RUN npm install -g @anthropic-ai/claude-code

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER node 