##A. Update Nginx Config di SIRION
bash
nano /etc/nginx/sites-available/sirion-proxy

#Ganti seluruh config dengan yang baru (tambahkan redirect blocks):
nginx
# Upstream definitions
upstream backend_static {
    server 192.212.3.13:80;
}

upstream backend_app {
    server 192.212.3.14:80;
}

# Redirect dari IP ke www.k02.com (301 Permanent)
server {
    listen 80;
    server_name 192.212.3.10;
    return 301 http://www.k02.com$request_uri;
}

# Redirect dari sirion.k02.com ke www.k02.com (301 Permanent)
server {
    listen 80;
    server_name sirion.k02.com;
    return 301 http://www.k02.com$request_uri;
}

# Main canonical server (www.k02.com)
server {
    listen 80;
    server_name www.k02.com;
    
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
    
    # Proxy ke Lindon (Web Statis)
    location /static/ {
        proxy_pass http://backend_static/;
        proxy_set_header Host static.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/static/(.*) /$1 break;
    }
    
    # Proxy ke Vingilot (Web Dinamis)
    location /app/ {
        proxy_pass http://backend_app/;
        proxy_set_header Host app.k02.com;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        rewrite ^/app/(.*) /$1 break;
    }
}

# Block other access
server {
    listen 80 default_server;
    server_name _;
    return 444;
}

##B. Restart Nginx
bash
nginx -t
service nginx restart

##C. Verifikasi dari Client (EARENDIL/CÍRDAN)
#1. Test Redirect dari IP
bash
# Test dengan curl -I (lihat header Location)
curl -I http://192.212.3.10/
# Expected output:
# HTTP/1.1 301 Moved Permanently
# Location: http://www.k02.com/

#2. Test Redirect dari sirion.k02.com
bash
curl -I http://sirion.k02.com/
# Expected output:
# HTTP/1.1 301 Moved Permanently
# Location: http://www.k02.com/

#3. Test Redirect dengan Path
bash
# Test IP dengan path
curl -I http://192.212.3.10/static/
# Expected:
# HTTP/1.1 301 Moved Permanently
# Location: http://www.k02.com/static/

# Test sirion.k02.com dengan path
curl -I http://sirion.k02.com/app/
# Expected:
# HTTP/1.1 301 Moved Permanently
# Location: http://www.k02.com/app/

#4. Test www.k02.com (Tidak Ada Redirect)
bash
curl -I http://www.k02.com/
# Expected:
# HTTP/1.1 200 OK
# (Tidak ada redirect, langsung serve konten)

#5. Test Follow Redirect
bash
# Curl dengan -L (follow redirect)
curl -L http://192.212.3.10/
# Akan otomatis follow redirect ke www.k02.com dan tampilkan konten