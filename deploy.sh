#!/bin/bash

# 服务器部署脚本
# 在服务器上手动运行此脚本来测试 Docker 部署

set -e

IMAGE_NAME="vue-manage-system"
CONTAINER_NAME="vue-manage"
PORT="80"

echo "开始部署 $IMAGE_NAME..."

# 停止并删除旧容器
echo "停止旧容器..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# 删除旧镜像
echo "清理旧镜像..."
docker rmi $IMAGE_NAME:latest 2>/dev/null || true

# 从当前目录构建镜像（如果需要本地构建）
if [ -f "Dockerfile" ]; then
    echo "构建新镜像..."
    docker build -t $IMAGE_NAME:latest .
fi

# 启动新容器
echo "启动新容器..."
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p $PORT:80 \
    $IMAGE_NAME:latest

# 检查容器状态
echo "检查容器状态..."
docker ps | grep $CONTAINER_NAME

echo "部署完成！应用已在 http://localhost:$PORT 运行"