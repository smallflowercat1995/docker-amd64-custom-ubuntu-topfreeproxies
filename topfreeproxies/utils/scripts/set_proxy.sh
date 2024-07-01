#!/usr/bin/env bash

pkill -f mihomos
if [ "$?" == "0"  ];then echo yes,i get mihomos and kill it;else echo oh not get;fi

# Initialize Mihomo
./mihomos &

# Setup proxychains
chmod -v 777 /etc/proxychains.conf proxychains.conf
cp -fv proxychains.conf /etc/proxychains.conf

# Run Mihomo
pkill -f mihomos
./mihomos -f clash_config.yml &
