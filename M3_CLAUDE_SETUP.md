# M3 설치 및 Claude Code 실행 가이드

## 1. Devcontainer 환경 시작

### VS Code에서 Devcontainer 시작
1. VS Code에서 프로젝트 폴더 열기
2. Command Palette (Cmd+Shift+P / Ctrl+Shift+P) 열기
3. "Dev Containers: Rebuild Container" 실행
4. 컨테이너 빌드 완료까지 대기

### 또는 Docker Compose로 시작
```bash
# Linux 환경 시작
.devcontainer/run.sh linux start

# Windows 환경 시작  
.devcontainer/run.sh windows start
```

## 2. M3 설치

### Apple Silicon M3 환경에서 M3 최적화 설치

```bash
# 컨테이너 내부에서 실행
# 1. Homebrew 설치 (M3 최적화)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 환경변수 설정
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc

# 3. M3 최적화된 패키지들 설치
brew install \
  node@20 \
  python@3.11 \
  git \
  fzf \
  ripgrep \
  bat \
  exa \
  fd \
  jq \
  yq \
  htop \
  tmux \
  neovim

# 4. Python 패키지들 설치 (M3 최적화)
pip3 install --upgrade pip
pip3 install \
  numpy \
  pandas \
  matplotlib \
  seaborn \
  scipy \
  scikit-learn \
  jupyter \
  jupyterlab \
  ipykernel \
  black \
  pylint \
  mypy \
  pytest \
  requests \
  beautifulsoup4 \
  flask \
  fastapi \
  uvicorn \
  sqlalchemy \
  redis \
  pymongo \
  docker \
  kubernetes \
  boto3 \
  opencv-python \
  pillow \
  tensorflow-macos \
  torch \
  torchvision \
  transformers \
  datasets \
  streamlit \
  gradio

# 5. Node.js 패키지들 설치
npm install -g \
  @anthropic-ai/claude-code \
  typescript \
  ts-node \
  nodemon \
  eslint \
  prettier \
  yarn \
  pnpm
```

## 3. Claude Code 실행

### 기본 실행
```bash
# Claude Code 실행
claude

# 또는 특정 프로젝트에서 실행
cd /workspace
claude
```

### Claude Code 설정
```bash
# Claude Code 초기 설정
claude init

# API 키 설정 (필요한 경우)
export ANTHROPIC_API_KEY="your-api-key-here"
```

### Claude Code 사용 예시
```bash
# 프로젝트 분석
claude analyze

# 코드 리뷰
claude review

# 버그 리포트
claude /bug

# 특정 파일 설명
claude explain src/main.py

# 테스트 생성
claude test src/calculator.py
```

## 4. M3 최적화 설정

### Docker 설정 최적화
```bash
# Docker Desktop에서 M3 최적화 설정
# 1. Docker Desktop > Settings > Resources
# 2. Memory: 8GB 이상 할당
# 3. CPUs: 4개 이상 할당
# 4. Swap: 2GB 이상 설정
```

### VS Code 설정 최적화
```json
{
  "remote.containers.defaultExtensions": [
    "anthropic.claude-code",
    "ms-vscode.vscode-typescript-next",
    "ms-python.python",
    "ms-toolsai.jupyter"
  ],
  "remote.containers.resources": {
    "memory": "8g",
    "cpus": "4"
  }
}
```

## 5. 개발 워크플로우

### 1. 프로젝트 시작
```bash
# 새 프로젝트 생성
mkdir my-project
cd my-project
claude init

# Claude Code로 프로젝트 설정
claude "Create a new Python project with FastAPI"
```

### 2. 코드 개발
```bash
# Claude Code와 함께 개발
claude "Create a REST API endpoint for user management"
claude "Add authentication middleware"
claude "Write unit tests for the API"
```

### 3. 디버깅 및 최적화
```bash
# 코드 분석
claude analyze

# 성능 최적화
claude "Optimize this code for M3 performance"

# 보안 검토
claude "Review this code for security vulnerabilities"
```

## 6. 문제 해결

### 일반적인 문제들

#### 1. 권한 문제
```bash
# 컨테이너 내부에서 권한 수정
sudo chown -R developer:developer /workspace
sudo chown -R developer:developer /home/developer
```

#### 2. 네트워크 문제
```bash
# 방화벽 재설정
sudo /usr/local/bin/init-firewall.sh
```

#### 3. 메모리 부족
```bash
# Node.js 메모리 증가
export NODE_OPTIONS="--max-old-space-size=8192"

# Python 메모리 최적화
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1
```

#### 4. M3 성능 최적화
```bash
# M3 특화 환경변수
export ARCHFLAGS="-arch arm64"
export LDFLAGS="-L/opt/homebrew/lib"
export CPPFLAGS="-I/opt/homebrew/include"

# Python 패키지 재설치 (M3 최적화)
pip3 install --force-reinstall --no-cache-dir numpy pandas
```

## 7. 유용한 명령어들

### 개발 도구
```bash
# 프로젝트 상태 확인
claude status

# Git 작업
claude "Commit all changes with message 'feat: add new feature'"
claude "Create a new branch for feature development"

# 테스트 실행
claude "Run all tests"
claude "Generate test coverage report"

# 문서 생성
claude "Generate API documentation"
claude "Create README for this project"
```

### M3 특화 명령어
```bash
# M3 성능 모니터링
htop
system_profiler SPHardwareDataType

# M3 최적화된 빌드
arch -arm64 python3 setup.py build
arch -arm64 npm run build
```

이제 devcontainer 환경에서 M3의 성능을 최대한 활용하여 Claude Code와 함께 개발할 수 있습니다! 