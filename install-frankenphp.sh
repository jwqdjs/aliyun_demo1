#!/bin/bash

# 阿里云服务器环境安装脚本
# 在 root 用户下运行: bash install-frankenphp.sh

set -e

echo "========== 安装 FrankenPHP 环境 =========="

# 检测系统
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "无法检测系统版本"
    exit 1
fi

echo "检测到系统: $OS"

# 安装 PHP 8.2
echo "[1/5] 安装 PHP 8.2..."

if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
    apt update
    apt install -y software-properties-common
    add-apt-repository -y ppa:ondrej/php
    apt update
    apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-sqlite3 php8.2-mbstring php8.2-xml php8.2-curl php8.2-zip php8.2-bcmath php8.2-intl
elif [ "$OS" = "centos" ] || [ "$OS" = "rocky" ] || [ "$OS" = "alma" ]; then
    yum install -y epel-release
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
    yum module reset php
    yum module enable php:remi-8.2
    yum install -y php php-cli php-fpm php-sqlite3 php-mbstring php-xml php-curl php-zip php-bcmath php-intl
else
    echo "不支持的系统: $OS"
    exit 1
fi

# 安装 Composer
echo "[2/5] 安装 Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 安装 FrankenPHP
echo "[3/5] 安装 FrankenPHP..."
FRANKENPHP_VERSION="1.0.6"
curl -sL "https://github.com/dunglas/frankenphp/releases/download/v${FRANKENPHP_VERSION}/frankenphp-linux-x86_64" -o /usr/local/bin/frankenphp
chmod +x /usr/local/bin/frankenphp

# 创建 www 用户（如果不存在）
echo "[4/5] 配置用户权限..."
id -u www-data &>/dev/null || useradd -r -s /usr/sbin/nologin www-data

# 配置防火墙
echo "[5/5] 配置防火墙..."
if command -v ufw &> /dev/null; then
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 8080/tcp
fi

echo ""
echo "========== 安装完成 =========="
echo ""
echo "下一步操作:"
echo "1. 上传代码到 /var/www/html"
echo "2. cd /var/www/html/backend"
echo "3. cp .env.production .env"
echo "4. composer install"
echo "5. frankenphp run --config Caddyfile"
echo ""
echo "如需后台运行，使用: nohup frankenphp run --config Caddyfile > /var/log/frankenphp.log 2>&1 &"