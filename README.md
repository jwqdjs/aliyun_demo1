# Laravel 10 + Vue 3 全栈项目

基于 FrankenPHP 的高性能 PHP 应用服务器。

## 技术栈

- **后端**: Laravel 10 + FrankenPHP
- **前端**: Vue 3 + TypeScript + Vite
- **数据库**: SQLite
- **Web 服务器**: FrankenPHP (内置 Caddy)

## 环境要求

- PHP 8.2+
- Node.js 20+
- Composer

## 本地开发

### Docker 方式

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down
```

访问:
- 前端: http://localhost:5173
- 后端: http://localhost:8888

### 本地直接运行

```bash
# 后端
cd backend
composer install
cp .env.example .env
php artisan migrate
php artisan serve

# 前端
cd frontend
npm install
npm run dev
```

## 阿里云部署

### 1. 服务器初始化（只需执行一次）

```bash
# SSH 登录服务器
ssh root@你的服务器IP

# 上传并运行安装脚本
curl -O https://raw.githubusercontent.com/你的用户名/aliyun_demo1/main/install-frankenphp.sh
bash install-frankenphp.sh
```

### 2. 部署代码

```bash
cd /var/www/html

# 拉取代码
git pull

# 运行部署脚本
bash deploy.sh
```

### 3. 启动服务

```bash
cd /var/www/html/backend

# 前台运行（测试用）
frankenphp run --config Caddyfile

# 后台运行（生产用）
nohup frankenphp run --config Caddyfile > /var/log/frankenphp.log 2>&1 &
```

### 4. 停止服务

```bash
# 查看进程
ps aux | grep frankenphp

# 停止进程
pkill -f frankenphp

# 或者使用 kill [PID]
```

### 5. 重启服务

```bash
# 停止
pkill -f frankenphp

# 重新部署
cd /var/www/html
git pull
bash deploy.sh

# 启动
cd /var/www/html/backend
nohup frankenphp run --config Caddyfile > /var/log/frankenphp.log 2>&1 &
```

## 服务管理（推荐使用 Supervisor）

安装 Supervisor:
```bash
apt install -y supervisor
```

创建配置文件 `/etc/supervisor/conf.d/frankenphp.conf`:
```ini
[program:frankenphp]
command=/usr/local/bin/frankenphp run --config /var/www/html/backend/Caddyfile
directory=/var/www/html/backend
user=www-data
autostart=true
autorestart=true
stdout_logfile=/var/log/frankenphp.log
stderr_logfile=/var/log/frankenphp_error.log
```

管理命令:
```bash
supervisorctl reread
supervisorctl update
supervisorctl start frankenphp
supervisorctl stop frankenphp
supervisorctl restart frankenphp
supervisorctl status
```

## 目录结构

```
.
├── backend/           # Laravel 后端
│   ├── app/
│   ├── routes/
│   ├── public/
│   └── Caddyfile     # FrankenPHP 配置
├── frontend/          # Vue 3 前端
│   ├── src/
│   └── dist/         # 构建输出
├── deploy.sh         # 部署脚本
├── install-frankenphp.sh  # 服务器安装脚本
└── Caddyfile        # FrankenPHP 配置模板
```

## API 端点

- `GET /` - 根路径，返回 JSON 欢迎信息
- 其他 Laravel 路由

## 常见问题

### 端口被占用
```bash
# 查看端口占用
netstat -tlnp | grep :80

# 停止占用进程
kill -9 [PID]
```

### 权限问题
```bash
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/backend/storage
chmod -R 755 /var/www/html/backend/bootstrap/cache
```

### 查看日志
```bash
# FrankenPHP 日志
tail -f /var/log/frankenphp.log

# Laravel 日志
tail -f /var/www/html/backend/storage/logs/laravel.log
```