#!/bin/bash

echo "🚀 Claude Code Quick Start Script"
echo "=================================="
echo ""

# Check if we're in a devcontainer
if [ -n "$DEVCONTAINER" ]; then
    echo "✅ Running in devcontainer"
else
    echo "⚠️  Not running in devcontainer"
fi

echo ""

# Check Claude Code installation
echo "🔍 Checking Claude Code installation..."
if command -v claude-code &> /dev/null; then
    echo "✅ Claude Code is installed"
    claude-code --version
else
    echo "❌ Claude Code not found"
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
fi

echo ""

# Check API key
echo "🔑 Checking API key..."
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ API key is set"
    echo "Key: ${ANTHROPIC_API_KEY:0:10}..."
else
    echo "❌ API key not set"
    echo ""
    echo "Please set your Anthropic API key:"
    echo "export ANTHROPIC_API_KEY=\"your-api-key-here\""
    echo ""
    echo "Or create a .env file:"
    echo "echo \"ANTHROPIC_API_KEY=your-api-key-here\" > .env"
    echo ""
    read -p "Would you like to set the API key now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Enter your API key (input will be hidden):"
        read -s api_key
        export ANTHROPIC_API_KEY="$api_key"
        echo "✅ API key set for this session"
    fi
fi

echo ""

# Show available commands
echo "📋 Available Commands:"
echo "======================"
echo ""
echo "1. Start Claude Code:"
echo "   claude-code"
echo ""
echo "2. Start with specific workspace:"
echo "   claude-code /workspace"
echo ""
echo "3. Start development server:"
echo "   npm run dev"
echo ""
echo "4. Check available tools:"
echo "   which uv"
echo "   which pixi"
echo "   python --version"
echo "   node --version"
echo ""

# Ask user what they want to do
echo "🎯 What would you like to do?"
echo "1. Start Claude Code"
echo "2. Start development server"
echo "3. Check available tools"
echo "4. Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "🚀 Starting Claude Code..."
        claude-code
        ;;
    2)
        echo "🚀 Starting development server..."
        npm run dev
        ;;
    3)
        echo "🔧 Checking available tools..."
        echo ""
        echo "Python: $(python --version 2>/dev/null || echo 'Not found')"
        echo "Node.js: $(node --version 2>/dev/null || echo 'Not found')"
        echo "UV: $(which uv 2>/dev/null || echo 'Not found')"
        echo "Pixi: $(which pixi 2>/dev/null || echo 'Not found')"
        echo "Claude Code: $(which claude-code 2>/dev/null || echo 'Not found')"
        echo ""
        echo "Available Python packages:"
        pip list | grep -E "(torch|tensorflow|transformers|numpy|pandas)" | head -10
        ;;
    4)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac 