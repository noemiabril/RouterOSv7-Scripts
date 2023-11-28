# novc/25/2023 10:53:58 by RouterOS 7.12
# software id = XXXX-XXXX
#
# model = RB4011iGS+5HacQ2HnD
# serial number = NA20231125NA
#
/interface bridge
add name=bridge1
add name=bridge2-iptv
/interface ethernet
set [ find default-name=ether1 ] name=ether1-wan
set [ find default-name=ether2 ] name=ether2-iptv-decoder
set [ find default-name=ether3 ] name=ether3-iptv-decoder
/interface vlan
add interface=ether1-wan name=vlan832-internet vlan-id=832
add interface=ether1-wan name=vlan838-iptv vlan-id=838
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/ip pool
add name=dhcp ranges=192.168.10.50-192.168.10.249
add name=iptv-orange ranges=192.168.40.0/30
/ip dhcp-server
add address-pool=dhcp bootp-support=dynamic interface=bridge1 name=dhcpd
add address-pool=iptv-orange allow-dual-stack-queue=no interface=bridge2-iptv \
    name="dhcpd iptv-orange"
/routing bgp template
set default disabled=yes output.network=bgp-networks routing-table=main
/interface bridge port
add bridge=bridge2-iptv fast-leave=yes ingress-filtering=no interface=\
    ether2-iptv-decoder multicast-router=permanent trusted=yes
add bridge=bridge2-iptv ingress-filtering=no interface=vlan838-iptv
add bridge=bridge2-iptv ingress-filtering=no interface=ether3-iptv-decoder
add bridge=bridge1 ingress-filtering=no interface=ether4
add bridge=bridge1 ingress-filtering=no interface=ether5
add bridge=bridge1 ingress-filtering=no interface=ether6
add bridge=bridge1 ingress-filtering=no interface=ether7
add bridge=bridge1 ingress-filtering=no interface=ether8
add bridge=bridge1 ingress-filtering=no interface=ether9
add bridge=bridge1 ingress-filtering=no interface=ether10
add bridge=bridge1 broadcast-flood=no ingress-filtering=no interface=*11 \
    unknown-multicast-flood=no unknown-unicast-flood=no
/interface bridge settings
set use-ip-firewall-for-pppoe=yes use-ip-firewall-for-vlan=yes
/ip neighbor discovery-settings
set discover-interface-list=LAN
/ip settings
set max-neighbor-entries=8192 tcp-syncookies=yes
/interface detect-internet
set detect-interface-list=all
/interface list member
add comment=defconf interface=bridge1 list=LAN
add comment=defconf interface=ether1-wan list=WAN
add interface=bridge2-iptv list=LAN
/ip address
add address=192.168.10.1/24 comment="default configuration" interface=bridge1 \
    network=192.168.10.0
add address=192.168.100.10/24 disabled=yes interface=ether1-wan network=\
    192.168.100.0
add address=10.20.30.40 interface=vlan838-iptv network=10.20.30.40
add address=192.168.40.1/29 interface=ether2-iptv-decoder network=\
    192.168.40.0
add address=192.168.40.1/29 interface=ether3-iptv-decoder network=\
    192.168.40.0
add address=192.168.1.10/24 disabled=yes interface=ether1-wan network=\
    192.168.1.0
/ip cloud
set ddns-enabled=yes ddns-update-interval=1d
/ip dhcp-client
add dhcp-options=authsend,clientid,clientid_duid,hostname,userclass \
    interface=vlan832-internet use-peer-dns=no
/ip dhcp-server lease
add address=192.168.40.2 allow-dual-stack-queue=no client-id=\
    1:xx:xx:xx:xx:xx:xx mac-address=xx:xx:xx:xx:xx:xx server=\
    "dhcpd iptv-orange"
add address=192.168.40.3 allow-dual-stack-queue=no client-id=\
    1:xx:xx:xx:xx:xx:xx mac-address=xx:xx:xx:xx:xx:xx server=\
    "dhcpd iptv-orange"
/ip dhcp-server network
add address=192.168.10.0/24 comment=LAN dns-server=\
    192.168.10.101,192.168.10.202 domain=eonacloud.net gateway=192.168.10.1 \
    netmask=24
add address=192.168.40.2/32 comment="Deco Orange" dns-server=\
    62.37.228.20,62.36.225.150 gateway=192.168.40.1 netmask=29 ntp-server=\
    95.39.224.42,5.56.160.3
add address=192.168.40.3/32 comment="Deco Orange" dns-server=\
    62.37.228.20,62.36.225.150 gateway=192.168.40.1 netmask=29 ntp-server=\
    95.39.224.42,5.56.160.3
/ip dns
set servers=192.168.10.101
/ip firewall filter
add chain=input comment="default configuration" protocol=icmp
add chain=input comment="default configuration" connection-state=established
add action=drop chain=input comment="default configuration" in-interface=\
    vlan832-internet
add action=fasttrack-connection chain=forward connection-state=\
    established,related hw-offload=yes
add chain=forward comment="default configuration" connection-state=\
    established
add action=drop chain=forward comment="default configuration" \
    connection-state=invalid
add action=accept chain=input comment="IGMP  for IPTV" protocol=igmp
add action=accept chain=forward comment="UDP for IPTV" protocol=udp
add action=accept chain=input comment="UDP for IPTV" protocol=udp
add action=accept chain=input comment=Test disabled=yes dst-port=1234,1236 \
    in-interface=vlan838-iptv protocol=udp src-address=92.58.250.0/24 \
    src-port=1234
/ip firewall mangle
add action=set-priority chain=postrouting new-priority=1 out-interface=\
    vlan832-internet passthrough=yes
/ip firewall nat
add action=masquerade chain=srcnat comment="default configuration" \
    out-interface=vlan832-internet
add action=masquerade chain=srcnat comment="default configuration" \
    out-interface=ether1-wan
/ip route
add disabled=no distance=255 dst-address=0.0.0.0/0 gateway=255.255.255.255
/routing igmp-proxy
set quick-leave=yes
/routing igmp-proxy interface
add alternative-subnets=192.168.40.0/30 interface=bridge2-iptv
add alternative-subnets=192.168.40.0/30 interface=vlan838-iptv
add alternative-subnets=192.168.40.0/30 interface=vlan832-internet upstream=\
    yes
/routing igmp-proxy mfc
add disabled=yes group=232.48.190.2 source=95.58.250.160 upstream-interface=\
    vlan838-iptv
add disabled=yes group=239.255.255.251 source=192.168.40.2 \
    upstream-interface=vlan838-iptv
/system clock
set time-zone-name=Europe/Madrid
/system identity
set name="MikrotTik RB4011iGS+5HacQ2HnD-IN"
/system ntp client
set enabled=yes
/system ntp client servers
add address=130.206.3.166
add address=130.206.0.1
/system resource irq rps
set sfp-sfpplus1 disabled=no
/tool graphing interface
add
/tool graphing queue
add
/tool graphing resource
add
