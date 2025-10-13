##EONWE (Router)
auto lo
iface lo inet loopback

# WAN (DHCP)
auto eth0
iface eth0 inet dhcp

# Jalur Barat
auto eth1
iface eth1 inet static
    address 192.212.1.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Jalur Timur
auto eth2
iface eth2 inet static
    address 192.212.2.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Jalur DMZ
auto eth3
iface eth3 inet static
    address 192.212.3.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Earendil
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.10
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Elwing
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.11
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Cirdan
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.10
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Elrond
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.11
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Maglor
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.12
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Sirion (Reverse Proxy)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.10
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Tirion (ns1)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.11
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Valmar (ns2)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.12
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Lindon (Web statis)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.13
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

##Vingilot (Web dinamis)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.14
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf