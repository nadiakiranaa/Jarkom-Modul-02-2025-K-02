##EONWE (Router)
/root/.bashrc
apt update
apt install -y procps iptables
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth3 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT

# 1. Pastikan IP forwarding aktif
cat /proc/sys/net/ipv4/ip_forward

# 2. Lihat aturan NAT (pastikan ada MASQUERADE)
iptables -t nat -L POSTROUTING -n -v

# 3. Lihat aturan FORWARD (pastikan ada ACCEPT antar interface)
iptables -L FORWARD -n -v

# 4. Uji koneksi dari host internal (misal dari salah satu client)
ping 8.8.8.8

# 5. Jika berhasil ping, berarti NAT & forwarding di EONWE berfungsi dengan benar