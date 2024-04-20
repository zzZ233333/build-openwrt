#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.15.1/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
#svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn co https://github.com/x-wrt/com.x-wrt/tree/master/luci-app-mentohust package/luci-app-mentohust
svn co https://github.com/x-wrt/com.x-wrt/tree/master/luci-app-natcap  package/luci-app-natcap
svn co https://github.com/x-wrt/com.x-wrt/tree/master/luci-app-natflow-users package/luci-app-natflow-users
svn co https://github.com/x-wrt/com.x-wrt/tree/master/mentohust package/mentohust
svn co https://github.com/x-wrt/com.x-wrt/tree/master/natcap package/natcap
svn co https://github.com/x-wrt/com.x-wrt/tree/master/natflow package/natflow
svn co https://github.com/x-wrt/com.x-wrt/tree/master/luci-app-autoreboot package/luci-app-utoreboot
svn co https://github.com/x-wrt/com.x-wrt/tree/master/net/mwan3plus package/mwan3plus
svn co https://github.com/x-wrt/com.x-wrt/tree/master/luci-app-xwan package/luci-app-xwan
svn co https://github.com/x-wrt/luci/tree/master/applications/luci-app-ddns package/luci-app-ddns
svn co https://github.com/x-wrt/luci/tree/master/applications/luci-app-qos package/luci-app-qos
svn co https://github.com/x-wrt/luci/tree/master/applications/luci-app-opkg package/luci-app-opkg
svn co https://github.com/x-wrt/luci/tree/master/applications/luci-app-upnp package/luci-app-upnp
svn co https://github.com/x-wrt/luci/tree/master/applications/luci-app-nft-qos package/luci-app-app-nft-qos

# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

