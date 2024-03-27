#!/usr/bin/env bash
clear
#kill -9 $(ps -ef | grep -v grep | grep mihomos | awk '{print $2}')
pkill -f mihomos
if [ "$?" == "0"  ];then echo yes,i get mihomos and kill it;else echo oh not get;fi

# Download mihomo
if [ $(uname -m) = 'x86_64' ];then
    echo "is amd64"
    #version=$(curl -s "https://api.github.com/repos/Dreamacro/clash/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    version=$(curl -s "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    #wget --verbose --show-progress=on --progress=bar --hsts-file=/tmp/wget-hsts --continue --retry-connrefused --waitretry=1 --timeout=30 --tries=3 "https://github.com/Dreamacro/clash/releases/download/$version/clash-linux-amd64-$version.gz" -O clash.gz
    wget --verbose --show-progress=on --progress=bar --hsts-file=/tmp/wget-hsts --continue --retry-connrefused --waitretry=1 --timeout=30 --tries=3 "https://github.com/MetaCubeX/mihomo/releases/download/$version/mihomo-linux-amd64-$version.gz" -O mihomo.gz
else
    echo "is not x86_64"
fi
gunzip -f mihomo.gz
mv -fv ./mihomo ./mihomos
chmod -v +x ./mihomos
rm -fv ./mihomo.gz
# Initialize Mihomo
chmod +x ./mihomos && ./mihomos &

# Setup proxychains
chmod 777 /etc/proxychains.conf
cp -fv ./utils/scripts/proxychains.conf /etc/proxychains.conf

# Run Mihomo
pkill -f mihomos
./mihomos -f ./utils/scripts/clash_config.yml &
