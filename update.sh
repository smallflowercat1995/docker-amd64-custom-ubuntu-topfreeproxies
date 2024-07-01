echo $(pwd)

# 下载 Country.mmdb
rm -fv topfreeproxies/utils/Country.mmdb
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/Loyalsoldier/geoip/releases/latest/download/Country.mmdb" -O"topfreeproxies/utils/Country.mmdb"

# 下载 subconverter
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "https://github.com/tindy2013/subconverter/releases/latest/download/subconverter_linux64.tar.gz" -O"topfreeproxies/utils/subconverter/subconverter_linux64.tar.gz"
TEMP=$(mktemp -d)
# 解压文件到临时目录
tar vxzf "topfreeproxies/utils/subconverter/subconverter_linux64.tar.gz" -C $TEMP/
#  将 subconverter/subconverter 文件移动到当前目录
mv -fv $TEMP/subconverter/subconverter "topfreeproxies/utils/subconverter/"
# 删除
rm -rfv "topfreeproxies/utils/subconverter/subconverter_linux64.tar.gz" $TEMP

# 下载 lite
OS_TYPE=$(echo $(uname -s) | tr A-Z a-z)
ARCH_TYPE_MINIFORGE=$(uname -m)
# 获取架构 lite x86_64 -> amd64
ARCH_TYPE_LITE=$(if [ "$ARCH_TYPE_MINIFORGE" = "x86_64" ];then echo "amd64";else echo $ARCH_TYPE_MINIFORGE;fi)
# github 项目 xxf098/LiteSpeedTest
URI="xxf098/LiteSpeedTest"
# 从 xxf098/LiteSpeedTest github中提取全部 tag 版本，获取最新版本赋值给 VERSION 后打印
VERSION=$(curl -sL "https://github.com/$URI/releases" | grep -oP '(?<=\/releases\/tag\/)[^"]+' | head -n 2 | tail -n 1)
echo $VERSION
# 拼接下载链接 URI_DOWNLOAD 后打印
URI_DOWNLOAD="https://github.com/$URI/releases/download/$VERSION/lite-$OS_TYPE-$ARCH_TYPE_LITE-$VERSION.gz"
echo $URI_DOWNLOAD
# 获取文件名 FILE_NAME 后打印
FILE_NAME=$(basename $URI_DOWNLOAD)
echo $FILE_NAME
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "${URI_DOWNLOAD}" -O"topfreeproxies/utils/litespeedtest/${FILE_NAME}"
gunzip -v -f "topfreeproxies/utils/litespeedtest/${FILE_NAME}" -c > "topfreeproxies/utils/litespeedtest/lite"
rm -fv "topfreeproxies/utils/litespeedtest/${FILE_NAME}"

# github 项目 MetaCubeX/mihomo
URI="MetaCubeX/mihomo"
# 从 MetaCubeX/mihomo github中提取全部 tag 版本，获取最新版本赋值给 VERSION 后打印
VERSION=$(curl -sL "https://github.com/$URI/releases" | grep -oP '(?<=\/releases\/tag\/)[^"]+' | grep -v Prerelease | head -n 1)
echo $VERSION
# 拼接下载链接 URI_DOWNLOAD 后打印 
URI_DOWNLOAD="https://github.com/$URI/releases/download/$VERSION/mihomo-$OS_TYPE-$ARCH_TYPE_LITE-$VERSION.gz"
echo $URI_DOWNLOAD
# 获取文件名 FILE_NAME 后打印
FILE_NAME=$(basename $URI_DOWNLOAD)
echo $FILE_NAME
wget -t 3 -T 5 --verbose --show-progress=on --progress=bar --no-check-certificate --hsts-file=/tmp/wget-hsts -c "${URI_DOWNLOAD}" -O"topfreeproxies/utils/scripts/${FILE_NAME}"
gunzip -v -f "topfreeproxies/utils/scripts/${FILE_NAME}" -c > "topfreeproxies/utils/scripts/mihomos"
rm -fv "topfreeproxies/utils/scripts/${FILE_NAME}"
