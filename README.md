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

## Soal_7
Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, Vingilot sebagai web dinamis. Tambahkan pada zona <xxxx>.com A record untuk sirion.<xxxx>.com (IP Sirion), lindon.<xxxx>.com (IP Lindon), dan vingilot.<xxxx>.com (IP Vingilot). Tetapkan CNAME :
- `www.<xxxx>.com` → `sirion.<xxxx>.com`, 
- `static.<xxxx>.com` → `lindon.<xxxx>.com`, dan 
- `app.<xxxx>.com` → `vingilot.<xxxx>.com.` 
Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.

### UJI
#### Tirion
```
#!/bin/bash
# =============================================
# DNS MASTER SETUP SCRIPT — TIRION (ns1)
# Nomor 7 - Menambahkan CNAME record
# =============================================

echo "[1/4] Menghapus www CNAME @ yang lama..."
# Hapus www CNAME @ dari zona file jika ada
sed -i '/^www\s*IN\s*CNAME\s*@$/d' /etc/bind/zones/db.k02.com

echo "[2/4] Menambahkan CNAME record..."
cat >> /etc/bind/zones/db.k02.com <<'EOF'

; === ALIAS / CNAME ===
www    IN  CNAME sirion.k02.com.
static IN  CNAME lindon.k02.com.
app    IN  CNAME vingilot.k02.com.
EOF

echo "[3/4] Naikkan serial SOA..."
# Ambil serial lama dengan regex lebih spesifik
OLD_SERIAL=$(grep '^\s*[0-9]\{10\}' /etc/bind/zones/db.k02.com | head -1 | awk '{print $1}')

if [ -z "$OLD_SERIAL" ]; then
    echo "❌ ERROR: Tidak bisa ambil serial!"
    exit 1
fi

# Tambah 1
NEW_SERIAL=$((OLD_SERIAL + 1))

echo "Serial lama: $OLD_SERIAL → Serial baru: $NEW_SERIAL"

# Replace dengan lebih aman (hanya di line dengan SOA)
sed -i "0,/$OLD_SERIAL/s/$OLD_SERIAL/$NEW_SERIAL/" /etc/bind/zones/db.k02.com

echo "[4/4] Verifikasi zone file..."
named-checkzone k02.com /etc/bind/zones/db.k02.com

if [ $? -eq 0 ]; then
    echo "✅ Zone file valid!"
    service bind9 restart
    echo "✅ BIND9 restart berhasil!"
    echo "✅ CNAME record untuk www, static, dan app telah ditambahkan!"
else
    echo "❌ Zone file error! Restart BIND9 dibatalkan."
    exit 1
fi
```

### UJI
#### Di Klien (contoh: Earendil)
```
dig @192.212.3.11 www.k02.com A +short
dig @192.212.3.11 static.k02.com A +short
dig @192.212.3.11 app.k02.com A +short
```
<img width="789" height="251" alt="image" src="https://github.com/user-attachments/assets/95b24b4d-afde-4cef-bbc4-2c42b6ea1806" />

## Soal_8
Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, Vingilot dijawab authoritative.

### SCRIPT
#### Tirion
```
#!/bin/bash
# =============================================
# REVERSE DNS SETUP — SOAL 8 (TIRION/ns1)
# =============================================
# Segmen DMZ: 192.212.3.0/24
# Reverse zone: 3.212.192.in-addr.arpa
# =============================================

echo "=== SOAL 8: REVERSE DNS ZONE (TIRION/ns1) ==="

# ===== STEP 1: CREATE REVERSE ZONE FILE =====
echo "[1/5] Creating reverse zone file..."
mkdir -p /etc/bind/zones

cat > /etc/bind/zones/db.3.212.192.in-addr.arpa <<'EOF'
$TTL 604800
@   IN  SOA ns1.k02.com. root.k02.com. (
        2025101901 ; Serial
        604800     ; Refresh
        86400      ; Retry
        2419200    ; Expire
        604800 )   ; Negative Cache TTL

; === Authoritative Nameservers ===
    IN  NS  ns1.k02.com.
    IN  NS  ns2.k02.com.

; === PTR RECORDS (DMZ Segment) ===
10  IN  PTR sirion.k02.com.
11  IN  PTR tirion.k02.com.
12  IN  PTR valmar.k02.com.
13  IN  PTR lindon.k02.com.
14  IN  PTR vingilot.k02.com.
EOF

echo "✅ Reverse zone file created"

# ===== STEP 2: REMOVE EXISTING REVERSE ZONE CONFIG (IF ANY) =====
echo "[2/5] Cleaning old reverse zone configuration..."
sed -i '/^zone "3\.212\.192\.in-addr\.arpa"/,/^}/d' /etc/bind/named.conf.local

echo "✅ Old config removed (if exists)"

# ===== STEP 3: ADD REVERSE ZONE CONFIGURATION =====
echo "[3/5] Adding reverse zone configuration..."
cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.212.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.3.212.192.in-addr.arpa";
    allow-transfer { 192.212.3.12; };  // Valmar (slave)
    also-notify { 192.212.3.12; };
    notify yes;
};
EOF

echo "✅ Reverse zone configuration added (no duplicates)"

# ===== STEP 4: VERIFY CONFIGURATION =====
echo "[4/5] Verifying configuration..."
named-checkconf
if [ $? -ne 0 ]; then
    echo "❌ named-checkconf failed!"
    exit 1
fi

named-checkzone 3.212.192.in-addr.arpa /etc/bind/zones/db.3.212.192.in-addr.arpa
if [ $? -ne 0 ]; then
    echo "❌ Zone check failed!"
    exit 1
fi

echo "✅ Configuration valid!"

# ===== STEP 5: RESTART BIND9 =====
echo "[5/5] Restarting BIND9..."
service bind9 restart

if [ $? -eq 0 ]; then
    echo "✅ BIND9 restart successful!"
else
    echo "❌ BIND9 restart failed!"
    exit 1
fi

echo ""
echo "✅ SOAL 8: Reverse DNS Master (Tirion/ns1) setup completed!"
echo ""
```

