##A. Set Hostname dan Update /etc/hosts di semua node 
#EONWE (Router)
bash
echo "eonwe" > /etc/hostname
hostname eonwe
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.1.1 eonwe.k02.com eonwe" >> /etc/hosts

#EARENDIL
bash
echo "earendil" > /etc/hostname
hostname earendil
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.1.10 earendil.k02.com earendil" >> /etc/hosts

#ELWING
bash
echo "elwing" > /etc/hostname
hostname elwing
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.1.11 elwing.k02.com elwing" >> /etc/hosts

#CIRDAN
bash
echo "cirdan" > /etc/hostname
hostname cirdan
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.2.10 cirdan.k02.com cirdan" >> /etc/hosts

#ELROND
bash
echo "elrond" > /etc/hostname
hostname elrond
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.2.11 elrond.k02.com elrond" >> /etc/hosts

#MAGLOR
bash
echo "maglor" > /etc/hostname
hostname maglor
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.2.12 maglor.k02.com maglor" >> /etc/hosts

#SIRION (Reverse Proxy)
bash
echo "sirion" > /etc/hostname
hostname sirion
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.3.10 sirion.k02.com sirion" >> /etc/hosts

#TIRION (ns1) - Pengecualian
bash
echo "tirion" > /etc/hostname
hostname tirion
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.3.11 tirion.k02.com tirion" >> /etc/hosts
echo "192.212.3.11 ns1.k02.com ns1" >> /etc/hosts

#VALMAR (ns2) - Pengecualian
bash
echo "valmar" > /etc/hostname
hostname valmar
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.3.12 valmar.k02.com valmar" >> /etc/hosts
echo "192.212.3.12 ns2.k02.com ns2" >> /etc/hosts

#LINDON (Web Statis)
bash
echo "lindon" > /etc/hostname
hostname lindon
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.3.13 lindon.k02.com lindon" >> /etc/hosts

#VINGILOT (Web Dinamis)
bash
echo "vingilot" > /etc/hostname
hostname vingilot
echo "127.0.0.1 localhost" > /etc/hosts
echo "192.212.3.14 vingilot.k02.com vingilot" >> /etc/hosts

##B. Update DNS Zone di TIRION (ns1)
#Edit file zona /etc/bind/zones/db.k02.com:
bash
nano /etc/bind/zones/db.k02.com
;
; BIND data file for k02.com
;
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                              3         ; Serial (increment!)
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.k02.com.
@       IN      NS      ns2.k02.com.


; A Records - Infrastructure
@               IN      A       192.212.3.10    ; apex -> Sirion
ns1             IN      A       192.212.3.11    ; Tirion (ns1)
ns2             IN      A       192.212.3.12    ; Valmar (ns2)


; A Records - All Nodes
eonwe           IN      A       192.212.1.1     ; Router
earendil        IN      A       192.212.1.10
elwing          IN      A       192.212.1.11
cirdan          IN      A       192.212.2.10
elrond          IN      A       192.212.2.11
maglor          IN      A       192.212.2.12
sirion          IN      A       192.212.3.10    ; Reverse Proxy
tirion          IN      A       192.212.3.11    ; ns1 (tetap ada record tirion)
valmar          IN      A       192.212.3.12    ; ns2 (tetap ada record valmar)
lindon          IN      A       192.212.3.13    ; Web Statis
vingilot        IN      A       192.212.3.14    ; Web Dinamis
Restart BIND9 di Tirion:
bash
named-checkzone k02.com /etc/bind/zones/db.k02.com
service bind9 restart

##C. Restart BIND9 di VALMAR (ns2)
Agar zone transfer menarik perubahan terbaru:
bash
service bind9 restart
Atau paksa zone transfer:
bash
rndc retransfer k02.com

##D. Verifikasi System-wide Hostname
Jalankan di setiap node:
bash

# 1. Cek hostname
hostname
hostname -f  # Fully Qualified Domain Name

# 2. Cek /etc/hostname
cat /etc/hostname

# 3. Cek /etc/hosts
cat /etc/hosts

# 4. Test resolusi lokal
ping $(hostname) -c 2

##E. Verifikasi DNS Records
Jalankan dari host client (misal Earendil, Círdan):
bash

# Test semua hostname via DNS
dig eonwe.k02.com +short
dig earendil.k02.com +short
dig elwing.k02.com +short
dig cirdan.k02.com +short
dig elrond.k02.com +short
dig maglor.k02.com +short
dig sirion.k02.com +short
dig tirion.k02.com +short
dig valmar.k02.com +short
dig lindon.k02.com +short
dig vingilot.k02.com +short

# Test ns1 dan ns2 (pengecualian)
dig ns1.k02.com +short
dig ns2.k02.com +short

# Ping test via hostname
ping eonwe.k02.com -c 2
ping earendil.k02.com -c 2
ping cirdan.k02.com -c 2
ping lindon.k02.com -c 2
ping ns1.k02.com -c 2

##F. Test Komunikasi Antar Node Menggunakan Hostname
bash
# Dari Earendil
ping elwing.k02.com -c 2
ping cirdan.k02.com -c 2
ping lindon.k02.com -c 2

# Dari Círdan
ping earendil.k02.com -c 2
ping sirion.k02.com -c 2
ping vingilot.k02.com -c 2

# Dari Sirion
ping ns1.k02.com -c 2
ping ns2.k02.com -c 2
ping lindon.k02.com -c 2