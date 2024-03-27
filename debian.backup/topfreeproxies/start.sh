#!/usr/bin/env bash
bash ./utils/scripts/set_proxy.sh
chmod -v +x ./utils/subconverter/subconverter ./utils/litespeedtest/lite
python ./utils/main.py
sed -i 's;port: 7890;port: 7891;g;s;socks-port: 7891;socks-port: 7892;g;s;external-controller: :9090;external-controller: :7894;g' ./Eternity.yaml
sed -i '3i\
mixed-port: 7893\
redir-port: 7895\
tproxy-port: 7896' ./Eternity.yaml

# 新增 singbox 转换生成
SOURCE_PATH=$(pwd)

# 下载订阅文件
wget -t 3 -T 10 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://neko-warp.nloli.xyz/neko_warp.yaml" -O ${SOURCE_PATH}/nekowarp.yaml

# 关闭开启本地 http 协议访问
kill -9 $(ps -ef | grep -v grep | grep "http.server" | awk '{print $2}')
nohup python -m http.server > /dev/null 2>&1 & disown

# clone sing-box-subscribe.git 订阅 clash/v2ray 转换 singbox
git clone https://github.com/Toperlock/sing-box-subscribe.git ${SOURCE_PATH}/sing-box-subscribe.bak ; git config --global --add safe.directory ${SOURCE_PATH}/sing-box-subscribe.bak ; cd ${SOURCE_PATH}/sing-box-subscribe.bak ; git fetch --all ; git reset --hard origin/master ; git pull

# 替换解析模板配置文件
# 添加 str() 函数
sed -i "s;\"ps\": share_link\['name'\];\"ps\": str(share_link\['name'\]);g" ${SOURCE_PATH}/sing-box-subscribe.bak/parsers/clash2base64.py
grep -i "\"ps\": str(share_link\['name'\])" ${SOURCE_PATH}/sing-box-subscribe.bak/parsers/clash2base64.py

