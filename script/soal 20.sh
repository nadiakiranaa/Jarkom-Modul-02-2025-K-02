nano /var/www/sirion/index.html
html
<!DOCTYPE html>
<html>
<head>
    <title>War of Wrath: Lindon Bertahan</title>
</head>
<body>
    <h1>War of Wrath: Lindon Bertahan</h1>
    <p>Di ujung Perang Amarah, ketika Beleriand tenggelam ke dalam laut,</p>
    <p>Lindon bertahan sebagai sisa terakhir dari tanah kuno.</p>
    
    <h2>Layanan:</h2>
    <ul>
        <li><a href="/static/">Arsip Statis Lindon</a></li>
        <li><a href="/app/">Aplikasi Dinamis Vingilot</a></li>
    </ul>
    
    <p><small>Sirion Gateway - k02.com</small></p>
</body>
</html>
bash
chmod 644 /var/www/sirion/index.html

##B. Verifikasi dari EARENDIL
bash
# Akses beranda
curl http://www.k02.com/

# Test link /static/
curl -I http://www.k02.com/static/

# Test link /app/
curl -I http://www.k02.com/app/

##C. Verifikasi dari ELWING
bash
curl http://www.k02.com/
curl -I http://www.k02.com/static/
curl -I http://www.k02.com/app/

##D. Verifikasi dari CÍRDAN
bash
curl http://www.k02.com/
curl http://www.k02.com/static/
curl http://www.k02.com/app/

##E. Verifikasi dari ELROND
bash
curl http://www.k02.com/
curl -I http://www.k02.com/static/
curl -I http://www.k02.com/app/

##F. Verifikasi dari MAGLOR
bash
curl http://www.k02.com/
curl http://www.k02.com/static/
curl http://www.k02.com/app/