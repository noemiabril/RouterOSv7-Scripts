# jan/02/1970 01:03:58 by RouterOS 7.1
# software id = XXXX-XXXX
#
# model = RB4011iGS+
# serial number = XXXXXXXXXXX
/interface bridge
add name=bridge2-iptv
add name=bridge1
/interface ethernet
set [ find default-name=ether1 ] name=ether1-wan
set [ find default-name=ether2 ] name=ether2-iptv-decoder
set [ find default-name=ether3 ] name=ether3-local
set [ find default-name=ether4 ] name=ether4-local
set [ find default-name=ether5 ] name=ether5-local
set [ find default-name=ether6 ] name=ether6-local
set [ find default-name=ether7 ] name=ether7-local
set [ find default-name=ether8 ] name=ether8-local
set [ find default-name=ether9 ] name=ether9-local
set [ find default-name=ether10 ] name=ether10-local
/interface vlan
add interface=ether1-wan name=vlan832-internet vlan-id=832
add interface=ether1-wan name=vlan838-iptv vlan-id=838
/interface lte apn
set [ find default=yes ] ip-type=ipv4
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp ranges=192.168.1.201-192.168.1.249
add name=iptv-orange ranges=192.168.40.0/30
/ip dhcp-server
add address-pool=dhcp bootp-support=dynamic interface=bridge1 name=\
    dhcp
add address-pool=iptv-orange allow-dual-stack-queue=no interface=bridge2-iptv \
    name="iptv-orange"
/port
set 0 name=serial0
set 1 name=serial1
/routing bgp template
set default as=65530 disabled=no name=default output.network=bgp-networks
/interface bridge port
add bridge=bridge2-iptv ingress-filtering=no interface=ether2-iptv-decoder
add bridge=bridge2-iptv ingress-filtering=no interface=vlan838-iptv
add bridge=bridge1 ingress-filtering=no interface=ether3-local
add bridge=bridge1 ingress-filtering=no interface=ether4-local
add bridge=bridge1 ingress-filtering=no interface=ether5-local
add bridge=bridge1 ingress-filtering=no interface=ether6-local
add bridge=bridge1 ingress-filtering=no interface=ether7-local
add bridge=bridge1 ingress-filtering=no interface=ether8-local
add bridge=bridge1 ingress-filtering=no interface=ether9-local
add bridge=bridge1 ingress-filtering=no interface=ether10-local
/interface bridge settings
set use-ip-firewall-for-pppoe=yes use-ip-firewall-for-vlan=yes
/ip settings
set max-neighbor-entries=8192 tcp-syncookies=yes
/ipv6 settings
set max-neighbor-entries=8192
/interface detect-internet
set detect-interface-list=all
/ip address
add address=192.168.1.1/24 comment="default configuration" interface=bridge1 \
    network=192.168.1.0
add address=192.168.100.10/24 interface=ether1-wan network=192.168.100.0
add address=10.20.30.40 interface=vlan838-iptv network=10.20.30.40
add address=192.168.40.1/30 interface=ether2-iptv-decoder network=192.168.40.0
/ip dhcp-client
add interface=vlan832-internet use-peer-dns=no use-peer-ntp=no
/ip dhcp-server lease
add address=192.168.40.2 allow-dual-stack-queue=no client-id=\
    1:xx:xx:xx:xx:xx:xx mac-address=xx:xx:xx:xx:xx:xx server="iptv-orange"
/ip dhcp-server network
add address=192.168.1.0/24 dns-server=62.36.225.150,62.37.228.20 gateway=\
    192.168.1.1 netmask=24
add address=192.168.1.200/30 dns-server=62.36.225.150,62.37.228.20 gateway=\
    192.168.1.1 netmask=24
add address=192.168.40.2/32 comment="Deco Orange" dns-server=\
    62.37.228.20,62.36.225.150 gateway=192.168.40.1 netmask=30 ntp-server=\
    95.39.224.42,5.56.160.3
/ip dns
set servers=62.36.225.150,62.37.228.204
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
/ip upnp interfaces
add interface=bridge1 type=internal
/routing igmp-proxy interface
add alternative-subnets=192.168.40.0/30 interface=bridge2-iptv
add alternative-subnets=192.168.40.0/30 interface=vlan832-internet \
    upstream=yes
/routing ospf interface-template
add disabled=yes
/system clock
set time-zone-name=Europe/Madrid
/system resource irq rps
set sfp-sfpplus1 disabled=no
