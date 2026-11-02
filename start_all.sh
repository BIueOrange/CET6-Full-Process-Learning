#!/usr/bin/env bash
# 一键启动翻译 + 写作两个 CET-6 训练应用（后台运行）
# 用法：./start_all.sh   然后按提示在浏览器打开对应地址
set -u
cd "$(dirname "$0")"

# 若已有服务在运行，先停掉，避免端口冲突（双击图标可重启）
[ -f logs/app.pids ] && ./stop_all.sh >/dev/null 2>&1

APPS=(
  "翻译:5559"
  "写作:5560"
)

mkdir -p logs
PIDFILE=logs/app.pids
: > "$PIDFILE"

for entry in "${APPS[@]}"; do
  app="${entry%%:*}"
  port="${entry##*:}"
  ( cd "$app" && NO_OPEN_BROWSER=1 exec nohup ../.venv/bin/python app.py > "../logs/$app.log" 2>&1 ) &
  pid=$!
  echo "$pid" >> "$PIDFILE"
  echo "  $app  ->  http://127.0.0.1:$port  (PID $pid)"
done

echo ""
echo "已启动 ${#APPS[@]} 个应用。停止：./stop_all.sh"
echo "日志在 logs/ 目录下。"

# 打开统一入口页面（macOS）
command -v open >/dev/null 2>&1 && open "$(pwd)/index.html"
