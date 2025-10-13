#Uji di Valmar
dig static.k02.com @192.121.3.11

#Uji di Earendil
dig static.k02.com @192.121.3.11

#Lindon
apt update
apt install apache2 -y
apache2ctl configtest
apache2ctl restart
ps aux | grep apache2
apache2ctl stop
apache2ctl start

#Uji(Lindon)
mkdir -p /var/www/static.k02.com/annals
echo "<h2>Selamat datang di Arsip Lindon</h2>" > /var/www/static.k02.com/index.html
echo "Catatan 1" > /var/www/static.k02.com/annals/catatan1.txt
echo "Catatan 2" > /var/www/static.k02.com/annals/catatan2.txt
nano /etc/apache2/sites-available/static.k02.com.conf
<VirtualHost *:80>
    ServerAdmin webmaster@k02.com
    ServerName static.k02.com
    DocumentRoot /var/www/static.k02.com

    <Directory /var/www/static.k02.com/annals>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/static_error.log
    CustomLog ${APACHE_LOG_DIR}/static_access.log combined
</VirtualHost>
a2ensite static.k02.com.conf
a2enmod autoindex
apache2ctl configtest
apache2ctl restart
service apache2 reload

#Valmar/Earendil
curl http://static.k02.com/          # harus tampil halaman index
curl http://static.k02.com/annals/   # harus tampil daftar file (catatan1.txt, catatan2.txt)
curl http://192.121.3.12/            # harus ditolak 403 Forbidden