#### Valmar
```
#!/bin/bash
# =============================================
# REVERSE DNS SLAVE SETUP — SOAL 8 (VALMAR/ns2)
# =============================================

echo "=== SOAL 8: REVERSE DNS SLAVE (Valmar/ns2) ==="

echo "[1/3] Cleaning old reverse zone configuration..."
# Hapus reverse zone config yang lama jika ada
sed -i '/^zone "3\.212\.192\.in-addr\.arpa"/,/^}/d' /etc/bind/named.conf.local

echo "✅ Old config removed (if exists)"

echo "[2/3] Configuring reverse zone slave in named.conf.local..."
cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.212.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.3.212.192.in-addr.arpa";
    masters { 192.212.3.11; };  // Tirion (master)
};
EOF

echo "✅ Reverse zone slave configuration added (no duplicates)"

echo "[3/3] Verifying and restarting BIND9..."
named-checkconf
if [ $? -ne 0 ]; then
    echo "❌ named-checkconf failed!"
    exit 1
fi

service bind9 restart

if [ $? -eq 0 ]; then
    echo "✅ BIND9 restart successful!"
else
    echo "❌ BIND9 restart failed!"
    exit 1
fi

echo ""
echo "✅ SOAL 8: Reverse DNS Slave (Valmar/ns2) setup completed!"
echo ""
```

### UJI
#### Tirion
```
dig -x 192.212.3.10
dig -x 192.212.3.13
dig -x 192.212.3.14
```
<img width="516" height="919" alt="image" src="https://github.com/user-attachments/assets/3675aa7b-ea4f-4b37-b7fc-ff7a36e6938c" />

#### Valmar
```
dig -x 192.212.3.10
dig -x 192.212.3.13
dig -x 192.212.3.14
```
<img width="442" height="787" alt="image" src="https://github.com/user-attachments/assets/9d9d1447-5b67-411b-bec2-9a6a1ad6d28b" />

## Soal_9
Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.<xxxx>.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.

### SCRIPT
#### Lindon
```
#!/bin/bash
# =============================================
# SOAL 9: NGINX STATIC WEB SERVER — LINDON
# =============================================
# Hostname: static.k02.com
# IP: 192.212.3.13
# Folder arsip: /annals/ dengan autoindex
# =============================================

echo "=== SOAL 9: NGINX STATIC WEB SERVER (LINDON) ==="

# ===== STEP 1: KILL EXISTING NGINX PROCESSES =====
echo "[1/8] Stopping existing Nginx processes..."
pkill -9 nginx 2>/dev/null
fuser -k 80/tcp 2>/dev/null
sleep 2
rm -f /var/run/nginx.pid
> /var/log/nginx/error.log

echo "✅ Existing processes stopped"

# ===== STEP 2: INSTALL NGINX =====
echo "[2/8] Installing Nginx..."
apt update -y
apt install -y nginx

echo "✅ Nginx installed"

# ===== STEP 3: CREATE ANNALS DIRECTORY =====
echo "[3/8] Creating /annals/ directory..."
mkdir -p /annals

# Buat contoh file untuk testing
cat > /annals/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Annals Archive</title></head>
<body>
<h1>📚 Annals Archive</h1>
<p>This is a test file in the annals directory.</p>
</body>
</html>
EOF

echo "File 1" > /annals/document1.txt
echo "File 2" > /annals/document2.txt
mkdir -p /annals/subfolder
echo "Subfolder document" > /annals/subfolder/file.txt

echo "✅ /annals/ directory created with sample files"

# ===== STEP 4: SET PROPER PERMISSIONS =====
echo "[4/8] Setting permissions..."
chmod -R 755 /annals
chown -R www-data:www-data /annals

echo "✅ Permissions set"

# ===== STEP 5: DISABLE DEFAULT SITE =====
echo "[5/8] Disabling default site..."
rm -f /etc/nginx/sites-enabled/default

echo "✅ Default site disabled"

# ===== STEP 6: CREATE NGINX CONFIG FOR static.k02.com =====
echo "[6/8] Creating Nginx configuration..."
cat > /etc/nginx/sites-available/static.k02.com <<'EOF'
server {
    listen 80;
    server_name static.k02.com;

    root /annals;
    index index.html;

    location / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    access_log /var/log/nginx/static.k02.com.access.log;
    error_log /var/log/nginx/static.k02.com.error.log;
}
EOF

echo "✅ Nginx config created (root /annals, no alias conflict)"

# ===== STEP 7: ENABLE SITE =====
echo "[7/8] Enabling site..."
ln -sf /etc/nginx/sites-available/static.k02.com /etc/nginx/sites-enabled/static.k02.com

echo "✅ Site enabled"

# ===== STEP 8: TEST, START, AND VERIFY =====
echo "[8/8] Testing and starting Nginx..."

nginx -t
if [ $? -ne 0 ]; then
    echo "❌ Nginx config error!"
    exit 1
fi

service nginx start
sleep 2

if service nginx status > /dev/null 2>&1; then
    echo "✅ Nginx started successfully"
else
    echo "❌ Nginx failed to start!"
    service nginx status
    exit 1
fi

echo ""
echo "✅ SOAL 9: Nginx static web server setup completed!"
echo ""
```

