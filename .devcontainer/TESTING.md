# DevContainer Testing Guide

This guide explains how to thoroughly test the Claude Code devcontainer configurations to ensure they work properly.

## Quick Test

Run the automated test script to check all configurations:

```bash
# Test all configurations
.devcontainer/test-configs.sh all

# Test specific configuration
.devcontainer/test-configs.sh ubuntu
.devcontainer/test-configs.sh alpine
.devcontainer/test-configs.sh debian
.devcontainer/test-configs.sh centos
.devcontainer/test-configs.sh windows

# Test switch script only
.devcontainer/test-configs.sh switch
```

## Manual Testing Steps

### 1. **Switch Script Testing**

```bash
# Test basic functionality
.devcontainer/switch-config.sh list
.devcontainer/switch-config.sh help
.devcontainer/switch-config.sh current

# Test switching between configurations
.devcontainer/switch-config.sh ubuntu
.devcontainer/switch-config.sh alpine
.devcontainer/switch-config.sh debian
.devcontainer/switch-config.sh centos
.devcontainer/switch-config.sh windows

# Test restore functionality
.devcontainer/switch-config.sh restore
```

### 2. **Configuration File Validation**

For each configuration, verify:

- **devcontainer.json**: Valid JSON syntax, required fields present
- **Dockerfile**: Exists (except Windows), proper base image
- **setup-windows.sh**: Exists and executable (Windows only)

```bash
# Check JSON syntax
jq empty .devcontainer/variants/ubuntu/devcontainer.json
jq empty .devcontainer/variants/alpine/devcontainer.json
jq empty .devcontainer/variants/debian/devcontainer.json
jq empty .devcontainer/variants/centos/devcontainer.json
jq empty .devcontainer/variants/windows/devcontainer.json

# Check file permissions
ls -la .devcontainer/variants/*/Dockerfile
ls -la .devcontainer/variants/windows/setup-windows.sh
```

### 3. **Docker Build Testing** (if Docker is available)

```bash
# Test each configuration build
for config in ubuntu alpine debian centos; do
  echo "Testing $config build..."
  mkdir -p /tmp/test-$config
  cp .devcontainer/variants/$config/devcontainer.json /tmp/test-$config/
  cp .devcontainer/variants/$config/Dockerfile /tmp/test-$config/
  cp .devcontainer/init-firewall.sh /tmp/test-$config/
  cd /tmp/test-$config
  docker build -t claude-code-test-$config .
  docker rmi claude-code-test-$config
  cd -
  rm -rf /tmp/test-$config
done
```

### 4. **VS Code Integration Testing**

1. **Install Dev Containers Extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Dev Containers" by Microsoft
   - Install the extension

2. **Test Container Rebuild**
   - Open Command Palette (Ctrl+Shift+P)
   - Run "Dev Containers: Rebuild Container"
   - Verify container starts successfully

3. **Test Configuration Switching**
   ```bash
   # Switch to different configuration
   .devcontainer/switch-config.sh alpine
   
   # Rebuild container in VS Code
   # Command Palette → "Dev Containers: Rebuild Container"
   ```

### 5. **Runtime Testing**

Once inside a devcontainer, test:

```bash
# Check Node.js version
node --version

# Check Claude Code installation
claude --version

# Check timezone
date
echo $TZ

# Check environment variables
echo $NODE_OPTIONS
echo $CLAUDE_CONFIG_DIR

# Check VS Code extensions
code --list-extensions | grep -E "(eslint|prettier|gitlens)"

# Check shell configuration
echo $SHELL
which zsh

# Check git-delta installation
git --version
git config --global core.pager

# Check firewall script
ls -la /usr/local/bin/init-firewall.sh
```

### 6. **Package Manager Testing**

Test package installation for each variant:

```bash
# Ubuntu/Debian (apt)
sudo apt update
sudo apt install -y curl

# Alpine (apk)
sudo apk add --no-cache curl

# CentOS (yum)
sudo yum install -y curl
```

### 7. **Performance Testing**

Compare startup times and resource usage:

```bash
# Measure container startup time
time docker run --rm claude-code-test-ubuntu echo "startup complete"
time docker run --rm claude-code-test-alpine echo "startup complete"

# Check image sizes
docker images | grep claude-code-test
```

## Common Issues and Solutions

### **Issue: "Dev Containers: Rebuild Container" not found**
- **Solution**: Install the Dev Containers extension in VS Code
- **Alternative**: Close and reopen the project in VS Code

### **Issue: Docker build fails**
- **Solution**: Ensure Docker Desktop is running
- **Check**: `docker --version` and `docker ps`

### **Issue: Permission denied on scripts**
- **Solution**: Make scripts executable
  ```bash
  chmod +x .devcontainer/switch-config.sh
  chmod +x .devcontainer/test-configs.sh
  chmod +x .devcontainer/variants/windows/setup-windows.sh
  ```

### **Issue: Timezone not set correctly**
- **Check**: Verify `TZ` environment variable in devcontainer.json
- **Solution**: Ensure all variants use `America/New_York`

### **Issue: VS Code extensions not installed**
- **Check**: Verify extensions array in devcontainer.json
- **Solution**: Rebuild container after switching configurations

## Automated Testing

The `test-configs.sh` script performs these checks automatically:

1. **File Structure Validation**
   - Variant directories exist
   - Required files present
   - Proper permissions

2. **Configuration Validation**
   - JSON syntax validation
   - Required environment variables
   - VS Code extensions
   - Timezone configuration

3. **Docker Build Testing** (if available)
   - Builds each configuration
   - Verifies successful build
   - Cleans up test images

4. **Switch Script Testing**
   - Script exists and is executable
   - Help and list commands work
   - Configuration switching works

## Test Results Interpretation

### **All Tests Pass** ✅
- Configurations are ready for use
- Proceed with VS Code integration

### **Some Tests Fail** ⚠️
- Review error messages
- Fix identified issues
- Re-run tests

### **Docker Build Fails** 🐳
- Check Docker installation
- Verify Docker Desktop is running
- Check available disk space and memory

## Next Steps After Testing

1. **Choose your preferred configuration**
   ```bash
   .devcontainer/switch-config.sh ubuntu  # or alpine, debian, centos, windows
   ```

2. **Open in VS Code**
   - Open the project folder in VS Code
   - Install Dev Containers extension if prompted

3. **Rebuild container**
   - Command Palette → "Dev Containers: Rebuild Container"
   - Wait for container to build and start

4. **Verify functionality**
   - Check terminal shows correct shell (zsh)
   - Verify Claude Code is available (`claude --version`)
   - Test VS Code extensions are working

## Continuous Testing

For ongoing development, run tests:

```bash
# Before committing changes
.devcontainer/test-configs.sh all

# After switching configurations
.devcontainer/test-configs.sh <config_name>

# When adding new variants
# Add new configuration to test script and run full test suite
``` 