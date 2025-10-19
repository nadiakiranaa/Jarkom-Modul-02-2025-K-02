# Lapres Jarkom Modul 2 Kelompok K-02

| Nama | NRP |
| ---------------------- | ---------- |
| Nadia Kirana Afifah Prahandita | 5027241005 |
| Arya Bisma Putra Refman | 5027241036 |
----

## IP Address Host : 10.15.43.32

## War of Wrath
Sebuah gema gemuruh baru saja terdengar dari utara Beleriand, seperti denting senjata yang belum terhunus namun sudah membuat udara mencekam. Eonwe, pembawa panji Manwë, turun ke tanah fana untuk pertama kalinya, langkahnya menggetarkan batu-batu dasar Arda. Di langit yang semakin merah, Earendil mulai membawa Vingilot melenggang lebih tinggi, merasakan getaran Silmaril di dadanya berdenyut lebih cepat seolah-solah batu itu sendiri tahu bahwa ia akan segera dipanggil sebagai pelita terakhir. Elwing, di sisinya, memeluk sayap putih miliknya, menatap ke arah Sirion yang mulai beriak gelisah. Círdan, di dermaga terakhir Círdan’s Havens, memerintahkan para pandai kayu membongkar lambung kapal terbesar yang pernah dibuatnya. Ia belum tahu bahwa kapal itu nantinya akan membawa tidak hanya orang, tapi juga kenangan terakhir sebuah dunia. Maglor, masih menyanyikan lagu-lagu kelam di tepi bukit, merasakan darah Noldor dalam dadanya berdesir. Ia belum tahu bahwa suaranya akan menjadi saksi bisu atas kejatuhan yang tak terelakkan. Elrond, berdiri di antara reruntuhan pertama di Lindon, merasakan darah kedua dunia berdenyut di tangannya yang baru saja menyentuh gagang pedang pertama. Di kejauhan, Tirion di atas Túna mulai memancarkan cahaya yang lebih tajam dari biasanya, seolah Valmar sedang menarik napas dalam-dalam sebelum meneriakkan satu kata: “Cukup.” Dan Beleriand, yang masih utuh, yang masih punya nama-nama sungai dan hutan, baru saja menggeliat, belum tahu bahwa ia akan menjadi legenda yang tenggelam.

Glosarium untuk Soal Praktikum Modul 2:
- Eonwe = panglima/gerbang (router)
- Earendil, Elwing = klien Barat 
- Cirdan, Elrond, Maglor = klien Timur	
- Sirion = gerbang pelabuhan (reverse proxy)
- Tirion = penjaga nama utama (ns1)
- Valmar = penjaga nama bayangan (ns2)
- Lindon = pelabuhan web statis
- Vingilot = kapal web dinamis 
- Aturan resolver awal : setiap tokoh (host) non-router menambahkan nameserver 192.168.122.1 saat UI aktif (untuk memudahkan akses & instalasi paket yang dibutuhkan di awal).
- Penataan ulang resolver : setelah DNS internal hidup (soal 5), urutkan menjadi ns1 → ns2 → 192.168.122.1 pada semua non-router.
- <xxxx> : Isi dengan nama kelompok, contoh: K01
- Kanonik: hostname utama yang menjadi identitas publik layanan, semua akses lewat IP atau nama lain (mis. sirion.<xxxx>.com) dialihkan permanen ke hostname ini (mis. `www.<xxxx>.com`)
- Disarankan menggunakan php8.4-fpm.
- Gunakan Nginx (lihat pada modul untuk setup web)
- Angka dan Nama
  - Angka : mengakses tujuan dengan alamat IP langsung dan berupa angka.
  - Nama : mengakses tujuan dengan nama domain umum (di internet).
 
## Soal_1
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.

<img width="450" height="437" alt="image" src="https://github.com/user-attachments/assets/3952fde3-b441-4520-aec7-df8fd5c6fd43" />

