#!/bin/bash

# 一键启动前后端服务脚本
# 使用Supervisor管理PHP进程，npm运行前端

set -e

echo "========== 启动服务 =========="

# 获取公网IP
PUBLIC_IP=$(curl -s -4 ifconfig.me || curl -s -4 ipinfo.io/ip || hostname -I | awk '{print $1}')
echo "公网IP: $PUBLIC_IP"

# 检查Supervisor是否运行
if ! pgrep -x "supervisord" > /dev/null; then
    echo "[1/6] 启动Supervisor..."
    supervisord -c /etc/supervisor/supervisord.conf
else
    echo "[1/6] Supervisor已在运行"
fi

# 更新Supervisor配置
echo "[2/6] 更新服务配置..."
supervisorctl reread
supervisorctl update

# 确保后端依赖已安装
if [ ! -d "/root/Exec/laravel_workspace/aliyun_demo1/backend/vendor" ]; then
    echo "[3/6] 安装后端依赖..."
    cd /root/Exec/laravel_workspace/aliyun_demo1/backend
    COMPOSER_ALLOW_SUPERUSER=1 composer update --no-interaction
fi

# 确保.env存在
if [ ! -f "/root/Exec/laravel_workspace/aliyun_demo1/backend/.env" ]; then
    echo "[4/6] 配置环境变量..."
    cp /root/Exec/laravel_workspace/aliyun_demo1/backend/.env.production /root/Exec/laravel_workspace/aliyun_demo1/backend/.env
    php artisan key:generate --force
fi

# 确保前端依赖已安装
if [ ! -d "/root/Exec/laravel_workspace/aliyun_demo1/frontend/node_modules" ]; then
    echo "[5/6] 安装前端依赖..."
    cd /root/Exec/laravel_workspace/aliyun_demo1/frontend
    npm install
fi

# 启动后端和前端服务
echo "[6/6] 启动前后端服务..."
supervisorctl start laravel-backend
supervisorctl start vue-frontend

# 等待服务启动
sleep 3

# 检查服务状态
echo ""
echo "========== 服务状态 =========="
supervisorctl status

echo ""
echo "========== 访问地址 =========="
echo "前端: http://$PUBLIC_IP:5173"
echo "后端: http://$PUBLIC_IP:8000"
echo "============================="