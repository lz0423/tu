#!/bin/bash

num_threads=10  # 设置线程数
num_loops=9999999999  # 设置总循环次数
url="https://yun.mcloud.139.com/mCloud/mCloud_10.1.1_2310111_000.apk"  # 下载链接

# 引入 input.sh 脚本，获取用户输入流量大小和单位
source ~ https://ghproxy.com/https://raw.githubusercontent.com/lz0423/tu/main/input.sh

case $unit in
  "mb"|"MB")
    max_bytes=$((size * 1024 * 1024))
    ;;
  "gb"|"GB")
    max_bytes=$((size * 1024 * 1024 * 1024))
    ;;
  *)
    echo "不支持的流量单位: $unit"
    exit 1
    ;;
esac

bytes_downloaded=0  # 初始化已下载字节数为 0

function stop_processes {
  echo "接收到 SIGINT 信号，正在终止进程..."
  pkill -P $$
  exit 1
}

trap stop_processes SIGINT

while [ $bytes_downloaded -lt $max_bytes ]
do
  echo "第 $((++num_loops)) 次下载开始"
  for ((j=0; j<$num_threads; j++)); do
    curl --retry 10 --retry-delay 1 -y 5 -Y 1048576 -m 120 -o /dev/null $url &
  done
  wait
  bytes_downloaded=$((bytes_downloaded + 10737418240))  # 每次下载完成后累加已下载字节数
  echo "已下载字节数: $bytes_downloaded"
done

echo "已达到设定的流量限制，停止下载。"    curl --retry 10 --retry-delay 1 -y 5 -Y 1048576 -m 120 -o /dev/null $url &
  done
  wait
  bytes_downloaded=$((bytes_downloaded + 10737418240))  # 每次下载完成后累加已下载字节数
  echo "已下载字节数: $bytes_downloaded"
done

echo "已达到设定的流量限制，停止下载。"