### SCRIPT
#### Eonwe (Router)
```
auto lo
iface lo inet loopback

# WAN (DHCP)
auto eth0
iface eth0 inet dhcp

# Jalur Barat
auto eth1
iface eth1 inet static
    address 192.212.1.1
    netmask 255.255.255.0

# Jalur Timur
auto eth2
iface eth2 inet static
    address 192.212.2.1
    netmask 255.255.255.0

# Jalur DMZ
auto eth3
iface eth3 inet static
    address 192.212.3.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Earendil
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.10
    netmask 255.255.255.0
    gateway 192.212.1.1
```

#### Elwing
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.11
    netmask 255.255.255.0
    gateway 192.212.1.1
```

#### Círdan
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.10
    netmask 255.255.255.0
    gateway 192.212.2.1
```

#### Elrond
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.11
    netmask 255.255.255.0
    gateway 192.212.2.1
```

#### Maglor
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.12
    netmask 255.255.255.0
    gateway 192.212.2.1
```

#### Sirion (Reverse Proxy)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.10
    netmask 255.255.255.0
    gateway 192.212.3.1
```

#### Tirion (ns1)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.11
    netmask 255.255.255.0
    gateway 192.212.3.1
```

#### Valmar (ns2)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.12
    netmask 255.255.255.0
    gateway 192.212.3.1
```

#### Lindon (Web statis)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.13
    netmask 255.255.255.0
    gateway 192.212.3.1
```

#### Vingilot (Web dinamis)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.14
    netmask 255.255.255.0
    gateway 192.212.3.1
```

## Soal_2
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.

### SCRIPT
#### Eonwe(Router)
- tambahkan ke `/root/.bashrc`:
```
apt update
apt install -y procps iptables
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o eth3 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
```

### UJI
#### Melakukan uji di semua node, kecuali pada Eonwe (contoh: Earendil)
- `ping google.com`
<img width="890" height="252" alt="image" src="https://github.com/user-attachments/assets/910eff02-3f9c-4d3c-9ee3-37bca89c4d3d" />

## Soal_3
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.

### SCRIPT
#### Eonwe (Router)
```
auto lo
iface lo inet loopback

# WAN (DHCP)
auto eth0
iface eth0 inet dhcp

# Jalur Barat
auto eth1
iface eth1 inet static
    address 192.212.1.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Jalur Timur
auto eth2
iface eth2 inet static
    address 192.212.2.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Jalur DMZ
auto eth3
iface eth3 inet static
    address 192.212.3.1
    netmask 255.255.255.0
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Earendil
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.10
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Elwing
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.1.11
    netmask 255.255.255.0
    gateway 192.212.1.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Círdan
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.10
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Elrond
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.11
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Maglor
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.2.12
    netmask 255.255.255.0
    gateway 192.212.2.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Sirion (Reverse Proxy)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.10
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Tirion (ns1)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.11
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Valmar (ns2)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.12
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Lindon (Web statis)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.13
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

#### Vingilot (Web dinamis)
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.212.3.14
    netmask 255.255.255.0
    gateway 192.212.3.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf
```

### UJI
- dari Barat (Earendil) ke Timur (Cirdan)
  - ping 192.212.2.10
    
    <img width="670" height="275" alt="image" src="https://github.com/user-attachments/assets/99dfb7c8-6446-4b47-97a9-d711deb6da4d" />

- dari Timur (Cirdan) ke Barat (Earendil)
  - ping 192.212.1.10

    <img width="670" height="275" alt="image" src="https://github.com/user-attachments/assets/5f9ac4a5-6598-4539-ab90-1b57832c16fd" />

- Verifikasi resolver otomatis
  - cat /etc/resolv.conf
    
    <img width="530" height="57" alt="image" src="https://github.com/user-attachments/assets/96eb1af2-b431-4c7f-b2f6-5fa39ecd309e" />

## Soal_4
Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona <xxxx>.com sebagai authoritative dengan SOA yang menunjuk ke ns1.<xxxx>.com dan catatan NS untuk ns1.<xxxx>.com dan ns2.<xxxx>.com. Buat A record untuk ns1.<xxxx>.com dan ns2.<xxxx>.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex <xxxx>.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona <xxxx>.com dari Tirion dan pastikan menjawab authoritative. pada seluruh host non-router ubah urutan resolver menjadi IP dari ns1.<xxxx>.com → ns2.<xxxx>.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.

### SCRIPT
#### Tirion (ns1)
```
#!/bin/bash
# === [SETUP DNS MASTER - TIRION (ns1)] ===

