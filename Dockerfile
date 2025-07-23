# 第一阶段：构建前端项目
FROM node:20 AS build

WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# 第二阶段：部署到 Nginx，部署目录为 /workspace/dist
FROM nginx:alpine

# 创建部署目录
RUN mkdir -p /workspace/dist

# 拷贝构建产物到部署目录
COPY --from=build /app/dist /workspace/dist

# 覆盖 Nginx 配置，设置根目录为 /workspace/dist
COPY nginx.conf /etc/nginx/nginx.conf
