#!/usr/bin/env bash
# 停止 start_all.sh 启动的全部应用
cd "$(dirname "$0")"

PIDFILE=logs/app.pids
if [ ! -f "$PIDFILE" ]; then
  echo "没有正在运行的应用。"
  exit 0
fi

while read -r pid; do
  [ -n "$pid" ] && kill "$pid" 2>/dev/null && echo "已停止 PID $pid"
done < "$PIDFILE"

rm -f "$PIDFILE"
echo "全部应用已停止。"