echo "=== [1/6] Update & install dependencies ==="
apt update -y
apt install -y bind9 bind9-utils bind9-dnsutils procps

echo "=== [2/6] Konfigurasi BIND Master ==="
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;
    dnssec-validation no;
};
EOF

echo "=== [3/6] Konfigurasi Zona Master ==="
cat > /etc/bind/named.conf.local << 'EOF'
zone "k02.com" {
    type master;
    file "/etc/bind/zones/db.k02.com";
    allow-transfer { 192.212.3.12; };   // Valmar (Slave)
    notify yes;
};
EOF

echo "=== [4/6] Membuat direktori zona ==="
mkdir -p /etc/bind/zones
chown -R bind:bind /etc/bind/zones

echo "=== [5/6] Membuat file zona db.k02.com ==="
cat > /etc/bind/zones/db.k02.com << 'EOF'
$TTL    604800
@       IN      SOA     ns1.k02.com. root.k02.com. (
                        2025101701 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

; Nameservers
        IN      NS      ns1.k02.com.
        IN      NS      ns2.k02.com.

; A Records
ns1     IN      A       192.212.3.11     ; Tirion (Master)
ns2     IN      A       192.212.3.12     ; Valmar (Slave)
@       IN      A       192.212.3.10     ; Sirion (Front door)

; Optional alias
www     IN      CNAME   @
EOF

echo "=== [6/6] Menjalankan BIND Master ==="
# Buat alias agar service bind9 bisa dipanggil
if [ ! -e /etc/init.d/bind9 ]; then
    ln -s /etc/init.d/named /etc/init.d/bind9
fi

# Restart BIND
service bind9 stop >/dev/null 2>&1
pkill named >/dev/null 2>&1
service bind9 start
sleep 2
service bind9 status

echo ""
echo "✅ Setup DNS Master (Tirion) selesai tanpa error."
```

#### Valmar (ns2)
```
#!/bin/bash
# === [SETUP DNS SLAVE - VALMAR (ns2)] ===

echo "=== [1/5] Update & install dependencies ==="
apt update -y
apt install -y bind9 bind9-utils bind9-dnsutils procps

echo "=== [2/5] Konfigurasi BIND Slave ==="
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;
    dnssec-validation no;
};
EOF

echo "=== [3/5] Konfigurasi Zona Slave ==="
cat > /etc/bind/named.conf.local << 'EOF'
zone "k02.com" {
    type slave;
    masters { 192.212.3.11; };   # Tirion (Master)
    file "/var/lib/bind/db.k02.com";
};
EOF

echo "=== [4/5] Pastikan direktori zona ada & hak akses ==="
mkdir -p /var/lib/bind
chown -R bind:bind /var/lib/bind

echo "=== [5/5] Menjalankan BIND Slave ==="
# Buat alias agar service bind9 bisa dipanggil
if [ ! -e /etc/init.d/bind9 ]; then
    ln -s /etc/init.d/named /etc/init.d/bind9
fi

# Restart BIND
service bind9 stop >/dev/null 2>&1
pkill named >/dev/null 2>&1
service bind9 start

echo "=== Menunggu slave tarik zona dari master ==="
sleep 10  # Tunggu 10 detik agar file zona muncul

