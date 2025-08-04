# 🚀 Claude Code Startup Guide

## After Devcontainer is Running

### **1. Verify Installation**
```bash
# Check if Claude Code is installed
which claude-code
claude-code --version

# Or check via npm
npm list -g @anthropic-ai/claude-code
```

### **2. Starting Claude Code**

#### **Method 1: Direct Command**
```bash
# Start Claude Code directly
claude-code

# Or with specific workspace
claude-code /workspace
```

#### **Method 2: VS Code Integration**
```bash
# In VS Code terminal within devcontainer:
code .  # Opens current workspace in VS Code
```

#### **Method 3: Web Interface (if available)**
```bash
# Check if web interface is running
curl http://localhost:3000

# Start web interface (if configured)
claude-code --web
```

### **3. Authentication**

#### **First Time Setup**
```bash
# Set up your Anthropic API key
export ANTHROPIC_API_KEY="your-api-key-here"

# Or create .env file
echo "ANTHROPIC_API_KEY=your-api-key-here" > .env
```

#### **API Key Configuration**
```bash
# Check if API key is set
echo $ANTHROPIC_API_KEY

# Set API key for current session
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

### **4. Development Workflow**

#### **Start Development Server**
```bash
# Navigate to your project
cd /workspace

# Start development server
npm run dev
# or
yarn dev
# or
pnpm dev
```

#### **Open Multiple Terminals**
```bash
# In VS Code devcontainer:
# 1. Terminal → New Terminal
# 2. Split terminals for different tasks
```

### **5. Useful Commands**

#### **Claude Code Commands**
```bash
# Help
claude-code --help

# Version
claude-code --version

# Start with specific config
claude-code --config path/to/config.json

# Start in debug mode
claude-code --debug
```

#### **Development Commands**
```bash
# Install dependencies
npm install
# or
yarn install
# or
pnpm install

# Run tests
npm test

# Build project
npm run build

# Lint code
npm run lint
```

### **6. Troubleshooting**

#### **If Claude Code is not found**
```bash
# Reinstall globally
npm install -g @anthropic-ai/claude-code

# Check PATH
echo $PATH
which node
which npm
```

#### **If API key issues**
```bash
# Verify API key
curl -H "x-api-key: $ANTHROPIC_API_KEY" \
  https://api.anthropic.com/v1/messages \
  -d '{"model": "claude-3-sonnet-20240229", "max_tokens": 100, "messages": [{"role": "user", "content": "Hello"}]}'
```

#### **If port conflicts**
```bash
# Check what's using port 3000
lsof -i :3000

# Kill process if needed
kill -9 <PID>
```

### **7. Environment Variables**

#### **Common Environment Variables**
```bash
# API Configuration
export ANTHROPIC_API_KEY="your-api-key"
export CLAUDE_MODEL="claude-3-sonnet-20240229"

# Development
export NODE_ENV="development"
export DEBUG="claude-code:*"

# Port Configuration
export PORT=3000
export HOST=0.0.0.0
```

### **8. Quick Start Script**

Create a startup script:
```bash
#!/bin/bash
# quick-start.sh

echo "🚀 Starting Claude Code Development Environment..."

# Set API key if not already set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Please set your ANTHROPIC_API_KEY:"
    read -s api_key
    export ANTHROPIC_API_KEY="$api_key"
fi

# Start Claude Code
echo "Starting Claude Code..."
claude-code

# Or start development server
# npm run dev
```

Make it executable:
```bash
chmod +x quick-start.sh
./quick-start.sh
```

## 🎯 **Recommended Workflow**

1. **Start Devcontainer** ✅
2. **Verify Claude Code Installation** ✅
3. **Set API Key** ✅
4. **Start Claude Code** ✅
5. **Begin Development** 🚀

## 📝 **Notes**

- Claude Code is pre-installed in the devcontainer
- API key is required for full functionality
- Multiple terminals can be used for different tasks
- Web interface may be available depending on configuration
- All development tools (uv, pixi, etc.) are available 