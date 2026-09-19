FROM python:3.12-alpine

ARG TARGETARCH

# 安装依赖,并把komari-agent在构建阶段打进镜像
# (Deplexo运行时文件系统只读,无法运行时下载,必须预置到镜像内)
COPY requirements.txt .
RUN apk update && apk --no-cache add openssl bash curl && \
    pip install --no-cache-dir -r requirements.txt && \
    case "$TARGETARCH" in arm64) ARCH=arm64;; *) ARCH=amd64;; esac && \
    curl -fsSL -o /usr/local/bin/komari-agent \
      "https://github.com/komari-monitor/komari-agent/releases/latest/download/komari-agent-linux-${ARCH}" && \
    chmod +x /usr/local/bin/komari-agent

WORKDIR /app
COPY app.py index.html ./

EXPOSE 3000

CMD ["python3", "app.py"]
