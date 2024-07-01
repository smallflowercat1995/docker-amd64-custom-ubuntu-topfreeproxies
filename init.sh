#!/usr/bin/env bash
apt update
apt -y install eatmydata aptitude
echo "安装 libproxychains3"
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install proxychains cron gzip python3 python3-pip wget sudo procps curl openssh-server iputils-ping git
if [ -e $(command -v python3) ]
then
    sudo ln -fsv $(command -v python3) /usr/bin/python
    sudo ln -fsv $(command -v pip3) /usr/bin/pip
else
    echo "python3 not exist"
fi

# 获取Python版本
version=$(python --version 2>&1 | awk '{print $2}')
IFS='.' read -ra ADDR <<< "$version"

# 检查版本是否为2
if [[ ${ADDR[0]} -eq 2 ]]
then
    echo "版本过低"
elif [[ ${ADDR[0]} -eq 3 ]]
then
    # 检查版本是否小于等于3.10
    if [[ ${ADDR[1]} -le 10 ]]
    then
        pip --no-cache-dir install -U pip
        pip --no-cache-dir install -r requirements.txt
    else
        pip --no-cache-dir install -U pip --break-system-packages
        pip --no-cache-dir install -r requirements.txt --break-system-packages
    fi
else
    echo "超出版本预期"
fi

# 改时区 安装基本命令
sudo date '+%Y-%m-%d %H:%M:%S'
sudo rm -fv /etc/localtime.bak*
sudo cp -frv /etc/localtime /etc/localtime.bak
sudo rm -rfv /etc/localtime
sudo ln -fsv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo echo "Asia/Shanghai" | tee /etc/timezone
sudo date '+%Y-%m-%d %H:%M:%S'

# clone sing-box-subscribe.git 订阅 clash/v2ray 转换 singbox
rm -rfv /topfreeproxies/sing-box-subscribe.bak/* /topfreeproxies/sing-box-subscribe.bak/.*
git clone https://github.com/Toperlock/sing-box-subscribe /topfreeproxies/sing-box-subscribe.bak
git config --global --add safe.directory /topfreeproxies/sing-box-subscribe.bak
cd /topfreeproxies/sing-box-subscribe.bak
git fetch --all
git reset --hard origin/main
git pull
cd /
