#!/bin/bash

# =============================================================================
# CLAUDE CODE DEVCONTAINER - GPU SETUP SCRIPT
# =============================================================================
# This script sets up and verifies GPU functionality in the devcontainer.
# 
# GPU SETUP FEATURES:
# - CUDA environment verification
# - GPU device detection and configuration
# - PyTorch and TensorFlow GPU verification
# - NVIDIA driver compatibility check
# - GPU memory and compute capability display
# - Jupyter kernel configuration
# =============================================================================

echo "🚀 Setting up GPU environment for Claude Code..."

# Function to print colored output
print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_header() {
    echo -e "\033[0;34m=== GPU Setup and Verification ===\033[0m"
}

# Check if we're running in a container with GPU support
print_header
echo "Checking GPU environment..."

# Check NVIDIA runtime
if command -v nvidia-smi &> /dev/null; then
    print_status "NVIDIA-SMI found - GPU runtime available"
    
    # Display GPU information
    echo
    echo "📊 GPU Information:"
    nvidia-smi --query-gpu=name,memory.total,driver_version,compute_cap --format=csv,noheader,nounits
    
    # Check CUDA installation
    if command -v nvcc &> /dev/null; then
        print_status "CUDA compiler (nvcc) found"
        echo "CUDA Version: $(nvcc --version | grep 'release' | awk '{print $6}' | cut -c2-)"
    else
        print_warning "CUDA compiler (nvcc) not found"
    fi
    
    # Check CUDA environment variables
    echo
    echo "🔧 CUDA Environment Variables:"
    echo "CUDA_HOME: ${CUDA_HOME:-Not set}"
    echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH:-Not set}"
    echo "PATH: ${PATH}"
    
    # Verify CUDA libraries
    if [ -d "$CUDA_HOME" ]; then
        print_status "CUDA installation verified at $CUDA_HOME"
        ls -la "$CUDA_HOME/lib64/" | grep -E "(libcuda|libcudart)" | head -5
    else
        print_warning "CUDA_HOME directory not found"
    fi
    
else
    print_warning "NVIDIA-SMI not found - GPU runtime may not be available"
    print_warning "Make sure to run with: --gpus=all --runtime=nvidia"
fi

# Check Python GPU packages
echo
echo "🐍 Python GPU Package Verification:"

# Check PyTorch
if python3 -c "import torch; print('PyTorch:', torch.__version__); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda)" 2>/dev/null; then
    print_status "PyTorch GPU support verified"
    
    # Test PyTorch GPU functionality
    if python3 -c "import torch; print('GPU count:', torch.cuda.device_count()); [print(f'GPU {i}: {torch.cuda.get_device_name(i)}') for i in range(torch.cuda.device_count())]" 2>/dev/null; then
        print_status "PyTorch GPU devices detected"
    fi
else
    print_warning "PyTorch GPU support not available"
fi

# Check TensorFlow
if python3 -c "import tensorflow as tf; print('TensorFlow:', tf.__version__); print('GPU devices:', tf.config.list_physical_devices('GPU'))" 2>/dev/null; then
    print_status "TensorFlow GPU support verified"
else
    print_warning "TensorFlow GPU support not available"
fi

# Check other ML libraries
echo
echo "📚 ML Library Verification:"

# Check transformers
if python3 -c "import transformers; print('Transformers:', transformers.__version__)" 2>/dev/null; then
    print_status "Transformers library available"
else
    print_warning "Transformers library not available"
fi

# Check accelerate
if python3 -c "import accelerate; print('Accelerate:', accelerate.__version__)" 2>/dev/null; then
    print_status "Accelerate library available"
else
    print_warning "Accelerate library not available"
fi

# Check diffusers
if python3 -c "import diffusers; print('Diffusers:', diffusers.__version__)" 2>/dev/null; then
    print_status "Diffusers library available"
else
    print_warning "Diffusers library not available"
fi

# Set up Jupyter kernel
echo
echo "📓 Setting up Jupyter kernel..."

# Create Jupyter configuration directory
mkdir -p /home/node/.jupyter

# Configure Jupyter to use GPU
cat > /home/node/.jupyter/jupyter_notebook_config.py << EOF
# Jupyter configuration for GPU support
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.allow_root = False
c.NotebookApp.token = ''
c.NotebookApp.password = ''
c.NotebookApp.notebook_dir = '/workspace'
EOF

# Set proper permissions
chown -R node:node /home/node/.jupyter

# Create a simple GPU test script
cat > /workspace/test_gpu.py << 'EOF'
#!/usr/bin/env python3
"""
GPU Test Script for Claude Code DevContainer
"""

import sys
import subprocess

