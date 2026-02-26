#!/bin/bash

# 阿里云部署脚本
# 在项目根目录运行: bash deploy.sh

set -e

echo "========== 开始部署 =========="

# 1. 安装后端依赖
echo "[1/6] 安装后端依赖..."
cd backend
composer install --optimize-autoloader --no-dev

# 2. 安装前端依赖
echo "[2/6] 安装前端依赖..."
cd ../frontend
npm install

# 3. 构建前端生产版本
echo "[3/6] 构建前端..."
npm run build

# 4. 复制前端构建文件到后端 public 目录
echo "[4/6] 复制前端文件到后端..."
rm -rf ../backend/public/*
cp -r dist/* ../backend/public/

# 5. 设置权限
echo "[5/6] 设置权限..."
cd ../backend
chmod -R 755 storage bootstrap/cache
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data .  # 根据你的 Web 服务器用户调整

# 6. 清除缓存
echo "[6/6] 清除缓存..."
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "========== 部署完成 =========="
echo "请确保 Web 服务器配置指向: $(pwd)/public"
