##A. Konfigurasi di TIRION (ns1 / Master DNS)
#1. Install BIND9
bash
apt update
apt install -y bind9 dnsutils

#2. Konfigurasi /etc/bind/named.conf.options
bash
nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    
    forwarders {
        192.168.122.1;
    };
    
    allow-transfer { 192.212.3.12; };  // IP Valmar
    
    dnssec-validation auto;
    listen-on-v6 { any; };
};

#3. Konfigurasi /etc/bind/named.conf.local
bash
nano /etc/bind/named.conf.local
zone "k02.com" {
    type master;
    file "/etc/bind/zones/db.k02.com";
    notify yes;
    allow-transfer { 192.212.3.12; };  // IP Valmar
};

#4. Buat direktori zone dan file zona
bash
mkdir -p /etc/bind/zones
nano /etc/bind/zones/db.k02.com
;
; BIND data file for k02.com
;
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.k02.com.
@       IN      NS      ns2.k02.com.


; A Records
@               IN      A       192.212.3.10    ; apex -> Sirion (reverse proxy)
ns1             IN      A       192.212.3.11    ; Tirion
ns2             IN      A       192.212.3.12    ; Valmar
sirion          IN      A       192.212.3.10    ; Sirion
lindon          IN      A       192.212.3.13    ; Lindon (web statis)
vingilot        IN      A       192.212.3.14    ; Vingilot (web dinamis)

#5. Restart BIND9
bash
named-checkzone k02.com /etc/bind/zones/db.k02.com
named-checkconf
service bind9 restart
service bind9 status

##B. Konfigurasi di VALMAR (ns2 / Slave DNS)
#1. Install BIND9
bash
apt update
apt install -y bind9 dnsutils

#2. Konfigurasi /etc/bind/named.conf.options
bash
nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    
    forwarders {
        192.168.122.1;
    };
    
    dnssec-validation auto;
    listen-on-v6 { any; };
};

#3. Konfigurasi /etc/bind/named.conf.local
bash
nano /etc/bind/named.conf.local
zone "k02.com" {
    type slave;
    file "/var/cache/bind/db.k02.com";
    masters { 192.212.3.11; };  // IP Tirion
};

#4. Restart BIND9
bash
service bind9 restart
service bind9 status

##C. Update Resolver di Semua Host Non-Router
#Edit /etc/network/interfaces di Earendil, Elwing, Círdan, Elrond, Maglor, Sirion, Lindon, Vingilot:
auto eth0
iface eth0 inet static
    address 192.212.x.xx
    netmask 255.255.255.0
    gateway 192.212.x.1
    up echo "nameserver 192.212.3.11" > /etc/resolv.conf
    up echo "nameserver 192.212.3.12" >> /etc/resolv.conf
    up echo "nameserver 192.168.122.1" >> /etc/resolv.conf

#Lalu restart network:
bash
service networking restart

##D. Verifikasi
#1. Cek zona transfer di Valmar
bash
ls -la /var/cache/bind/
cat /var/cache/bind/db.k02.com

#2. Test query dari host client (misal Earendil)
bash

# Query apex domain
dig k02.com
nslookup k02.com

# Query subdomain/hostname
dig ns1.k02.com
dig ns2.k02.com
dig sirion.k02.com
dig lindon.k02.com
dig vingilot.k02.com

# Cek server mana yang menjawab
dig k02.com +short
dig @192.212.3.11 k02.com  # langsung ke ns1
dig @192.212.3.12 k02.com  # langsung ke ns2

#3. Test authoritative response
bash
dig k02.com +noall +answer +authority

#4. Test dari Tirion (ns1)
bash
dig @localhost k02.com

#5. Test dari Valmar (ns2)
bash
dig @localhost k02.com