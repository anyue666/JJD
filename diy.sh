#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy.sh
# Description: OpenWrt DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# ACRH17 KERNEL 5.4
#============================================================

sed -i 's/KERNEL_PATCHVER:=4.19/KERNEL_PATCHVER:=5.4/g' target/linux/ipq40xx/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Modify hostname
sed -i 's/OpenWrt/R619ac/g' package/base-files/files/bin/config_generate

# Modify the version number
sed -i 's/OpenWrt/Ctxer build $(date "+%Y.%m.%d") @ OpenWrt/g' package/lean/default-settings/files/zzz-default-settings

#修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# 更改时区
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# 更改主题
sed -i 's/luci-theme-bootstrap/luci-theme-opentomcat/g' feeds/luci/collections/luci/Makefile
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/lean/luci-theme-opentomcat

# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="Ctxer"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Ctxer"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config


# add packages
# git clone https://github.com/xiaorouji/openwrt-package/lienol/ package/lienol
git clone https://github.com/kenzok8/openwrt-packages.git package/diy
git clone https://github.com/kenzok8/small.git package/small
