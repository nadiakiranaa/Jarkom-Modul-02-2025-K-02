##A. Persiapan - Catat Alamat Lama
bash
# Dari client (EARENDIL/CÍRDAN)
echo "Alamat LAMA:"
dig lindon.k02.com +short
dig static.k02.com +short
Alamat lama: 192.212.3.13

##B. Update DNS di TIRION (ns1)
#1. Backup Zone File
bash
cp /etc/bind/zones/db.k02.com /etc/bind/zones/db.k02.com.backup

#2. Edit Zone File
bash
nano /etc/bind/zones/db.k02.com
#Update:
#Ubah IP Lindon dari 192.212.3.13 → 192.212.3.99
#Naikkan Serial (misal dari 4 → 5)
#Set TTL 30 detik untuk lindon dan static
bind
;
; BIND data file for k02.com
;
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                              5         ; Serial (naik dari 4!)
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.k02.com.
@       IN      NS      ns2.k02.com.


; A Records - Infrastructure
@               IN      A       192.212.3.10
ns1             IN      A       192.212.3.11
ns2             IN      A       192.212.3.12


; A Records - All Nodes (dengan TTL default)
eonwe           IN      A       192.212.1.1
earendil        IN      A       192.212.1.10
elwing          IN      A       192.212.1.11
cirdan          IN      A       192.212.2.10
elrond          IN      A       192.212.2.11
maglor          IN      A       192.212.2.12
sirion          IN      A       192.212.3.10
tirion          IN      A       192.212.3.11
valmar          IN      A       192.212.3.12
vingilot        IN      A       192.212.3.14


; Record dengan TTL 30 detik
lindon          30 IN   A       192.212.3.99    ; CHANGED! dari .13 ke .99


; CNAME Records (TTL 30 detik)
www             IN      CNAME   sirion.k02.com.
static          30 IN   CNAME   lindon.k02.com.    ; TTL 30s, mengikuti lindon
app             IN      CNAME   vingilot.k02.com.

#3. Validasi dan Restart
bash
named-checkzone k02.com /etc/bind/zones/db.k02.com
named-checkconf
service bind9 restart

##C. Sinkronisasi ke VALMAR (ns2)
Di Valmar
bash
# Paksa zone transfer
rndc retransfer k02.com

# Atau restart
service bind9 restart

# Verifikasi serial
dig @localhost k02.com SOA +short
# Should show serial 5

# Verifikasi record baru
dig @localhost lindon.k02.com +short
# Should show 192.212.3.99

##D. Verifikasi 3 Momen
#Momen 1: SEBELUM Perubahan (Alamat Lama)
#Jalankan dari client SEBELUM update DNS:
bash
echo "=== MOMEN 1: Sebelum Perubahan ==="
date
dig lindon.k02.com +short
dig static.k02.com +short
ping lindon.k02.com -c 2
Expected: 192.212.3.13 (alamat lama)

#Momen 2: SESAAT Setelah Perubahan (Masih Cache)
#Jalankan dari client SEGERA setelah update DNS di Tirion & Valmar:
bash
echo "=== MOMEN 2: Sesaat Setelah Update (Cache Masih Ada) ==="
date

# Query dengan TTL info
dig lindon.k02.com

# Short answer
dig lindon.k02.com +short
dig static.k02.com +short

# Ping test
ping lindon.k02.com -c 2
Expected:
Masih 192.212.3.13 (cache belum expire)
TTL berkurang dari 30 detik

##Momen 3: SETELAH TTL Kedaluwarsa (Alamat Baru)
#Tunggu >30 detik, lalu jalankan:
bash
echo "=== MOMEN 3: Setelah TTL Expire (>30 detik) ==="
date

# Query fresh dari DNS
dig lindon.k02.com +short
dig static.k02.com +short

# Dengan detail
dig lindon.k02.com

# Ping test
ping lindon.k02.com -c 2
Expected: 192.212.3.99 (alamat baru)

##E. Script Monitoring Otomatis
bash
cat > /root/dns_ttl_test.sh << 'EOF'
#!/bin/bash


echo "=========================================="
echo "   DNS TTL Testing - 3 Momen"
echo "=========================================="
echo ""


# Momen 1: Before (jika DNS belum diupdate)
echo "[MOMEN 1] Sebelum Perubahan:"
echo "  Time: $(date '+%H:%M:%S')"
echo "  lindon.k02.com: $(dig lindon.k02.com +short)"
echo "  static.k02.com: $(dig static.k02.com +short)"
echo ""


read -p "Press ENTER after DNS updated at Tirion & Valmar..."


# Momen 2: Just after update (cache still valid)
echo ""
echo "[MOMEN 2] Sesaat Setelah Update (Cache):"
echo "  Time: $(date '+%H:%M:%S')"
RESULT=$(dig lindon.k02.com)
IP=$(echo "$RESULT" | grep -A1 "ANSWER SECTION" | tail -1 | awk '{print $5}')
TTL=$(echo "$RESULT" | grep -A1 "ANSWER SECTION" | tail -1 | awk '{print $2}')
echo "  lindon.k02.com: $IP (TTL: $TTL)"
echo "  static.k02.com: $(dig static.k02.com +short)"
echo ""


echo "Waiting 35 seconds for TTL to expire..."
for i in {35..1}; do
    echo -ne "  $i seconds remaining...\r"
    sleep 1
done
echo ""


# Momen 3: After TTL expired
echo ""
echo "[MOMEN 3] Setelah TTL Expire:"
echo "  Time: $(date '+%H:%M:%S')"
RESULT=$(dig lindon.k02.com)
IP=$(echo "$RESULT" | grep -A1 "ANSWER SECTION" | tail -1 | awk '{print $5}')
TTL=$(echo "$RESULT" | grep -A1 "ANSWER SECTION" | tail -1 | awk '{print $2}')
echo "  lindon.k02.com: $IP (TTL: $TTL - FRESH)"
echo "  static.k02.com: $(dig static.k02.com +short)"
echo ""


echo "=========================================="
echo "Summary:"
echo "  Expected: .13 (old) -> .13 (cached) -> .99 (new)"
echo "=========================================="
EOF


chmod +x /root/dns_ttl_test.sh
Jalankan Script
bash
/root/dns_ttl_test.sh
F. Verifikasi Zone Transfer
bash
# Dari client, cek serial di kedua NS
echo "Serial di ns1 (Tirion):"
dig @192.212.3.11 k02.com SOA +short | awk '{print $3}'


echo "Serial di ns2 (Valmar):"
dig @192.212.3.12 k02.com SOA +short | awk '{print $3}'


# Harus sama = 5

##G. Test CNAME Following
bash
# static.k02.com adalah CNAME ke lindon.k02.com
# Harus mengikuti IP lindon yang baru
dig static.k02.com
# Output akan show:
# static.k02.com. 30 IN CNAME lindon.k02.com.
# lindon.k02.com. 30 IN A 192.212.3.99
