# VS Code에서 Devcontainer 사용 가이드

## 1. 사전 준비

### VS Code 확장 설치
1. VS Code 열기
2. Extensions 탭 (Cmd+Shift+X) 열기
3. 다음 확장들 설치:
   - **Dev Containers** (ms-vscode-remote.remote-containers)
   - **Docker** (ms-azuretools.vscode-docker)
   - **Claude Code** (anthropic.claude-code)

### Docker Desktop 설치 및 시작
```bash
# Docker Desktop 설치 (이미 완료됨)
brew install --cask docker

# Docker Desktop 시작
# Applications 폴더에서 Docker.app 실행
# 또는 Spotlight (Cmd+Space)에서 "Docker" 검색하여 실행
```

## 2. Devcontainer 환경 시작

### 방법 1: VS Code에서 직접 시작
1. VS Code에서 프로젝트 폴더 열기
2. Command Palette (Cmd+Shift+P) 열기
3. "Dev Containers: Rebuild Container" 입력 및 실행
4. 컨테이너 빌드 완료까지 대기 (5-10분 소요)

### 방법 2: Docker Compose 사용
```bash
# 프로젝트 루트에서 실행
.devcontainer/run.sh linux start
```

## 3. M3 최적화 설정

### Docker Desktop 설정
1. Docker Desktop > Settings > Resources
2. Memory: 8GB 이상 할당
3. CPUs: 4개 이상 할당
4. Swap: 2GB 이상 설정
5. Disk image size: 64GB 이상

### VS Code 설정
```json
// .vscode/settings.json
{
  "remote.containers.defaultExtensions": [
    "anthropic.claude-code",
    "ms-vscode.vscode-typescript-next",
    "ms-python.python",
    "ms-toolsai.jupyter",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint"
  ],
  "remote.containers.resources": {
    "memory": "8g",
    "cpus": "4"
  }
}
```

## 4. 컨테이너 내부에서 M3 설치

### 컨테이너 시작 후 실행할 명령어들

```bash
# 1. 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# 2. M3 최적화된 패키지들 설치
sudo apt install -y \
  build-essential \
  cmake \
  pkg-config \
  git \
  curl \
  wget \
  fzf \
  ripgrep \
  bat \
  exa \
  fd \
  jq \
  yq \
  htop \
  tmux \
  neovim \
  zsh

# 3. Node.js 20 설치 (M3 최적화)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 4. Python 3.11 및 개발 도구 설치
sudo apt install -y \
  python3.11 \
  python3.11-dev \
  python3.11-venv \
  python3-pip \
  python3-setuptools \
  python3-wheel

# 5. M3 최적화된 Python 패키지들 설치
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
  torch \
  torchvision \
  transformers \
  datasets \
  streamlit \
  gradio

# 6. Node.js 패키지들 설치
npm install -g \
  @anthropic-ai/claude-code \
  typescript \
  ts-node \
  nodemon \
  eslint \
  prettier \
  yarn \
  pnpm

# 7. Claude Code 초기화
claude init
```

## 5. Claude Code 사용하기

### 기본 사용법
```bash
# Claude Code 실행
claude

# 프로젝트 분석
claude analyze

# 코드 리뷰
claude review

# 특정 파일 설명
claude explain src/main.py

# 테스트 생성
claude test src/calculator.py

# 버그 리포트
claude /bug
```

### M3 최적화 명령어
```bash
# M3 성능 모니터링
htop
lscpu
free -h

# M3 최적화된 빌드
arch -arm64 python3 setup.py build
arch -arm64 npm run build

# M3 특화 환경변수 설정
export ARCHFLAGS="-arch arm64"
export LDFLAGS="-L/opt/homebrew/lib"
export CPPFLAGS="-I/opt/homebrew/include"
```

## 6. 개발 워크플로우

### 1. 새 프로젝트 시작
```bash
# 프로젝트 디렉토리 생성
mkdir my-project
cd my-project

# Claude Code로 프로젝트 초기화
claude init

# Claude Code와 함께 프로젝트 설정
claude "Create a new Python FastAPI project with M3 optimizations"
```

### 2. 코드 개발
```bash
# Claude Code와 함께 개발
claude "Create a REST API endpoint for user management"
claude "Add authentication middleware"
claude "Write unit tests for the API"
claude "Optimize this code for M3 performance"
```

### 3. 디버깅 및 최적화
```bash
# 코드 분석
claude analyze

# 성능 최적화
claude "Review and optimize this code for M3"

# 보안 검토
claude "Review this code for security vulnerabilities"
```

## 7. 문제 해결

### 일반적인 문제들

#### 1. 권한 문제
```bash
# 컨테이너 내부에서 권한 수정
sudo chown -R developer:developer /workspace
sudo chown -R developer:developer /home/developer
```

#### 2. 메모리 부족
```bash
# Node.js 메모리 증가
export NODE_OPTIONS="--max-old-space-size=8192"

# Python 메모리 최적화
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1
```

#### 3. 네트워크 문제
```bash
# 방화벽 재설정
sudo /usr/local/bin/init-firewall.sh
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

## 8. 유용한 팁

### VS Code 단축키
- `Cmd+Shift+P`: Command Palette
- `Cmd+Shift+E`: Explorer
- `Cmd+Shift+X`: Extensions
- `Cmd+J`: Terminal
- `Cmd+Shift+F`: Search

### Devcontainer 명령어
- `Cmd+Shift+P` > "Dev Containers: Rebuild Container"
- `Cmd+Shift+P` > "Dev Containers: Open Folder in Container"
- `Cmd+Shift+P` > "Dev Containers: Show Container Log"

### Claude Code 명령어
- `claude help`: 도움말 보기
- `claude status`: 상태 확인
- `claude config`: 설정 확인
- `claude /bug`: 버그 리포트

이제 VS Code에서 devcontainer 환경을 사용하여 M3의 성능을 최대한 활용할 수 있습니다! 