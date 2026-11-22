# AX3600 LibWrt 固件编译

小米 AX3600 专用 OpenWrt / LibWrt 自动编译项目，只保留 AX3600 一个设备，定位为：基础网络功能 + 满血 Qualcomm NSS + dae / daed。

## 支持设备

- Xiaomi AX3600
- Xiaomi AX3600 Stock

平台：Qualcomm IPQ807x（qualcommax / ipq807x，无 USB）。

## 编译源码

- 源码：[LiBwrt/LibWrt](https://github.com/LiBwrt/LibWrt)
- 分支：`25.12-nss`
- 配置文件：`nss/immortalwrt/ax3600.txt`（同时生成 AX3600 与 AX3600 Stock 两个目标）

## 功能

### 基础网络

- LuCI 管理界面（中文）
- firewall4 防火墙
- dnsmasq-full（DHCP / DHCPv6 / DNSSEC / nftset 等完整功能）
- PPPoE 拨号、IPv6（odhcp6c / odhcpd）
- UPnP（miniupnpd-nftables）
- FullCone NAT（fullconenat-sonic）
- NATMap / STUNTMAN（NAT 打洞）

### 满血 Qualcomm NSS

NSS 驱动功能全部开启，包括：

- 基础：NSS DP、SSDK、ECM、Crypto（含 EIP 固件）、Bridge Manager、VLAN Manager、LAG Manager、Mirror、Match、Netlink、Qdisc / Shaper、IGS
- 隧道与拨号：PPPoE、PPTP、L2TP、GRE（含 GRE Redir）、VXLAN、MAP-T、Tun6RD、TunIPIP6、IPv6、Virt-IF
- 无线：WiFi Offload、WiFi Mesh Manager、ATH11K NSS Support

对应软件包：nss-firmware、nss-eip-firmware、kmod-qca-nss-dp、kmod-qca-ssdk、kmod-qca-nss-ecm、kmod-qca-nss-crypto 及全部 kmod-qca-nss-drv-* 子驱动。

### dae / daed

- 组件：dae + daed + luci-app-daede，两个后端的依赖全部配齐（kmod-sched-core、kmod-sched-bpf、kmod-veth、v2ray-geoip、v2ray-geosite、ca-bundle、curl 等）
- 来源：[kenzok8/openwrt-daede](https://github.com/kenzok8/openwrt-daede)，在 diy-part1 中以 `daede` feed 引入，编译时由工作流锁定 dae / daed / luci-app-daede 只从该 feed 安装
- 内核：已开启 BPF / CGROUP_BPF / BPF Events / XDP Sockets / 内核 BTF（CONFIG_KERNEL_DEBUG_INFO_BTF），BPF 工具链使用主机 clang（CONFIG_BPF_TOOLCHAIN_HOST）

## 编译方法

使用 GitHub Actions 云编译：

1. 打开本仓库 Actions 页面
2. 选择工作流 **AX3600_daed-only-libwrt**
3. 点击 **Run workflow** 开始编译
4. 编译完成后在该次运行的 Release / Artifacts 中下载固件（factory.ubi / sysupgrade.bin，含 Stock 版）

可选参数：`BUILD_CONFIG_ONLY` 设为 true 时仅输出完整配置（.config），不编译固件，适合改配置后先验证。

## 仓库结构

```
.github/workflows/ax3600-daed.yml   AX3600 LibWrt 编译工作流
.github/workflows/clean.yaml        定时清理旧 Release / 工作流记录
nss/immortalwrt/ax3600.txt          AX3600 编译配置（种子 .config）
nss/diy-part1.sh                    DIY 第一阶段：拉取第三方插件源码、添加 feeds（含 daede）
nss/diy-part3.sh                    DIY 第二阶段：第三方依赖与来源优先级处理
```

## 说明

- 无线默认无密码或者 12345678，刷机后请第一时间修改。
- 本项目基于 [googlewmb/qca-all-in-one](https://github.com/googlewmb/qca-all-in-one) 精简而来，只保留 AX3600 + LibWrt 部分。
