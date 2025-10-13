##A. Konfigurasi di TIRION (ns1 / Master DNS)
#1. Edit /etc/bind/named.conf.local
#Tambahkan reverse zone untuk subnet DMZ (192.212.3.0/24):
bash
nano /etc/bind/named.conf.local
bash
zone "k02.com" {
    type master;
    file "/etc/bind/zones/db.k02.com";
    notify yes;
    allow-transfer { 192.212.3.12; };  // IP Valmar
};

# Reverse Zone untuk DMZ (192.212.3.0/24)
zone "3.212.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.212.3";
    notify yes;
    allow-transfer { 192.212.3.12; };  // IP Valmar
};

#2. Buat File Reverse Zone
bash
nano /etc/bind/zones/db.192.212.3
bash
;
; BIND reverse data file for 192.212.3.0/24 (DMZ Segment)
;
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.k02.com.
@       IN      NS      ns2.k02.com.


; PTR Records - DMZ Hosts
10      IN      PTR     sirion.k02.com.     ; 192.212.3.10
11      IN      PTR     tirion.k02.com.     ; 192.212.3.11 (ns1)
12      IN      PTR     valmar.k02.com.     ; 192.212.3.12 (ns2)
13      IN      PTR     lindon.k02.com.     ; 192.212.3.13
14      IN      PTR     vingilot.k02.com.   ; 192.212.3.14

#3. Validasi dan Restart BIND9
bash
# Cek syntax reverse zone
named-checkzone 3.212.192.in-addr.arpa /etc/bind/zones/db.192.212.3

# Cek konfigurasi BIND
named-checkconf

# Restart BIND9
service bind9 restart
service bind9 status

##B. Konfigurasi di VALMAR (ns2 / Slave DNS)
#1. Edit /etc/bind/named.conf.local
#Tambahkan reverse zone sebagai slave:
bash
nano /etc/bind/named.conf.local
bash
zone "k02.com" {
    type slave;
    file "/var/cache/bind/db.k02.com";
    masters { 192.212.3.11; };  // IP Tirion
};

# Reverse Zone Slave untuk DMZ
zone "3.212.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.212.3";
    masters { 192.212.3.11; };  // IP Tirion
};

#2. Paksa Zone Transfer dan Restart
bash

# Restart BIND9
service bind9 restart