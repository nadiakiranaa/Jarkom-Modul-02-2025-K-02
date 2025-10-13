##1. Install Nginx
apt update
apt install -y nginx

##2. Konfigurasi Reverse Proxy
rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/sites-available/sirion-proxy << 'EOF'
upstream backend_static { server 192.212.3.13:80; }
upstream backend_app    { server 192.212.3.14:80; }

server {
    listen 80;
    server_name www.k02.com sirion.k02.com;
    access_log /var/log/nginx/sirion-proxy.access.log;
    error_log  /var/log/nginx/sirion-proxy.error.log;

    location / {
        root /var/www/sirion;
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /static/ {
        proxy_pass http://backend_static/;
        proxy_set_header Host static.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/static/(.*) /$1 break;
    }

    location /app/ {
        proxy_pass http://backend_app/;
        proxy_set_header Host app.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/app/(.*) /$1 break;
    }
}

server {
    listen 80 default_server;
    server_name _;
    return 444;
}
EOF

##3. Buat Landing Page
mkdir -p /var/www/sirion

cat > /var/www/sirion/index.html << 'EOF'
<!DOCTYPE html><html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Sirion - Gateway to Beleriand</title>
<style>/* CSS ringkas sesuai original */</style>
</head><body>
<div class="container">
<h1>⚔️ Sirion Gateway</h1>
<p class="subtitle">Muara Sungai Menuju Beleriand</p>
<p>Reverse Proxy - Path-Based Routing</p>
<div class="services">
<a href="/static/" class="service-card"><div class="icon">📚</div><h2>Static</h2><p>Lindon Archives</p><small>/static/</small></a>
<a href="/app/" class="service-card"><div class="icon">🚀</div><h2>App</h2><p>Vingilot Dynamic</p><small>/app/</small></a>
</div>
<div class="footer"><p>Accessible via: www.k02.com | sirion.k02.com</p></div>
</div>
</body></html>
EOF

chmod -R 755 /var/www/sirion
chown -R www-data:www-data /var/www/sirion

##4. Enable & Restart Nginx
ln -sf /etc/nginx/sites-available/sirion-proxy /etc/nginx/sites-enabled/
nginx -t
service nginx restart
service nginx status

##B. Update Backend Servers

Lindon (Static): pastikan menerima Host: static.k02.com.

Vingilot (Dynamic): pastikan menerima Host: app.k02.com.
(Config sudah OK, tidak perlu perubahan.)

##C. Verifikasi dari Client
1. Dari EARENDIL
# Cek DNS & Landing Page
dig www.k02.com +short
dig sirion.k02.com +short
curl -s -o /dev/null -w "%{http_code}" http://www.k02.com/
curl -s -o /dev/null -w "%{http_code}" http://sirion.k02.com/

# Test Proxy /static/ dan /app/
curl -s http://www.k02.com/static/ | grep -q "Lampion Lindon" && echo "✓ Lindon verified"
curl -s http://www.k02.com/app/ | grep -q "Vingilot" && echo "✓ Vingilot verified"

# Directory listing / URL rewrite
curl -s http://www.k02.com/static/annals/ | grep "Index of"
curl -s http://www.k02.com/app/about | grep "About Vingilot"

# Test akses langsung ke backend (harus gagal)
curl -s -o /dev/null -w "%{http_code}" http://192.212.3.13/
curl -s -o /dev/null -w "%{http_code}" http://192.212.3.14/

##2. Dari CÍRDAN
curl -I http://www.k02.com/
curl -I http://sirion.k02.com/
curl -s http://www.k02.com/static/ | head -20
curl -s http://www.k02.com/app/ | head -20
curl -s http://sirion.k02.com/static/annals/ | grep "Index of"
curl -s http://sirion.k02.com/app/about | grep "About Vingilot"

##3. Test Header Forwarding (Vingilot)
cat > /var/www/app.k02.com/about.php << 'EOF'
<html><body>
<h1>About Vingilot</h1>
<p>Server: <?php echo $_SERVER['SERVER_NAME']; ?></p>
<p>Host: <?php echo $_SERVER['HTTP_HOST'] ?? 'N/A'; ?></p>
<p>X-Real-IP: <?php echo $_SERVER['HTTP_X_REAL_IP'] ?? 'N/A'; ?></p>
<p>X-Forwarded-For: <?php echo $_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'N/A'; ?></p>
</body></html>
EOF

curl http://www.k02.com/app/about