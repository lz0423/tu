#!/bin/bash

# 读取用户输入的线程数、循环次数和下载链接
read -p "请输入线程数（默认为 10）：" num_threads
num_threads=${num_threads:-10}
read -p "请输入循环次数（默认为 4000）：" num_loops
num_loops=${num_loops:-4000}
read -p "请输入下载链接（默认为 https://speed.cloudflare.com/__down?bytes=1073741824）：" url
url=${url:-"https://iptv.tsinghua.edu.cn/st/garbage.php?ckSize=10240"}

# 检查用户输入的线程数和循环次数是否为合法数字
if ! [[ "$num_threads" =~ ^[0-9]+$ ]]; then
  echo "线程数必须为数字！"
  exit 1
fi
if ! [[ "$num_loops" =~ ^[0-9]+$ ]]; then
  echo "循环次数必须为数字！"
  exit 1
fi

# 设置下载速度限制和重试次数
download_speed_limit="1M"  # 下载速度限制为 1MB/s
download_retry_count=10   # 下载失败时重试 10 次

function stop_processes {
  echo "接收到 SIGINT 信号，正在终止进程..."
  pkill -P $$
  exit 1
}

trap stop_processes SIGINT

for ((i=0; i<num_loops; i++)); do
  echo "开始第 $((i+1)) 次下载..."
  for ((j=0; j<num_threads; j++)); do
    curl --retry $download_retry_count --retry-delay 1 --limit-rate $download_speed_limit -o /dev/null $url &
  done
  wait
  echo "第 $((i+1)) 次下载完成！"
done

echo "所有下载操作已完成！"
# read -p "按 Enter 键退出..."
