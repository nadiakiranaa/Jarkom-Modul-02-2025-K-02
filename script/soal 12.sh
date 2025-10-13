##A. Konfigurasi di SIRION
#1. Install & Buat Password File
bash
apt install -y apache2-utils
mkdir -p /etc/nginx/.htpasswd
htpasswd -c /etc/nginx/.htpasswd/admin_users admin
# Password: beleriand123
chmod 640 /etc/nginx/.htpasswd/admin_users

#2. Buat Konten Admin (Simple)
bash
mkdir -p /var/www/sirion/admin
cat > /var/www/sirion/admin/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Admin Panel</title></head>
<body style="background:#0a0e27;color:#00ff41;font-family:monospace;text-align:center;padding:50px;">
    <h1> ADMIN PANEL</h1>
    <p>✓ Authentication Successful</p>
    <p>Server: sirion.k02.com (192.212.3.10)</p>
    <p>Protected by HTTP Basic Auth</p>
    <a href="/" style="color:#00ff41">← Back to Home</a>
</body>
</html>
EOF

#3. Update Nginx Config Sirion
bash
nano /etc/nginx/sites-available/sirion-proxy
Tambahkan location block untuk /admin SEBELUM location /:
nginx
server {
    listen 80;
    server_name www.k02.com sirion.k02.com;
    
    access_log /var/log/nginx/sirion-proxy.access.log;
    error_log /var/log/nginx/sirion-proxy.error.log;
    
    # Protected /admin path
    location /admin {
        auth_basic "Restricted Area - Admin Only";
        auth_basic_user_file /etc/nginx/.htpasswd/admin_users;
        root /var/www/sirion;
        index index.html;
        try_files $uri $uri/ =404;
    }
    
    # Root location
    location / {
        root /var/www/sirion;
        index index.html;
        try_files $uri $uri/ =404;
    }
    
    # Proxy ke Lindon
    location /static/ {
        proxy_pass http://192.212.3.13/;
        proxy_set_header Host static.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        rewrite ^/static/(.*) /$1 break;
    }
    
    # Proxy ke Vingilot
    location /app/ {
        proxy_pass http://192.212.3.14/;
        proxy_set_header Host app.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        rewrite ^/app/(.*) /$1 break;
    }
}

#4. Restart Nginx
bash
nginx -t
service nginx restart

##B. Verifikasi dari Client
#1. Test Tanpa Kredensial (Harus Ditolak - 401)
bash
curl -I http://www.k02.com/admin/
# Expected: HTTP/1.1 401 Unauthorized

#2. Test Dengan Kredensial Salah (Harus Ditolak - 401)
bash
curl -I -u admin:wrongpass http://www.k02.com/admin/
# Expected: HTTP/1.1 401 Unauthorized

#3. Test Dengan Kredensial Benar (Harus Berhasil - 200)
bash
curl -u admin:beleriand123 http://www.k02.com/admin/
# Expected: HTTP/1.1 200 OK + konten HTML

#4. Test dari Browser
bash
# Buka di lynx atau curl
lynx http://www.k02.com/admin/
# Akan muncul prompt username/password