### UJI
#### Lindon
```
curl http://static.k02.com
curl http://static.k02.com/
curl http://static.k02.com/document1.txt
```
<img width="480" height="383" alt="image" src="https://github.com/user-attachments/assets/d7e918ed-2c70-4fe6-aa46-1b6e6da11d1d" />

## Soal_10 
Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.<xxxx>.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.

### SCRIPT
#### Vingilot
```
#!/bin/bash
# =============================================
# SOAL 10: PHP-FPM DYNAMIC WEB SERVER — VINGILOT
# =============================================
# Hostname: app.k02.com
# IP: 192.212.3.14
# Fitur: Homepage, About page, URL rewrite /about
# =============================================

echo "=== SOAL 10: PHP-FPM DYNAMIC WEB SERVER (VINGILOT) ==="

# ===== STEP 1: KILL EXISTING PROCESSES =====
echo "[1/9] Stopping existing processes..."
pkill -9 nginx 2>/dev/null
pkill -9 php-fpm 2>/dev/null
pkill -9 php8.4-fpm 2>/dev/null
fuser -k 80/tcp 2>/dev/null
sleep 2
rm -f /var/run/nginx.pid /var/run/php-fpm.pid /var/run/php8.4-fpm.pid
> /var/log/nginx/error.log

echo "✅ Existing processes stopped"

# ===== STEP 2: INSTALL PACKAGES =====
echo "[2/9] Installing Nginx and PHP-FPM..."
apt update -y
apt install -y nginx php-fpm php-cli

echo "✅ Nginx and PHP-FPM installed"

# ===== STEP 3: CREATE WEB ROOT DIRECTORY =====
echo "[3/9] Creating web root directory..."
mkdir -p /var/www/app

echo "✅ Web root created"

# ===== STEP 4: CREATE PHP FILES =====
echo "[4/9] Creating PHP files..."

# Homepage (index.php)
cat > /var/www/app/index.php <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Vingilot - Dynamic Stories</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        a { color: #0066cc; text-decoration: none; margin-right: 20px; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>🌟 Vingilot - Dynamic Stories</h1>
    <p>Welcome to the dynamic web server!</p>
    <p>
        <a href="/">Home</a>
        <a href="/about">About</a>
    </p>
    <p>This is the homepage. Served by PHP-FPM on Vingilot.</p>
</body>
</html>
EOF

# About page (about.php)
cat > /var/www/app/about.php <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>About - Vingilot</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        a { color: #0066cc; text-decoration: none; margin-right: 20px; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>📖 About Vingilot</h1>
    <p>
        <a href="/">Home</a>
        <a href="/about">About</a>
    </p>
    <p>Vingilot is a dynamic web server running PHP-FPM.</p>
    <p>This page demonstrates URL rewriting - /about works without .php extension!</p>
</body>
</html>
EOF

echo "✅ PHP files created"

# ===== STEP 5: SET PERMISSIONS =====
echo "[5/9] Setting permissions..."
chmod -R 755 /var/www/app
chown -R www-data:www-data /var/www/app

echo "✅ Permissions set"

# ===== STEP 6: START PHP-FPM =====
echo "[6/9] Starting PHP-FPM..."

# Detect PHP version
PHP_VERSION=$(php -v | grep -oP 'PHP \K[0-9]+\.[0-9]+')
PHP_SERVICE="php${PHP_VERSION}-fpm"
PHP_SOCKET="/run/php/${PHP_SERVICE}.sock"

# Start PHP-FPM service
service $PHP_SERVICE start
sleep 3

# Verify socket exists
if [ ! -S "$PHP_SOCKET" ]; then
    echo "❌ PHP-FPM socket not found at $PHP_SOCKET"
    exit 1
fi

echo "✅ PHP-FPM started (socket: $PHP_SOCKET)"

# ===== STEP 7: DISABLE DEFAULT SITE =====
echo "[7/9] Disabling default site..."
rm -f /etc/nginx/sites-enabled/default

echo "✅ Default site disabled"

# ===== STEP 8: CREATE NGINX CONFIG =====
echo "[8/9] Creating Nginx configuration..."
cat > /etc/nginx/sites-available/app.k02.com <<EOF
server {
    listen 80;
    server_name app.k02.com;

    root /var/www/app;
    index index.php index.html;

    # URL rewriting - /about -> /about.php
    location / {
        try_files \$uri \$uri/ \$uri.php?\$query_string;
    }

    # PHP-FPM configuration
    location ~ \.php$ {
        fastcgi_pass unix:${PHP_SOCKET};
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    # Deny access to .htaccess
    location ~ /\.ht {
        deny all;
    }

    access_log /var/log/nginx/app.k02.com.access.log;
    error_log /var/log/nginx/app.k02.com.error.log;
}
EOF

echo "✅ Nginx config created"

# ===== STEP 9: ENABLE SITE, TEST AND START =====
echo "[9/9] Enabling site and starting Nginx..."

# Enable site
ln -sf /etc/nginx/sites-available/app.k02.com /etc/nginx/sites-enabled/app.k02.com

# Test config
nginx -t
if [ $? -ne 0 ]; then
    echo "❌ Nginx config error!"
    exit 1
fi

# Start Nginx
service nginx start
sleep 2

# Verify
if service nginx status > /dev/null 2>&1; then
    echo "✅ Nginx started successfully"
else
    echo "❌ Nginx failed to start!"
    service nginx status
    exit 1
fi

echo ""
echo "✅ SOAL 10: PHP-FPM dynamic web server setup completed!"
echo ""
```

