##A. Konfigurasi di VINGILOT
#1. Update Nginx Config
bash
nano /etc/nginx/sites-available/app.k02.com
nginx
server {
    listen 80;
    server_name app.k02.com;
    root /var/www/app.k02.com;
    index index.php;
    
    # Set real IP dari Sirion
    set_real_ip_from 192.212.3.10;
    real_ip_header X-Real-IP;
    real_ip_recursive on;
    
    access_log /var/log/nginx/app.k02.com.access.log;
    error_log /var/log/nginx/app.k02.com.error.log;
    
    location / {
        try_files $uri $uri/ $uri.php =404;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
    }
}


server {
    listen 80 default_server;
    server_name _;
    return 444;
}

#2. Sesuaikan PHP Version
bash
PHP_VER=$(php -v | head -n1 | awk '{print $2}' | cut -d'.' -f1,2)
sed -i "s/php8.2/php${PHP_VER}/g" /etc/nginx/sites-available/app.k02.com

#3. Restart Nginx
bash
nginx -t
service nginx restart

##B. Update PHP untuk Menampilkan Real IP
#1. Update index.php
bash
cat > /var/www/app.k02.com/index.php << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Vingilot</title></head>
<body>
    <h1>Vingilot - Web Dinamis</h1>
    <nav>
        <a href="/">Home</a> | <a href="/about">About</a>
    </nav>
    <h2>Server Info:</h2>
    <p>Hostname: <?php echo gethostname(); ?></p>
    <p>PHP Version: <?php echo phpversion(); ?></p>
    <p>Time: <?php echo date('Y-m-d H:i:s'); ?></p>
    
    <h2>Client IP Info:</h2>
    <p>REMOTE_ADDR: <?php echo $_SERVER['REMOTE_ADDR']; ?></p>
    <p>X-Real-IP: <?php echo isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : 'N/A'; ?></p>
</body>
</html>
EOF

#2. Update about.php
bash
cat > /var/www/app.k02.com/about.php << 'EOF'
<!DOCTYPE html>
<html>
<head><title>About Vingilot</title></head>
<body>
    <h1>About Vingilot</h1>
    <nav>
        <a href="/">Home</a> | <a href="/about">About</a>
    </nav>
    <h2>Server Info:</h2>
    <p>Server Name: <?php echo $_SERVER['SERVER_NAME']; ?></p>
    <p>Server IP: <?php echo $_SERVER['SERVER_ADDR']; ?></p>
    
    <h2>Client IP (Real):</h2>
    <p>REMOTE_ADDR: <?php echo $_SERVER['REMOTE_ADDR']; ?></p>
    <p>X-Real-IP: <?php echo isset($_SERVER['HTTP_X_REAL_IP']) ? $_SERVER['HTTP_X_REAL_IP'] : 'N/A'; ?></p>
</body>
</html>
EOF

##C. Verifikasi
#1. Test dari EARENDIL (192.212.1.10)
bash
# Akses via proxy
curl http://www.k02.com/app/

# Di Vingilot cek log:
tail -5 /var/log/nginx/app.k02.com.access.log
Expected: Log menampilkan 192.212.1.10 (bukan 192.212.3.10)

#2. Test dari CÍRDAN (192.212.2.10)
bash
curl http://www.k02.com/app/about

# Di Vingilot cek log:
tail -5 /var/log/nginx/app.k02.com.access.log
Expected: Log menampilkan 192.212.2.10

#3. Check di Vingilot
bash
# Lihat recent access log
tail -10 /var/log/nginx/app.k02.com.access.log

# Summary IP addresses
awk '{print $1}' /var/log/nginx/app.k02.com.access.log | sort | uniq -c