##A. Update DNS Zone di TIRION (ns1)
#Edit file zona /etc/bind/zones/db.k02.com:
bash
nano /etc/bind/zones/db.k02.com
;
; BIND data file for k02.com
;
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                              4         ; Serial (increment dari 3 ke 4!)
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
sirion          IN      A       192.212.3.10    ; Reverse Proxy / Gerbang
tirion          IN      A       192.212.3.11    ; ns1
valmar          IN      A       192.212.3.12    ; ns2
lindon          IN      A       192.212.3.13    ; Web Statis
vingilot        IN      A       192.212.3.14    ; Web Dinamis


; CNAME Records - Service Aliases
www             IN      CNAME   sirion.k02.com.     ; www -> Sirion (gerbang)
static          IN      CNAME   lindon.k02.com.     ; static -> Lindon (web statis)
app             IN      CNAME   vingilot.k02.com.   ; app -> Vingilot (web dinamis)
Restart BIND9 di Tirion:
bash
named-checkzone k02.com /etc/bind/zones/db.k02.com
service bind9 restart
service bind9 status

##B. Sinkronisasi Zone Transfer di VALMAR (ns2)
bash
# Paksa zone transfer untuk ambil perubahan terbaru
rndc retransfer k02.com

# Atau restart BIND9
service bind9 restart

# Verifikasi file zona sudah update
cat /var/cache/bind/db.k02.com | grep CNAME