# 自定义配置函数
custom_config(){
cat << SMALLFLOWERCAT1995 > ${SOURCE_PATH}/sing-box-subscribe.bak/config_template/config_template_groups_rule_set_tun.json
{
  "log": {
    "level": "debug",
    "timestamp": true
  },
  "experimental": {
    "clash_api": {
      "external_controller": ":7894",
      "external_ui": "ui",
      "secret": "",
      "external_ui_download_url": "https://mirror.ghproxy.com/https://github.com/MetaCubeX/Yacd-meta/archive/gh-pages.zip",
      "external_ui_download_detour": "direct",
      "default_mode": "rule"
    },
    "cache_file": {
      "enabled": true,
      "path": "cache.db",
      "cache_id": "cache",
      "store_fakeip": true
    }
  },
  "dns": {
    "servers": [
      {
        "tag": "cloudflare",
        "address": "tls://1.0.0.1",
        "detour": "direct"
      },
      {
        "tag": "local",
        "address": "119.29.29.29",
        "detour": "direct"
      },
      {
        "tag": "gladns",
        "address_resolver": "local",
        "detour": "direct",
        "address": "https://glados-config.com/dns-query"
      },
      {
        "tag": "block",
        "address": "rcode://success"
      }
    ],
    "final": "cloudflare",
    "rules": [
      {
        "geosite": [
          "category-pt",
          "category-public-tracker"
        ],
        "server": "block",
        "disable_cache": false
      },
      {
        "domain_suffix": [
          "gladns.com"
        ],
        "rewrite_ttl": 300,
        "server": "local"
      },
      {
        "outbound": "any",
        "rewrite_ttl": 300,
        "server": "local"
      },
      {
        "geosite": "cn",
        "server": "local"
      },
      {
        "geosite": "cn",
        "invert": true,
        "rewrite_ttl": 900,
        "server": "gladns"
      }
    ],
    "strategy": "ipv4_only"
  },
  "inbounds": [
    {
      "type": "tun",
      "inet4_address": "172.19.0.1/30",
      "auto_route": true,
      "strict_route": false,
      "sniff": true
    },
    {
      "type": "http",
      "listen": "0.0.0.0",
      "listen_port": 7891,
      "sniff": true,
      "users": []
    },
    {
      "type": "socks",
      "listen": "0.0.0.0",
      "listen_port": 7892,
      "sniff": true,
      "users": []
    },
    {
      "type": "mixed",
      "listen": "0.0.0.0",
      "listen_port": 7893,
      "sniff": true,
      "users": []
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "Proxy",
      "outbounds": [
        "auto",
        "{all}",
        "direct"
      ],
      "default": "auto"
    },
    {
      "type": "selector",
      "tag": "Scholar",
      "outbounds": [
        "{all}",
        "direct"
      ]
    },
    {
      "type": "selector",
      "tag": "Express",
      "outbounds": [
        "auto",
        "{all}",
        "direct"
      ],
      "default": "auto"
    },
    {
      "type": "selector",
      "tag": "Netflix",
      "outbounds": [
        "auto",
        "{all}",
        "direct"
      ],
      "default": "auto"
    },
    {
      "type": "selector",
      "tag": "Manually",
      "outbounds": [
        "{all}",
        "direct"
      ]
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
        "{all}"
      ],
      "url": "https://www.gstatic.com/generate_204",
      "interval": "3m",
      "tolerance": 50
    },
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "block",
      "tag": "block"
    },
    {
      "type": "dns",
      "tag": "dns-out"
    }
  ],
  "route": {
    "rules": [
      {
        "protocol": "dns",
        "outbound": "dns-out"
      },
      {
        "geosite": "cn",
        "outbound": "direct"
      },
      {
        "port": [
          25,
          26,
          222,
          465,
          587
        ],
        "outbound": "direct"
      },
      {
        "port": [
          22
        ],
        "outbound": "Manually"
      },
      {
        "domain_suffix": [
          "ifconfig.me"
        ],
        "outbound": "Manually"
      },
      {
        "domain_suffix": [
          ".cn",
          ".bilibili.com",
          ".qq.com",
          ".taobao.com",
          ".jd.com",
          ".baidu.com",
          ".163.com"
        ],
        "outbound": "direct"
      },
      {
        "domain_suffix": [
          "openai.com"
        ],
        "outbound": "Scholar"
      },
      {
        "geosite": [
          "google-scholar",
          "category-scholar-!cn"
        ],
        "outbound": "Scholar"
      },
      {
        "geosite": "netflix",
        "outbound": "Netflix"
      },
      {
        "geosite": [
          "youtube",
          "category-porn",
          "category-cryptocurrency",
          "category-entertainment"
        ],
        "outbound": "Express"
      },
      {
        "domain_keyword": [
          "cdn",
          "download"
        ],
        "outbound": "Express"
      },
      {
        "domain_suffix": [
          "ip.sb"
        ],
        "outbound": "Express"
      },
      {
        "geoip": [
          "private",
          "cn"
        ],
        "outbound": "direct"
      }
    ],
    "auto_detect_interface": true
  }
}
SMALLFLOWERCAT1995
}
# 使用自定义配置文件
#custom_config
# 使用命令替换配置文件添加端口 http: 7891 socks: 7892 mixed: 7893 controller: 7894
perl -i -pe 'BEGIN{undef $/;} s/,\n    {\n      "type": "mixed",\n      "listen": "127.0.0.1",\n      "listen_port": 2080,\n      "sniff": true,\n      "users": \[\]\n    }/,\n    {\n      "type": "http",\n      "listen": "0.0.0.0",\n      "listen_port": 7891,\n      "sniff": true,\n      "users": \[\]\n    },\n    {\n      "type": "socks",\n      "listen": "0.0.0.0",\n      "listen_port": 7892,\n      "sniff": true,\n      "users": \[\]\n    },\n    {\n      "type": "mixed",\n      "listen": "0.0.0.0",\n      "listen_port": 7893,\n      "sniff": true,\n      "users": \[\]\n    }/smg' ${SOURCE_PATH}/sing-box-subscribe.bak/config_template/config_template_groups_rule_set_tun.json
sed -i 's;127.0.0.1;0.0.0.0;g;s;0.0.0.0:9090;:7894;g;s;"strict_route": true;"strict_route": false;g;s;_port": 2080;_port": 7891;g' ${SOURCE_PATH}/sing-box-subscribe.bak/config_template/config_template_groups_rule_set_tun.json

