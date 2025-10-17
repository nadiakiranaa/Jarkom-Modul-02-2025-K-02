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
