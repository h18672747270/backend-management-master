# 以 node 构建镜像为基础
FROM node:20 as build

# 设置工作目录
WORKDIR /app

# 拷贝代码
COPY . .

# 安装依赖
RUN npm install

# 构建生产包
RUN npm run build

# 第二阶段，使用 nginx 作为部署容器
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
