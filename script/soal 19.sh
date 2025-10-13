##A. Update DNS Zone di TIRION (ns1)
bash
nano /etc/bind/zones/db.k02.com

#Tambahkan CNAME havens:
bind
; CNAME Records
www             IN      CNAME   sirion.k02.com.
static          30 IN   CNAME   lindon.k02.com.
app             IN      CNAME   vingilot.k02.com.
havens          IN      CNAME   www.k02.com.        ; BARU!

#Naikkan serial dari 6 ke 7!
bash
named-checkzone k02.com /etc/bind/zones/db.k02.com
named-checkconf
service bind9 restart

##B. Sinkronisasi ke VALMAR (ns2)
bash
rndc retransfer k02.com
service bind9 restart

##C. Update Nginx di SIRION
bash
nano /etc/nginx/sites-available/sirion-proxy

#Tambahkan havens.k02.com ke server_name:
nginx
server {
    listen 80;
    server_name www.k02.com havens.k02.com;
    
    # ... sisa config sama ...
}
bash
nginx -t
service nginx restart

##D. Verifikasi dari EARENDIL
bash
# Test DNS
dig havens.k02.com +short
dig havens.k02.com

# Test akses
curl -I http://havens.k02.com/
curl http://havens.k02.com/
curl -I http://havens.k02.com/static/
curl -I http://havens.k02.com/app/

##E. Verifikasi dari CÍRDAN
bash
# Test DNS
dig havens.k02.com +short

# Test akses
curl http://havens.k02.com/
curl http://havens.k02.com/static/
curl http://havens.k02.com/app/
curl -u admin:beleriand123 http://havens.k02.com/admin/