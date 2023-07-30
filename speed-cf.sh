#!/bin/bash

num_threads=10  # 设置线程数
num_loops=9999999999  # 设置总循环次数
url="https://speed.cloudflare.com/__down?bytes=1073741824"  # 下载链接

function stop_processes {
  echo "接收到 SIGINT 信号，正在终止进程..."
  pkill -P $$
  exit 1
}

trap stop_processes SIGINT

for ((i=0; i<$num_loops; i++)); do
  echo "第 $((i+1)) 次下载开始"
  for ((j=0; j<$num_threads; j++)); do
    curl --retry 10 --retry-delay 1 -y 5 -Y 1048576 -m 120 -o /dev/null $url &
  done
  wait
  echo "第 $((i+1)) 次下载结束"
done