# 写入订阅解析配置
cat << SMALLFLOWERCAT1995 > ${SOURCE_PATH}/sing-box-subscribe.bak/providers.json
{
    "subscribes":[
        {
            "url": "URL",
            "tag": "tag_1",
            "enabled": false,
            "emoji": 1,
            "subgroup": "",
            "prefix": "",
            "User-Agent":"v2rayng"
        },
        {
            "url": "URL",
            "tag": "tag_2",
            "enabled": false,
            "emoji": 0,
            "subgroup": "命名/named",
            "prefix": "❤️",
            "User-Agent":"clashmeta"
        },
        {
            "url": "http://127.0.0.1:8000/Eternity.yaml",
            "tag": "local-docker-amd64-custom-ubuntu-topfreeproxies",
            "enabled": true,
            "emoji": 1,
            "subgroup": "local-docker-amd64-custom-ubuntu-topfreeproxies",
            "prefix": "",
            "User-Agent":"clashmeta"
        },
        {
            "url": "http://127.0.0.1:8000/nekowarp.yaml",
            "tag": "nekowarp",
            "enabled": true,
            "emoji": 1,
            "subgroup": "nekowarp",
            "prefix": "",
            "User-Agent":"clashmeta"
        }
    ],
    "auto_set_outbounds_dns":{
        "proxy": "",
        "direct": ""
    },
    "save_config_path": "${SOURCE_PATH}/singbox-config.json",
    "auto_backup": false,
    "exclude_protocol":"ssr",
    "config_template": "",
    "Only-nodes": false
}
SMALLFLOWERCAT1995

# 执行转换项目程序
echo -e '1\n' | python main.py

# 剔除 topfreeproxies 重复节点名
#perl -i -pe 'BEGIN{undef $/;} s/\n      \]\n    },\n    {\n      "tag": "topfreeproxies",\n      "type": "selector",\n      "outbounds": \[/,/smg' ${SOURCE_PATH}/singbox-config.json
#perl -i -pe 'BEGIN{undef $/;} s/\n        "topfreeproxies",//smg' ${SOURCE_PATH}/singbox-config.json

# sed 替换全部 "max_early_data": xxxxxxx 为 "max_early_data": 3999999999
sed -i 's/"max_early_data":.[^,}]*/"max_early_data": 3999999999/g' "${SOURCE_PATH}/singbox-config.json"

# 自定义替换文件多行内容
replace_string_in_file() {
    # 定义要搜索的字符串
    search_string="$1"

    # 定义要替换的字符串
    replace_string="$2"

    # 定义文件路径
    file_path="$3"

    # 定义执行替换操作的标志默认1
    num="${4:-1}"
    # num 为1则只保留第一个其他部分全部替换
    if [ "$num" -eq 1 ]; then
        # 计算字符串在文件中出现的次数
        count=$(grep -Fo "$search_string" "$file_path" | wc -l)

        # 如果字符串出现两次以上，则只保留第一个其他部分全部替换
        if [ "$count" -gt 1 ]; then
            # 使用perl命令，当第一次匹配到字符串时，将其替换为一个临时字符串
            # 然后将文件中的其他匹配项替换为目标字符串
            # 最后，将临时字符串替换回原始字符串
            perl -0777 -i -pe "s/\Q$search_string\E/++\$n == 1 ? \$& : '$replace_string'/ge" "$file_path"
        fi
    # num 为0则全部替换一个不留
    elif [ "$num" -eq 0 ]; then
          # 使用perl命令进行替换
          perl -0777 -i -pe "s/\Q$search_string\E/$replace_string/g" "$file_path"
    fi
}

# 备份测试修改对比
#cp -fv "${SOURCE_PATH}/singbox-config.json" "${SOURCE_PATH}/singbox-config.json.bak"

# 调用替换多行参数1
search_string='mixed-port: 7893
redir-port: 7895
tproxy-port: 7896'
replace_string=''
file_path="${SOURCE_PATH}/Eternity.yaml"
num=1
replace_string_in_file "$search_string" "$replace_string" "$file_path" "$num"

# 调用替换多行参数1
search_string='"
      ]
    },
    {
      "tag": "topfreeproxies",
      "type": "selector",
      "outbounds": ['
replace_string='",'
file_path="${SOURCE_PATH}/singbox-config.json"
num=1
replace_string_in_file "$search_string" "$replace_string" "$file_path" "$num"

# 调用替换多行参数2
search_string=',
      "endpoint_independent_nat": false,
      "stack": "system",
      "platform": {
        "http_proxy": {
          "enabled": true,
          "server": "0.0.0.0",
          "server_port": 7891
        }
      }'
replace_string=''
file_path="${SOURCE_PATH}/singbox-config.json"
num=0
replace_string_in_file "$search_string" "$replace_string" "$file_path" "$num"

# 删除订阅文件
rm -rfv ${SOURCE_PATH}/nekowarp.yaml
