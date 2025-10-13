##A. Update DNS Zone di TIRION (ns1)
bash
nano /etc/bind/zones/db.k02.com

#Tambahkan di bagian bawah sebelum penutup:
bind
; TXT Record - The Enemy
melkor          IN      TXT     "Morgoth (Melkor)"


; CNAME - Alias for The Enemy
morgoth         IN      CNAME   melkor.k02.com.

#Jangan lupa naikkan serial dari 5 ke 6!
bash

# Validasi dan restart
named-checkzone k02.com /etc/bind/zones/db.k02.com
named-checkconf
service bind9 restart

##B. Sinkronisasi ke VALMAR (ns2)
bash
rndc retransfer k02.com
service bind9 restart

##C. Verifikasi dari Client
bash
# Test TXT melkor
dig melkor.k02.com TXT +short

# Test CNAME morgoth
dig morgoth.k02.com +short

# Test TXT via CNAME
dig morgoth.k02.com TXT +short

# Verifikasi detail
dig morgoth.k02.com TXT