#!/bin/bash

echo "🚀 Template Devcontainer Runner"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -d ".devcontainer-templates" ]; then
    echo "❌ Error: .devcontainer-templates directory not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "Available templates:"
echo "1. Linux Template (.devcontainer-templates/src/linux/)"
echo "2. Windows Template (.devcontainer-templates/src/windows/)"
echo ""

read -p "Which template would you like to run? (1 or 2): " choice

case $choice in
    1)
        echo "🐧 Starting Linux Template..."
        cd .devcontainer-templates/src/linux/
        echo "✅ Navigated to Linux template directory"
        echo ""
        echo "📋 Next steps:"
        echo "1. Open VS Code in this directory:"
        echo "   code ."
        echo ""
        echo "2. Or use VS Code Command Palette:"
        echo "   Cmd+Shift+P → 'Dev Containers: Open Folder in Container'"
        echo "   Then select: .devcontainer-templates/src/linux/"
        echo ""
        echo "3. Wait for container to build (5-10 minutes)"
        echo ""
        echo "🔧 Template features:"
        echo "   - Ubuntu 22.04 LTS"
        echo "   - Node.js 20 + Python 3.11"
        echo "   - Claude Code pre-installed"
        echo "   - UV & Pixi package managers"
        echo "   - Full data science stack"
        echo "   - GPU support (when available)"
        ;;
    2)
        echo "🪟 Starting Windows Template..."
        cd .devcontainer-templates/src/windows/
        echo "✅ Navigated to Windows template directory"
        echo ""
        echo "📋 Next steps:"
        echo "1. Open VS Code in this directory:"
        echo "   code ."
        echo ""
        echo "2. Or use VS Code Command Palette:"
        echo "   Cmd+Shift+P → 'Dev Containers: Open Folder in Container'"
        echo "   Then select: .devcontainer-templates/src/windows/"
        echo ""
        echo "3. Wait for container to build (5-10 minutes)"
        echo ""
        echo "🔧 Template features:"
        echo "   - Ubuntu 22.04 LTS (WSL2 compatible)"
        echo "   - Node.js 20 + Python 3.11"
        echo "   - Claude Code pre-installed"
        echo "   - UV & Pixi package managers"
        echo "   - Full data science stack"
        echo "   - Windows-specific optimizations"
        echo "   - Eastern Timezone (America/New_York)"
        ;;
    *)
        echo "❌ Invalid choice. Please select 1 or 2."
        exit 1
        ;;
esac

echo ""
echo "🎯 Quick commands after container starts:"
echo "   ./quick-start.sh          # Interactive startup"
echo "   claude-code               # Start Claude Code"
echo "   jupyter lab --port=8888   # Start Jupyter"
echo "   which uv && which pixi    # Check package managers"
echo ""
echo "📚 For more information, see: TEMPLATE_DEVCONTAINER_GUIDE.md"
echo ""
echo "🚀 Ready to start! Open VS Code in the template directory." 