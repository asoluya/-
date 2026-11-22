
#!/bin/bash
set -e
#
# nss
# 第三方插件源码
#

echo "DIY1 - 下载第三方插件"

mkdir -p package/myapp
cd package/myapp

# V2Ray GeoData
#git clone --depth 1 \
#https://github.com/sbwml/v2ray-geodata.git \
#v2ray-geodata

# NATMap 后端
git clone -b master --depth 1 \
https://github.com/muink/openwrt-natmapt.git \
natmapt

# STUNTMAN 客户端
git clone -b master --depth 1 \
https://github.com/muink/openwrt-stuntman.git \
stuntman

# NATMap LuCI
git clone -b master --depth 1 \
https://github.com/muink/luci-app-natmapt.git \
luci-app-natmapt

# Lucky
#git clone -b main --depth 1 \
#https://github.com/gdy666/luci-app-lucky.git \
#lucky

# TimeControl
#git clone -b main --depth 1 \
#https://github.com/sirpdboy/luci-app-timecontrol.git \
#timecontrol

# Momo
#git clone -b main --depth 1 \
#https://github.com/nikkinikki-org/OpenWrt-momo.git \
#momo

# Aurora
#git clone -b master --depth 1 \
#https://github.com/eamonxg/luci-theme-aurora.git \
#aurora

# HelloWorld
#git clone -b master --depth 1 \
#https://github.com/fw876/helloworld.git \
#helloworld

# PassWall2
#git clone -b main --depth 1 \
#https://github.com/Openwrt-Passwall/openwrt-passwall2.git \
#passwall2

###############################################################################
# VIKINGYFY UPnP
# 替换源码自带的 luci-app-upnp 和 miniupnpd
# 不添加 VIKINGYFY feed，直接使用 package/myapp 独立源码
###############################################################################

echo
echo "========================================"
echo "下载 VIKINGYFY UPnP"
echo "========================================"

# 下载 VIKINGYFY packages
git clone -b main --depth 1 \
https://github.com/VIKINGYFY/packages.git \
vikingyfy-packages

# 检查源码目录
if [ ! -f vikingyfy-packages/luci-app-upnp/Makefile ]; then
    echo "ERROR: VIKINGYFY luci-app-upnp Makefile 不存在"
    exit 1
fi

if [ ! -f vikingyfy-packages/miniupnpd/Makefile ]; then
    echo "ERROR: VIKINGYFY miniupnpd Makefile 不存在"
    exit 1
fi

# 复制两个完整软件包到 package/myapp
cp -a vikingyfy-packages/luci-app-upnp \
    ./luci-app-upnp

cp -a vikingyfy-packages/miniupnpd \
    ./miniupnpd

# 删除临时仓库，避免重复扫描
rm -rf vikingyfy-packages

# 检查两个软件包版本
echo
echo "VIKINGYFY UPnP 版本信息："

grep -E 'PKG_NAME|PKG_VERSION|PKG_RELEASE' \
    ./luci-app-upnp/Makefile \
    ./miniupnpd/Makefile

echo "VIKINGYFY UPnP 下载完成"

cd ../..

echo "添加插件集合源"

# iStore Packages
#echo 'src-git istore https://github.com/linkease/istore-packages.git;main' >> feeds.conf.default

# Kenzok8
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages.git' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small.git' >> feeds.conf.default

# dae / daed / luci-app-daede 专用源（kenzok8/openwrt-daede）
echo 'src-git daede https://github.com/kenzok8/openwrt-daede.git' >> feeds.conf.default
# echo 'src-git small_package https://github.com/kenzok8/small-package.git' >> feeds.conf.default

# Kiddin9
#echo 'src-git kiddin9 https://github.com/kiddin9/op-packages.git' >> feeds.conf.default

# VIKINGYFY
# echo 'src-git vikingyfy https://github.com/VIKINGYFY/packages.git' >> feeds.conf.default

# Modem
# echo 'src-git modem https://github.com/FUjr/modem_feeds.git' >> feeds.conf.default

echo "package/myapp:"
find package/myapp \
    -maxdepth 1 \
    -mindepth 1 \
    -type d \
    -printf '%f\n' | sort

echo "DIY1 OK"