service bind9 status
echo ""
echo "✅ Setup DNS Slave (Valmar) selesai."
```

#### Tambahkan di seluruh konfigurasi host non router
```
up echo "nameserver 192.212.3.11" > /etc/resolv.conf
up echo "nameserver 192.212.3.12" >> /etc/resolv.conf
up echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```

### UJI
#### Tirion Master Test
`dig @localhost k02.com SOA`
<img width="1598" height="67" alt="image" src="https://github.com/user-attachments/assets/bfaf07ad-5d81-4ab1-86ab-623d63ccc9fb" />

`dig @localhost ns1.k02.com`
<img width="850" height="63" alt="image" src="https://github.com/user-attachments/assets/632ebe8e-442e-463c-80a4-f1ba20c6b760" />

`dig @localhost ns2.k02.com`
<img width="852" height="58" alt="image" src="https://github.com/user-attachments/assets/533b6a32-4c7d-4b09-acad-2cb94f29af85" />

#### Valmar Slave Test
`ls /var/lib/bind/`<br>
<img width="602" height="59" alt="image" src="https://github.com/user-attachments/assets/11ac6698-7574-46dc-a2d8-bd57bdab7cc7" />

`dig @localhost k02.com SOA`
<img width="1603" height="61" alt="image" src="https://github.com/user-attachments/assets/f0394c3d-891a-4d11-97f3-8492885bf7bc" />

`dig @localhost ns1.k02.com`
<img width="859" height="64" alt="image" src="https://github.com/user-attachments/assets/2877a269-d940-4931-b5f2-15fd690740f9" />

`dig @localhost ns2.k02.com`
<img width="850" height="57" alt="image" src="https://github.com/user-attachments/assets/fdf10997-a551-4207-bac0-7bd610ea2117" />

#### Client Test Query DNS Internal (contoh: Earendil)
`dig @192.212.3.11 k02.com`
<img width="849" height="57" alt="image" src="https://github.com/user-attachments/assets/9830d289-d263-4573-9266-09d8922aee7e" />

`dig @192.212.3.12 www.k02.com`
<img width="852" height="83" alt="image" src="https://github.com/user-attachments/assets/c3db0495-d156-4717-9a52-7cb99a1e20d0" />

## Soal_5
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai dengan namanya (contoh: eru.<xxxx>.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2

### SCRIPT
#### Tirion (ns1)
```
#!/bin/bash
# =============================================
# DNS MASTER SETUP SCRIPT — TIRION (ns1)
# Nomor 5 - Konfigurasi authoritative zone k02.com
# =============================================

echo "[1/6] Installing BIND9..."
apt update -y
apt install -y bind9 bind9-utils bind9-dnsutils

echo "[2/6] Creating zone directory..."
mkdir -p /etc/bind/zones

echo "[3/6] Writing zone file for k02.com..."
cat > /etc/bind/zones/db.k02.com <<'EOF'
$TTL 604800
@   IN  SOA ns1.k02.com. root.k02.com. (
        2025101902 ; Serial (naikkan setiap edit)
        604800     ; Refresh
        86400      ; Retry
        2419200    ; Expire
        604800 )   ; Negative Cache TTL

; === Authoritative Nameservers ===
    IN  NS  ns1.k02.com.
    IN  NS  ns2.k02.com.

; === APEX DOMAIN ===
@   IN  A   192.212.3.10    ; Sirion (front door)
www IN  CNAME @

; === DNS SERVERS ===
ns1 IN  A   192.212.3.11    ; Tirion (master)
ns2 IN  A   192.212.3.12    ; Valmar (slave)

; === ROUTER ===
eonwe     IN  A 192.212.1.1  ; Router utama

; === BARAT ===
earendil  IN  A 192.212.1.10
elwing    IN  A 192.212.1.11

; === TIMUR ===
cirdan    IN  A 192.212.2.10
elrond    IN  A 192.212.2.11
maglor    IN  A 192.212.2.12

; === DMZ ===
sirion    IN  A 192.212.3.10
tirion    IN  A 192.212.3.11
valmar    IN  A 192.212.3.12
lindon    IN  A 192.212.3.13
vingilot  IN  A 192.212.3.14
EOF