### UJI
#### Vingilot
```
curl http://app.k02.com
curl http://app.k02.com/
curl http://app.k02.com/about
```
<img width="610" height="925" alt="image" src="https://github.com/user-attachments/assets/3dcb4fbe-61d3-44e5-97b0-ee071cbd322e" />

## Soal_11 
Di muara sungai, Sirion berdiri sebagai reverse proxy. Terapkan path-based routing: /static → Lindon dan /app → Vingilot, sambil meneruskan header Host dan X-Real-IP ke backend. Pastikan Sirion menerima `www.<xxxx>.com` (kanonik) dan sirion.<xxxx>.com, dan bahwa konten pada /static dan /app di-serve melalui backend yang tepat.

### SCRIPT
#### Sirion
```
#!/bin/bash
# =============================================
# SOAL 11: REVERSE PROXY — SIRION
# =============================================
# Hostname: www.k02.com, sirion.k02.com
# IP: 192.212.3.10
# Path-based routing:
#   /static/ → Lindon (192.212.3.13:80)
#   /app/ → Vingilot (192.212.3.14:80)
# =============================================

echo "=== SOAL 11: REVERSE PROXY (SIRION) ==="

# ===== STEP 1: INSTALL REQUIRED PACKAGES =====
echo "[1/8] Installing required packages..."
apt update -y
apt install -y procps nginx

echo "✅ Packages installed"

# ===== STEP 2: COMPLETE PORT & PROCESS CLEANUP =====
echo "[2/8] Complete cleanup of port 80..."

# Stop service first
service nginx stop 2>/dev/null

# Kill all nginx processes
pkill -9 nginx 2>/dev/null
pkill -9 -f nginx 2>/dev/null

# Force release port 80
fuser -k 80/tcp 2>/dev/null
fuser -k 80/udp 2>/dev/null

# Remove lock/pid files
rm -f /var/run/nginx.pid
rm -f /var/run/nginx.lock

# Wait for kernel to release
sleep 4

echo "✅ Port 80 fully cleaned"

# ===== STEP 3: REMOVE ALL OLD CONFIGS =====
echo "[3/8] Removing old nginx configs..."

rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/static.k02.com
rm -f /etc/nginx/sites-available/app.k02.com
rm -f /etc/nginx/sites-available/reverse-proxy.k02.com
rm -f /etc/nginx/sites-available/default

echo "✅ Old configs removed"

# ===== STEP 4: CREATE REVERSE PROXY CONFIG =====
echo "[4/8] Creating reverse proxy configuration..."

cat > /etc/nginx/sites-available/reverse-proxy.k02.com <<'EOF'
upstream lindon_backend {
    server 192.212.3.13:80;
}

upstream vingilot_backend {
    server 192.212.3.14:80;
}

server {
    listen 80;
    server_name www.k02.com sirion.k02.com;

    # Static content: /static/ → Lindon (strip /static)
    location /static/ {
        proxy_pass http://lindon_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Redirect /static to /static/
    location /static {
        return 301 /static/;
    }

    # Dynamic content: /app/ → Vingilot (strip /app)
    location /app/ {
        proxy_pass http://vingilot_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Redirect /app to /app/
    location /app {
        return 301 /app/;
    }

    # Default homepage
    location / {
        return 200 "Welcome to Sirion Reverse Proxy - Gateway of Beleriand\n";
        add_header Content-Type text/plain;
    }

    access_log /var/log/nginx/reverse-proxy.k02.com.access.log;
    error_log /var/log/nginx/reverse-proxy.k02.com.error.log;
}
EOF

echo "✅ Reverse proxy config created"

# ===== STEP 5: ENABLE SITE =====
echo "[5/8] Enabling site..."

ln -sf /etc/nginx/sites-available/reverse-proxy.k02.com /etc/nginx/sites-enabled/reverse-proxy.k02.com

echo "✅ Site symlink created"

# ===== STEP 6: VERIFY CONFIG =====
echo "[6/8] Verifying nginx configuration..."

nginx -t 2>&1 | grep -E "(ok|error)"

if [ $? -ne 0 ]; then
    echo "❌ Config error"
    exit 1
fi

echo "✅ Config valid"

# ===== STEP 7: START NGINX =====
echo "[7/8] Starting nginx..."

service nginx start 2>&1

sleep 3

echo "✅ Nginx started"

# ===== STEP 8: VERIFY RUNNING =====
echo "[8/8] Verifying nginx is running..."

if service nginx status > /dev/null 2>&1; then
    echo "✅ Nginx running"
else
    echo "❌ Nginx not running"
    exit 1
fi

# Check port listening
if netstat -tuln 2>/dev/null | grep -q ":80 " || ss -tuln 2>/dev/null | grep -q ":80 "; then
    echo "✅ Port 80 listening"
else
    echo "❌ Port 80 not listening"
    exit 1
fi

echo ""
echo "✅ SOAL 11: REVERSE PROXY SETUP COMPLETE!"
echo ""
```

