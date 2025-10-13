###Uji Routing Internal via Eonwe (Router)
##Uji dari Subnet 1 (Earendil / Elwing):
bash
ping 192.212.2.10 -c 4    # ke Cirdan
ping 192.212.2.11 -c 4    # ke Elrond
ping 192.212.3.10 -c 4    # ke Sirion
ping 192.212.3.14 -c 4    # ke Vingilot

##Uji dari Subnet 2 (Cirdan / Elrond / Maglor):
bash
ping 192.212.1.10 -c 4    # ke Earendil
ping 192.212.1.11 -c 4    # ke Elwing
ping 192.212.3.11 -c 4    # ke Tirion
ping 192.212.3.12 -c 4    # ke Valmar

##Uji dari Subnet 3 (Sirion / Tirion / Valmar / Lindon / Vingilot):
bash
ping 192.212.1.10 -c 4    # ke Earendil
ping 192.212.2.10 -c 4    # ke Cirdan

##Uji Resolver Otomatis (DNS)
bash
ping google.com -c 4

##Uji dari Sisi Router (Eonwe)
bash

##Lihat status IP forwarding
sysctl net.ipv4.ip_forward

##Cek apakah MASQUERADE NAT sudah aktif
iptables -t nat -L -n -v | grep MASQUERADE

##Cek aturan forwarding antar interface
iptables -L FORWARD -n -v

##Lihat routing table router
ip route