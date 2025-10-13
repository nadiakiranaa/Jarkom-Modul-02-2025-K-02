##A. Enable Autostart Services
#1. Di TIRION (ns1)
bash
# Enable BIND9
systemctl enable bind9
# Verifikasi
systemctl is-enabled bind9

#2. Di VALMAR (ns2)
bash
# Enable BIND9
systemctl enable bind9
# Verifikasi
systemctl is-enabled bind9

#3. Di SIRION (Reverse Proxy)
bash
# Enable Nginx
systemctl enable nginx
# Verifikasi
systemctl is-enabled nginx

##4. Di LINDON (Web Statis)
bash
# Enable Nginx
systemctl enable nginx
# Verifikasi
systemctl is-enabled nginx

##5. Di VINGILOT (Web Dinamis)
bash
# Enable Nginx
systemctl enable nginx
# Enable PHP-FPM
PHP_VER=$(php -v | head -n1 | awk '{print $2}' | cut -d'.' -f1,2)
systemctl enable php${PHP_VER}-fpm
# Verifikasi
systemctl is-enabled nginx
systemctl is-enabled php${PHP_VER}-fpm

##B. Test Reboot
#1. Reboot Semua Server
bash
# Di Tirion
reboot
# Di Valmar
reboot
# Di Sirion
reboot
# Di Lindon
reboot
# Di Vingilot
reboot
#2. Tunggu ~1-2 menit untuk boot