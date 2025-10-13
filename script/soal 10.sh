##Tirion
nano /etc/bind/zones/db.k02.com, tambahkan:
app    IN    A    192.168.3.14
named-checkzone k02.com /etc/bind/zones/db.k02.com
service bind9 restart

#Uji dari client (Valmar/Earendil):
dig app.k02.com @192.168.3.11

#Vingilot
apt update
apt install apache2 php8.4-fpm libapache2-mod-fcgid -y
a2enmod proxy_fcgi setenvif
a2enconf php8.4-fpm
mkdir -p /var/www/app.k02.com
echo "<?php echo '<h2>Selamat datang di Vingilot</h2>'; ?>" > /var/www/app.k02.com/index.php
echo "<?php echo '<h2>Tentang Vingilot</h2>'; ?>" > /var/www/app.k02.com/about.php
nano /etc/apache2/sites-available/app.k02.com.conf                                        # VirtualHost untuk app.k02.com
<VirtualHost *:80>
    ServerAdmin webmaster@k02.com
    ServerName app.k02.com
    DocumentRoot /var/www/app.k02.com

    <Directory /var/www/app.k02.com>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/app_error.log
    CustomLog ${APACHE_LOG_DIR}/app_access.log combined
</VirtualHost>

# Default VirtualHost untuk IP, menolak akses
<VirtualHost *:80>
    ServerAdmin webmaster@k02.com
    DocumentRoot /var/www/empty

    <Directory /var/www/empty>
        Require all denied
    </Directory>
</VirtualHost>
nano /var/www/app.k02.com/.htaccess
RewriteEngine On

# Jika request /about  ^f^r about.php
RewriteRule ^about/?$ about.php [L]

# Stop processing index.php untuk request selain root
RewriteCond %{REQUEST_URI} !^/$
RewriteRule ^index\.php$ - [L]
mkdir -p /var/www/empty
nano /etc/apache2/sites-available/000-empty.conf
<VirtualHost *:80>
    ServerAdmin webmaster@k02.com
    DocumentRoot /var/www/empty

    <Directory /var/www/empty>
        Require all denied
    </Directory>
</VirtualHost>
a2ensite 000-empty.conf
a2dissite 000-default.conf
apache2ctl configtest
apache2ctl restart
a2ensite app.k02.com.conf
apache2ctl restart
service apache2 reload

#Uji di Client (Valmar / Earendil)
curl http://app.k02.com/       # index
curl http://app.k02.com/about   # about via rewrite
curl http://192.168.3.14/       # akses IP harus ditolak