### UJI
#### di semua host kecuali Sirion (contoh: Earendil)
```
curl http://www.k02.com/static/
curl http://www.k02.com/app/
```
<img width="664" height="592" alt="image" src="https://github.com/user-attachments/assets/d2bfb5d5-4260-4150-9cfd-fb2dda5c29ea" />

## Soal_12 
Ada kamar kecil di balik gerbang yakni /admin. Lindungi path tersebut di Sirion menggunakan Basic Auth, akses tanpa kredensial harus ditolak dan akses dengan kredensial yang benar harus diizinkan.

### SCRIPT
#### Sirion
```
#!/bin/bash
# =============================================
# SOAL 12: BASIC AUTH FOR /admin — SIRION (FIXED)
# =============================================
# Path: /admin
# Username: admin
# Password: admin123
# =============================================

echo "=== SOAL 12: BASIC AUTH FOR /admin (SIRION) - FIXED ==="

# ===== STEP 1: INSTALL APACHE2-UTILS =====
echo "[1/6] Installing apache2-utils..."
apt update -y
apt install -y apache2-utils

echo "✅ apache2-utils installed"

# ===== STEP 2: CREATE PASSWORD FILE =====
echo "[2/6] Creating password file..."

mkdir -p /etc/nginx/auth
htpasswd -cb /etc/nginx/auth/.htpasswd admin admin123
chmod 640 /etc/nginx/auth/.htpasswd
chown www-data:www-data /etc/nginx/auth/.htpasswd

echo "✅ Password file created"

# ===== STEP 3: CREATE ADMIN CONTENT DIRECTORY =====
echo "[3/6] Creating admin content directory..."

mkdir -p /var/www/admin
cat > /var/www/admin/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Admin Area - Sirion</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        h1 { margin-top: 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 Admin Area - Sirion Gateway</h1>
        <p>✅ You are authenticated successfully!</p>
        <p>Welcome to the restricted admin panel.</p>
        <hr>
        <p><small>Protected by Basic Authentication</small></p>
    </div>
</body>
</html>
EOF

chmod -R 755 /var/www/admin
chown -R www-data:www-data /var/www/admin

echo "✅ Admin content created"

# ===== STEP 4: UPDATE NGINX CONFIG =====
echo "[4/6] Updating nginx configuration..."

cp /etc/nginx/sites-available/reverse-proxy.k02.com /etc/nginx/sites-available/reverse-proxy.k02.com.bak

cat > /etc/nginx/sites-available/reverse-proxy.k02.com <<'EOF'
upstream lindon_backend {
    server 192.212.3.13:80;
}

upstream vingilot_backend {
    server 192.212.3.14:80;
}

server {
    listen 80;
    server_name www.k02.com sirion.k02.com;

    # Static content: /static/ → Lindon
    location /static/ {
        proxy_pass http://lindon_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        return 301 /static/;
    }

    # Dynamic content: /app/ → Vingilot
    location /app/ {
        proxy_pass http://vingilot_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /app {
        return 301 /app/;
    }

    # Protected admin area - DENGAN BASIC AUTH
    location /admin/ {
        auth_basic "Restricted Area - Admin Only";
        auth_basic_user_file /etc/nginx/auth/.htpasswd;

        # Serve static content dari /var/www/admin
        root /var/www;
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /admin {
        return 301 /admin/;
    }

    # Default homepage
    location / {
        return 200 "Welcome to Sirion Reverse Proxy - Gateway of Beleriand\n";
        add_header Content-Type text/plain;
    }

    access_log /var/log/nginx/reverse-proxy.k02.com.access.log;
    error_log /var/log/nginx/reverse-proxy.k02.com.error.log;
}
EOF

echo "✅ Nginx config updated"

# ===== STEP 5: VERIFY CONFIG =====
echo "[5/6] Verifying nginx configuration..."

nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Config error!"
    exit 1
fi

echo "✅ Config valid"

# ===== STEP 6: RELOAD NGINX =====
echo "[6/6] Reloading nginx..."

service nginx reload

echo "✅ Nginx reloaded"

echo ""
echo "✅ SOAL 12: BASIC AUTH SETUP COMPLETE (FIXED)!"
echo ""
```

### UJI
#### di semua host kecuali Sirion (contoh: Earendil)
```
curl http://www.k02.com/admin/
curl -u admin:admin123 http://www.k02.com/admin/
```
<img width="680" height="743" alt="image" src="https://github.com/user-attachments/assets/2748f03a-a34c-4335-905c-3c6409b24f0b" />

