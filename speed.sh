#!/bin/bash

num_threads=10  # 设置线程数
num_loops=99999999999  # 设置总循环次数
url="https://13d9d95a733ff7b76f0f17481fa84231.dlied1.cdntips.net/dlied4.myapp.com/myapp/1104466820/cos.release-40109/10040714_com.tencent.tmgp.sgame_a2680838_8.4.1.6_fL2tC9.apk?mkey=lego_ztc&f=00&sche_type=7&cip=42.203.52.30&proto=https&access_type="
#url="https://storage.jd.com/jdmobile/JDMALL-PC2.apk"  # 下载链接

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
