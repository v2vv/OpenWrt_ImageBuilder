#!/bin/bash
#=================================================
# https://github.com/lujimmy/openwrt-imagebuilder 
# Description: DIY script
# Author: lujimmy
# Version:1.0
#=================================================
# Modify default Lan IP
# sed -i 's/192.168.1.1/192.168.0.128/g' package/base-files/files/bin/config_generate
# Modify image size for OFFICAL OpenWrt source code
# sed -i '567c $(Device/tplink-8mlzma)' target/linux/ar71xx/image/tiny-tp-link.mk
# sed -i '238c CONFIG_ATH79_MACH_TL_WR841N_V9=y' target/linux/ar71xx/config-4.14

work_dir=$(pwd)

# Add third-party package

echo "检查 files 文件夹是否存在"
if [ ! -d "files" ]; then
    echo "files 不存在，创建 files 文件夹"
    mkdir files
fi

mkdir -p files/etc/openclash/core/

echo "下载 luci-app-openclash..."
cd packages
wget -q https://github.com/vernesong/OpenClash/releases/download/v0.39.2-beta/luci-app-openclash_0.39.2-beta_all.ipk

cd $work_dir

mkdir openclash_tmp
cd openclash_tmp

echo "下载 clash..."
#/etc/openclash/core/clash
wget -q https://github.com/vernesong/OpenClash/releases/download/v0.39.2-beta/clash-linux-amd64.tar.gz
mkdir clash_tmp
tar -xzvf clash-linux-amd64.tar.gz -C ./clash_tmp
cd ./clash_tmp

if [ ! -f "clash" ]; then
    ls | grep clash | xargs -I {} mv {} clash
fi
chmod +x clash
cp ./* "$work_dir/files/etc/openclash/core/"
cd ..
rm -rf clash_tmp
rm clash-linux-amd64.tar.gz 

echo "下载 clash_tun..."
sudo -E apt-get -qq install gzip
# /etc/openclash/core/clash_tun
wget -q https://github.com/vernesong/OpenClash/releases/download/TUN-Premium/clash-linux-amd64-2020.06.15.gbf68156.gz
mkdir clash_tmp
gunzip -c clash-linux-amd64-2020.06.15.gbf68156.gz > ./clash_tmp/clash_tun
cd ./clash_tmp
if [ ! -f "clash_tun" ]; then
    ls | grep clash | xargs -I {} mv {} clash_tun
fi
chmod +x clash_tun
cp ./* "$work_dir/files/etc/openclash/core/"
cd ..
rm -rf clash_tmp
rm clash-linux-amd64-2020.06.15.gbf68156.gz

echo "下载 clash_game"
# /etc/openclash/core/clash_game
wget -q https://github.com/vernesong/OpenClash/releases/download/TUN/clash-linux-amd64.tar.gz 
mkdir clash_tmp
tar -xzvf clash-linux-amd64.tar.gz -C ./clash_tmp
cd ./clash_tmp
if [ ! -f "clash_game" ]; then
    ls | grep clash | xargs -I {} mv {} clash_game
fi
chmod +x clash_game
cp ./* "$work_dir/files/etc/openclash/core/"
cd ..
rm -rf clash_tmp
rm clash-linux-amd64.tar.gz 

echo "查看下载结果"
ls "$work_dir/etc/openclash/core/"

echo "清理文件"
cd ..
rm -rf openclash_tmp