## Soal_13
“Panggil aku dengan nama,” ujar Sirion kepada mereka yang datang hanya menyebut angka. Kanonisasikan endpoint, akses melalui IP address Sirion maupun sirion.<xxxx>.com harus redirect 301 ke `www.<xxxx>.com` sebagai hostname kanonik.

### SCRIPT
#### Sirion
```
#!/bin/bash
# =============================================
# SOAL 13: CANONICALIZATION — SIRION
# =============================================
# Redirect 301:
#   192.212.3.10 → www.k02.com
#   sirion.k02.com → www.k02.com
# Canonical hostname: www.k02.com
# =============================================

echo "=== SOAL 13: CANONICALIZATION (SIRION) ==="

# ===== STEP 1: BACKUP EXISTING CONFIG =====
echo "[1/3] Backing up existing config..."
cp /etc/nginx/sites-available/reverse-proxy.k02.com /etc/nginx/sites-available/reverse-proxy.k02.com.bak-soal13

echo "✅ Backup created"

# ===== STEP 2: UPDATE NGINX CONFIG WITH CANONICALIZATION =====
echo "[2/3] Updating nginx configuration with canonicalization..."

cat > /etc/nginx/sites-available/reverse-proxy.k02.com <<'EOF'
upstream lindon_backend {
    server 192.212.3.13:80;
}

upstream vingilot_backend {
    server 192.212.3.14:80;
}

# Redirect IP address dan sirion.k02.com ke canonical hostname
server {
    listen 80;
    server_name 192.212.3.10 sirion.k02.com;
    
    # Redirect semua request ke www.k02.com dengan status 301 (Moved Permanently)
    return 301 http://www.k02.com$request_uri;
}

# Main server - Canonical hostname
server {
    listen 80;
    server_name www.k02.com;

    # Static content: /static/ → Lindon
    location /static/ {
        proxy_pass http://lindon_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        return 301 /static/;
    }

    # Dynamic content: /app/ → Vingilot
    location /app/ {
        proxy_pass http://vingilot_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /app {
        return 301 /app/;
    }

    # Protected admin area
    location /admin/ {
        auth_basic "Restricted Area - Admin Only";
        auth_basic_user_file /etc/nginx/auth/.htpasswd;
        
        root /var/www;
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /admin {
        return 301 /admin/;
    }

    # Default homepage
    location / {
        return 200 "Welcome to Sirion Reverse Proxy - Gateway of Beleriand\nCanonical Hostname: www.k02.com\n";
        add_header Content-Type text/plain;
    }

    access_log /var/log/nginx/reverse-proxy.k02.com.access.log;
    error_log /var/log/nginx/reverse-proxy.k02.com.error.log;
}
EOF

echo "✅ Nginx config updated with canonicalization"

# ===== STEP 3: VERIFY AND RELOAD =====
echo "[3/3] Verifying and reloading nginx..."

nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Config error! Restoring backup..."
    mv /etc/nginx/sites-available/reverse-proxy.k02.com.bak-soal13 /etc/nginx/sites-available/reverse-proxy.k02.com
    exit 1
fi

echo "✅ Config valid"

service nginx reload

if [ $? -eq 0 ]; then
    echo "✅ Nginx reloaded successfully"
else
    echo "❌ Nginx reload failed!"
    exit 1
fi

echo ""
echo "✅ SOAL 13: CANONICALIZATION SETUP COMPLETE!"
echo ""
```

### UJI
#### di semua host kecuali Sirion (contoh: Earendil)
```
curl -I http://192.212.3.10/
curl -I http://sirion.k02.com/
curl -I http://www.k02.com/
```
<img width="509" height="556" alt="image" src="https://github.com/user-attachments/assets/f1b4a95b-9ff8-4b54-a76f-f8a3cc94aa3f" />

## Soal_14
Di Vingilot, catatan kedatangan harus jujur. Pastikan access log aplikasi di Vingilot mencatat IP address klien asli saat lalu lintas melewati Sirion (bukan IP Sirion).