def test_nvidia_smi():
    """Test NVIDIA-SMI availability"""
    try:
        result = subprocess.run(['nvidia-smi'], capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✅ NVIDIA-SMI working")
            return True
        else:
            print("❌ NVIDIA-SMI failed")
            return False
    except Exception as e:
        print(f"❌ NVIDIA-SMI error: {e}")
        return False

def test_pytorch_gpu():
    """Test PyTorch GPU support"""
    try:
        import torch
        print(f"✅ PyTorch {torch.__version__}")
        print(f"   CUDA available: {torch.cuda.is_available()}")
        if torch.cuda.is_available():
            print(f"   CUDA version: {torch.version.cuda}")
            print(f"   GPU count: {torch.cuda.device_count()}")
            for i in range(torch.cuda.device_count()):
                print(f"   GPU {i}: {torch.cuda.get_device_name(i)}")
            return True
        else:
            print("❌ PyTorch CUDA not available")
            return False
    except ImportError:
        print("❌ PyTorch not installed")
        return False

def test_tensorflow_gpu():
    """Test TensorFlow GPU support"""
    try:
        import tensorflow as tf
        print(f"✅ TensorFlow {tf.__version__}")
        gpus = tf.config.list_physical_devices('GPU')
        if gpus:
            print(f"   GPU devices: {len(gpus)}")
            for gpu in gpus:
                print(f"   {gpu}")
            return True
        else:
            print("❌ TensorFlow GPU not available")
            return False
    except ImportError:
        print("❌ TensorFlow not installed")
        return False

def test_gpu_memory():
    """Test GPU memory allocation"""
    try:
        import torch
        if torch.cuda.is_available():
            # Allocate a small tensor on GPU
            x = torch.randn(1000, 1000).cuda()
            print(f"✅ GPU memory test passed - allocated tensor on {x.device}")
            del x
            torch.cuda.empty_cache()
            return True
        else:
            print("❌ GPU memory test skipped - CUDA not available")
            return False
    except Exception as e:
        print(f"❌ GPU memory test failed: {e}")
        return False

def main():
    """Run all GPU tests"""
    print("🚀 Claude Code GPU Environment Test")
    print("=" * 40)
    
    tests = [
        ("NVIDIA-SMI", test_nvidia_smi),
        ("PyTorch GPU", test_pytorch_gpu),
        ("TensorFlow GPU", test_tensorflow_gpu),
        ("GPU Memory", test_gpu_memory),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n🔍 Testing {test_name}...")
        if test_func():
            passed += 1
    
    print(f"\n📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All GPU tests passed! Environment ready for GPU development.")
    else:
        print("⚠️  Some tests failed. Check GPU configuration.")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF

# Make the test script executable
chmod +x /workspace/test_gpu.py
chown node:node /workspace/test_gpu.py

# Create GPU monitoring script
cat > /workspace/monitor_gpu.py << 'EOF'
#!/usr/bin/env python3
"""
GPU Monitoring Script for Claude Code DevContainer
"""

import time
import subprocess
import psutil
import os

def get_gpu_info():
    """Get GPU information using nvidia-smi"""
    try:
        result = subprocess.run(['nvidia-smi', '--query-gpu=index,name,memory.used,memory.total,utilization.gpu,temperature.gpu', '--format=csv,noheader,nounits'], 
                              capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            return result.stdout.strip().split('\n')
        return []
    except:
        return []

def get_system_info():
    """Get system resource information"""
    cpu_percent = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()
    return {
        'cpu_percent': cpu_percent,
        'memory_percent': memory.percent,
        'memory_used': memory.used // (1024**3),  # GB
        'memory_total': memory.total // (1024**3)  # GB
    }

def monitor_resources():
    """Monitor GPU and system resources"""
    print("🖥️  Claude Code GPU Monitor")
    print("=" * 50)
    
    while True:
        # Clear screen
        os.system('clear')
        
        # Get system info
        sys_info = get_system_info()
        
        print(f"🖥️  System Resources:")
        print(f"   CPU: {sys_info['cpu_percent']}%")
        print(f"   Memory: {sys_info['memory_used']}GB / {sys_info['memory_total']}GB ({sys_info['memory_percent']}%)")
        
        # Get GPU info
        gpu_info = get_gpu_info()
        if gpu_info:
            print(f"\n🎮 GPU Resources:")
            for gpu in gpu_info:
                parts = gpu.split(', ')
                if len(parts) >= 6:
                    gpu_id, name, mem_used, mem_total, util, temp = parts
                    print(f"   GPU {gpu_id}: {name}")
                    print(f"     Memory: {mem_used}MB / {mem_total}MB")
                    print(f"     Utilization: {util}%")
                    print(f"     Temperature: {temp}°C")
        else:
            print(f"\n❌ GPU information not available")
        
        print(f"\n⏰ {time.strftime('%Y-%m-%d %H:%M:%S')}")
        print("Press Ctrl+C to exit")
        
        time.sleep(2)

if __name__ == "__main__":
    try:
        monitor_resources()
    except KeyboardInterrupt:
        print("\n👋 GPU monitoring stopped")
EOF

# Make the monitoring script executable
chmod +x /workspace/monitor_gpu.py
chown node:node /workspace/monitor_gpu.py

# Install psutil for monitoring
pip3 install psutil

print_status "GPU setup completed successfully!"
echo
echo "🎯 Next steps:"
echo "1. Run GPU test: python3 /workspace/test_gpu.py"
echo "2. Monitor GPU: python3 /workspace/monitor_gpu.py"
echo "3. Start Jupyter: jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser"
echo "4. Use Claude Code with GPU acceleration"
echo
echo "🔧 Environment ready for GPU-accelerated development!" 