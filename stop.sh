#!/bin/bash

# 一键停止前后端服务脚本

set -e

echo "========== 停止服务 =========="

# 停止后端和前端服务
echo "[1/3] 停止服务..."
supervisorctl stop laravel-backend || true
supervisorctl stop vue-frontend || true

# 可选：停止Supervisor（如果需要完全停止）
# supervisorctl shutdown

# 检查服务状态
echo ""
echo "========== 服务状态 =========="
supervisorctl status

echo ""
echo "========== 服务已停止 =========="