### SCRIPT
#### Vingilot
```
#!/bin/bash
# =============================================
# SOAL 14: REAL IP LOGGING — VINGILOT
# =============================================
# Pastikan access log mencatat IP klien asli
# (bukan IP Sirion/reverse proxy)
# =============================================

echo "=== SOAL 14: REAL IP LOGGING (VINGILOT) ==="

# ===== STEP 1: BACKUP EXISTING CONFIG =====
echo "[1/4] Backing up existing config..."
cp /etc/nginx/sites-available/app.k02.com /etc/nginx/sites-available/app.k02.com.bak-soal14

echo "✅ Backup created"

# ===== STEP 2: DETECT PHP VERSION =====
echo "[2/4] Detecting PHP version..."
PHP_VERSION=$(php -v | grep -oP 'PHP \K[0-9]+\.[0-9]+')
PHP_SOCKET="/run/php/php${PHP_VERSION}-fpm.sock"

echo "✅ PHP version: $PHP_VERSION"
echo "✅ PHP socket: $PHP_SOCKET"

# ===== STEP 3: UPDATE NGINX CONFIG WITH REAL IP LOGGING =====
echo "[3/4] Updating nginx configuration..."

cat > /etc/nginx/sites-available/app.k02.com <<EOF
# Custom log format yang menampilkan IP asli dari X-Real-IP dan X-Forwarded-For
log_format real_ip '\$http_x_real_ip - \$remote_user [\$time_local] '
                    '"\$request" \$status \$body_bytes_sent '
                    '"\$http_referer" "\$http_user_agent" '
                    'X-Forwarded-For: \$http_x_forwarded_for';

server {
    listen 80;
    server_name app.k02.com;

    root /var/www/app;
    index index.php index.html;

    # Gunakan custom log format untuk mencatat real IP
    access_log /var/log/nginx/app.k02.com.access.log real_ip;
    error_log /var/log/nginx/app.k02.com.error.log;

    # URL rewriting - /about -> /about.php
    location / {
        try_files \$uri \$uri/ \$uri.php?\$query_string;
    }

    # PHP-FPM configuration
    location ~ \.php$ {
        fastcgi_pass unix:${PHP_SOCKET};
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        # Pass real IP to PHP application
        fastcgi_param HTTP_X_REAL_IP \$http_x_real_ip;
        fastcgi_param HTTP_X_FORWARDED_FOR \$http_x_forwarded_for;
        fastcgi_param REMOTE_ADDR \$http_x_real_ip;

        include fastcgi_params;
    }

    # Deny access to .htaccess
    location ~ /\.ht {
        deny all;
    }
}
EOF

echo "✅ Nginx config updated with real IP logging"

# ===== STEP 4: CREATE PHP TEST PAGE =====
echo "[4/4] Creating PHP test page to show real IP..."

cat > /var/www/app/showip.php <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>IP Address Info - Vingilot</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            margin: 40px;
            background: #1a1a1a;
            color: #00ff00;
        }
        .container {
            background: #000;
            padding: 30px;
            border: 2px solid #00ff00;
            border-radius: 10px;
        }
        h1 { color: #00ff00; margin-top: 0; }
        .info { margin: 15px 0; padding: 10px; background: #0a0a0a; }
        .label { color: #ffff00; font-weight: bold; }
        .value { color: #00ffff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 IP Address Information - Vingilot</h1>

        <div class="info">
            <span class="label">REMOTE_ADDR:</span>
            <span class="value"><?php echo $_SERVER['REMOTE_ADDR'] ?? 'N/A'; ?></span>
        </div>

        <div class="info">
            <span class="label">HTTP_X_REAL_IP:</span>
            <span class="value"><?php echo $_SERVER['HTTP_X_REAL_IP'] ?? 'N/A'; ?></span>
        </div>

        <div class="info">
            <span class="label">HTTP_X_FORWARDED_FOR:</span>
            <span class="value"><?php echo $_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'N/A'; ?></span>
        </div>

        <div class="info">
            <span class="label">HTTP_HOST:</span>
            <span class="value"><?php echo $_SERVER['HTTP_HOST'] ?? 'N/A'; ?></span>
        </div>

        <hr style="border-color: #00ff00;">
        <p style="color: #888;">
            ✅ Real IP: <?php echo $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['REMOTE_ADDR']; ?>
        </p>
    </div>
</body>
</html>
EOF

chown www-data:www-data /var/www/app/showip.php
chmod 644 /var/www/app/showip.php

echo "✅ Test page created: /var/www/app/showip.php"

# ===== STEP 5: VERIFY AND RELOAD =====
echo "[5/5] Verifying and reloading nginx..."

nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Config error! Restoring backup..."
    mv /etc/nginx/sites-available/app.k02.com.bak-soal14 /etc/nginx/sites-available/app.k02.com
    exit 1
fi

echo "✅ Config valid"

service nginx reload

if [ $? -eq 0 ]; then
    echo "✅ Nginx reloaded successfully"
else
    echo "❌ Nginx reload failed!"
    exit 1
fi

echo ""
echo "✅ SOAL 14: REAL IP LOGGING SETUP COMPLETE!"
echo ""
```

### UJI
#### di semua host kecuali Vingilot (contoh: Earendil)
`curl http://www.k02.com/app/showip.php`<br>
<img width="569" height="870" alt="image" src="https://github.com/user-attachments/assets/40e3f036-dc21-4da1-a0e7-4985fef1ec92" />

#### Vingilot
`tail -5 /var/log/nginx/app.k02.com.access.log`<br>
<img width="1561" height="142" alt="image" src="https://github.com/user-attachments/assets/2c9650e6-ef4c-4dc7-a4c8-e350b4e83976" />

## Soal_15 
Pelabuhan diuji gelombang kecil, salah satu klien yakni Elrond menjadi penguji dan menggunakan ApacheBench (ab) untuk membombardir http://www.<xxxx>.com/app/ dan http://www.<xxxx>.com/static/ melalui hostname kanonik. Untuk setiap endpoint lakukan 500 request dengan concurrency 10, dan rangkum hasil dalam tabel ringkas.