echo "[4/6] Configuring named.conf.local..."
cat > /etc/bind/named.conf.local <<'EOF'
zone "k02.com" {
    type master;
    file "/etc/bind/zones/db.k02.com";
    allow-transfer { 192.212.3.12; };  // Valmar (slave)
    notify yes;
};
EOF

echo "[5/6] Configuring named.conf.options..."
cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;
    dnssec-validation no;
    listen-on { any; };
};
EOF

echo "[6/6] Restarting BIND9 service..."
service bind9 restart

echo "✅ DNS Master (ns1 - Tirion) configuration completed successfully!"
```

#### EONWE (Router)
```
HOSTNAME=eonwe
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
hostname && hostname -f
```

#### Earendil
```
HOSTNAME=earendil
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Elwing
```
HOSTNAME=elwing
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Cirdan
```
HOSTNAME=cirdan
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
hostname && hostname -f
```

#### Elrond
```
HOSTNAME=elrond
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Maglor
```
HOSTNAME=maglor
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Sirion (Reverse Proxy)
```
HOSTNAME=sirion
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Tirion (ns1)
```
HOSTNAME=tirion
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Valmar (ns2)
```
HOSTNAME=valmar
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Lindon (Web statis)
```
HOSTNAME=lindon
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

#### Vingilot (Web dinamis)
```
HOSTNAME=vingilot
DOMAIN=k02.com
echo "$HOSTNAME" > /etc/hostname
hostname "$HOSTNAME"
sed -i "/127.0.1.1/d" /etc/hosts
echo "127.0.1.1   $HOSTNAME.$DOMAIN $HOSTNAME" >> /etc/hosts
sed -i '1i search k02.com' /etc/resolv.conf
hostname && hostname -f
```

### UJI
#### Tirion (ns1)
```
named-checkconf
named-checkzone k02.com /etc/bind/zones/db.k02.com
```
<img width="710" height="110" alt="image" src="https://github.com/user-attachments/assets/3265062f-7ee4-4be4-8223-c3dce7d31847" />

#### Di seluruh Host (contoh: Earendil)
`hostname && hostname -f`<br>
<img width="574" height="90" alt="image" src="https://github.com/user-attachments/assets/0ccf1e2d-48b0-48d6-b435-6985b985a04f" />

```
ping -c 3 eonwe
ping -c 3 elwing
ping -c 3 cirdan
ping -c 3 elrond
ping -c 3 maglor
ping -c 3 sirion
ping -c 3 tirion
ping -c 3 valmar
ping -c 3 lindon
ping -c 3 vingilot
```
<img width="445" height="422" alt="image" src="https://github.com/user-attachments/assets/a752a49d-3df1-4c73-9116-20947c9d9a81" />

## Soal_6
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama

#### SCRIPT
#### Tirion (ns1)
```
tee /etc/bind/named.conf.local > /dev/null <<EOF
zone "k02.com" {
    type master;
    file "/etc/bind/zones/db.k02.com";
    allow-transfer { 192.212.3.12; };   // Valmar (slave)
    also-notify { 192.212.3.12; };      // kasih notifikasi ke Valmar
    notify yes;
};
EOF

service bind9 restart
```

### UJI
#### Tirion
`dig @192.212.3.11 k02.com SOA`<br>
<img width="1592" height="624" alt="image" src="https://github.com/user-attachments/assets/4d937f16-1169-4b32-8531-a3e7d4913742" />

#### Valmar
`dig @192.212.3.12 k02.com ANY`
<img width="1592" height="622" alt="image" src="https://github.com/user-attachments/assets/f6c12cad-8938-46e7-98da-709b4a3fd94b" />

- Serial SOA sama dengan master (Tirion), yaitu `2025101902`
- flag AA muncul pada Tirion dan Valmar, menandakan keduanya sudah authoritative
- Record DNS lainnya muncul di slave
  - 192.212.3.10 → A record untuk sirion.k02.com (apex domain).
  - ns1.k02.com. dan ns2.k02.com. → NS records.
