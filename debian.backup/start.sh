#!/usr/bin/env bash
# 进入核心目录
cd ./topfreeproxies

# 执行节点获取整合
sudo bash start.sh

# 删除python cache
IFS_BAK=$IFS
IFS=$'\n'
for i in $(find ./topfreeproxies -type d -iname "__pycache__")
do
    echo $i ; rm -rfv $i
done
IFS=$IFS_BAK