### SCRIPT 
#### Elrond
```
#!/bin/bash
# =============================================
# SOAL 15: LOAD TESTING — ELROND (DNS FIX)
# =============================================

echo "=== SOAL 15: LOAD TESTING (ELROND) ==="

# Fix DNS - IP yang benar
echo "Fixing DNS..."
cat > /etc/resolv.conf <<'EOF'
search k02.com
nameserver 192.212.3.11
nameserver 192.212.3.12
nameserver 192.168.122.1
EOF

sleep 2

# Install ApacheBench
apt update -y && apt install -y apache2-utils

# Create results directory
mkdir -p /root/benchmark_results
cd /root/benchmark_results

# Test 1: /app/
echo ""
echo "=========================================="
echo "TEST 1: /app/ (500 requests, concurrency 10)"
echo "=========================================="
ab -n 500 -c 10 http://www.k02.com/app/ > app_benchmark.txt 2>&1
echo "✅ Test 1 completed"

# Test 2: /static/
echo ""
echo "=========================================="
echo "TEST 2: /static/ (500 requests, concurrency 10)"
echo "=========================================="
ab -n 500 -c 10 http://www.k02.com/static/ > static_benchmark.txt 2>&1
echo "✅ Test 2 completed"

# Extract metrics
APP_COMPLETE=$(grep "Complete requests:" app_benchmark.txt | awk '{print $3}')
APP_FAILED=$(grep "Failed requests:" app_benchmark.txt | awk '{print $3}')
APP_RPS=$(grep "Requests per second:" app_benchmark.txt | awk '{print $4}' | head -1)
APP_TIME=$(grep "Time per request:" app_benchmark.txt | awk '{print $4}' | head -1)

STATIC_COMPLETE=$(grep "Complete requests:" static_benchmark.txt | awk '{print $3}')
STATIC_FAILED=$(grep "Failed requests:" static_benchmark.txt | awk '{print $3}')
STATIC_RPS=$(grep "Requests per second:" static_benchmark.txt | awk '{print $4}' | head -1)
STATIC_TIME=$(grep "Time per request:" static_benchmark.txt | awk '{print $4}' | head -1)

# Display summary
echo ""
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
printf "%-30s | %-15s | %-15s\n" "Metric" "/app/" "/static/"
echo "----------------------------------------------------------------"
printf "%-30s | %-15s | %-15s\n" "Complete requests" "$APP_COMPLETE" "$STATIC_COMPLETE"
printf "%-30s | %-15s | %-15s\n" "Failed requests" "$APP_FAILED" "$STATIC_FAILED"
printf "%-30s | %-15s | %-15s\n" "Requests/sec" "$APP_RPS" "$STATIC_RPS"
printf "%-30s | %-15s | %-15s\n" "Time/request (ms)" "$APP_TIME" "$STATIC_TIME"
echo ""

echo "✅ Results saved in /root/benchmark_results/"
```

### UJI
```
cd /root/benchmark_results/
cat app_benchmark.txt
cat comparison_table.txt
cat static_benchmark.txt
cat view_results.sh
```
<img width="500" height="605" alt="image" src="https://github.com/user-attachments/assets/0d13c191-ebde-44ae-98ec-9ef3cc6969cb" />
<img width="511" height="534" alt="image" src="https://github.com/user-attachments/assets/6291185f-18ed-41f9-89c3-f9e90cce35d7" /> <br>
<img width="410" height="544" alt="image" src="https://github.com/user-attachments/assets/348dde67-b158-4b24-9976-3bcee2979654" />
<img width="465" height="651" alt="image" src="https://github.com/user-attachments/assets/6981fdbb-b5d4-4e30-aad4-1584333ead04" />





## Soal_16
Badai mengubah garis pantai. Ubah A record lindon.<xxxx>.com ke alamat baru (ubah IP paling belakangnya saja agar mudah), naikkan SOA serial di Tirion (ns1) dan pastikan Valmar (ns2) tersinkron, karena static.<xxxx>.com adalah CNAME → lindon.<xxxx>.com, seluruh akses ke static.<xxxx>.com mengikuti alamat baru, tetapkan TTL = 30 detik untuk record yang relevan dan verifikasi tiga momen yakni sebelum perubahan (mengembalikan alamat lama), sesaat setelah perubahan namun sebelum TTL kedaluwarsa (masih alamat lama karena cache), dan setelah TTL kedaluwarsa (beralih ke alamat baru).

## Soal_17 
Andaikata bumi bergetar dan semua tertidur sejenak, mereka harus bangkit sendiri. Pastikan layanan inti bind9 di ns1/ns2, nginx di Sirion/Lindon, dan PHP-FPM di Vingilot autostart saat reboot, lalu verifikasi layanan kembali menjawab sesuai fungsinya.

## Soal_18
Sang musuh memiliki banyak nama. Tambahkan melkor.<xxxx>.com sebagai record TXT berisi “Morgoth (Melkor)” dan tambahkan morgoth.<xxxx>.com sebagai CNAME → melkor.<xxxx>.com, verifikasi query TXT terhadap melkor dan bahwa query ke morgoth mengikuti aliasnya.

## Soal_19
Pelabuhan diperluas bagi para pelaut. Tambahkan havens.<xxxx>.com sebagai CNAME → www.<xxxx>.com, lalu akses layanan melalui hostname tersebut dari dua klien berbeda untuk memastikan resolusi dan rute aplikasi berfungsi.

## Soal_20
Kisah ditutup di beranda Sirion. Sediakan halaman depan bertajuk “War of Wrath: Lindon bertahan” yang memuat tautan ke /app dan /static. Pastikan seluruh klien membuka beranda dan menelusuri kedua tautan tersebut menggunakan hostname (mis. www.<xxxx>.com), bukan IP address.

