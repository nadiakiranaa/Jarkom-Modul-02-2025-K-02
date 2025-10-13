##Verifikasi Zone Transfer
#Buat dan jalankan script berikut dari salah satu host client (misal Earendil atau Círdan):
bash
#!/bin/bash
echo "=== Verifikasi Zone Transfer k02.com ==="
echo ""

echo "1. Serial Number di ns1 (Tirion):"
dig @192.212.3.11 k02.com SOA +short | awk '{print $3}'

echo ""
echo "2. Serial Number di ns2 (Valmar):"
dig @192.212.3.12 k02.com SOA +short | awk '{print $3}'

echo ""
echo "3. Test A Record di ns1:"
dig @192.212.3.11 earendil.k02.com +short
dig @192.212.3.11 lindon.k02.com +short

echo ""
echo "4. Test A Record di ns2:"
dig @192.212.3.12 earendil.k02.com +short
dig @192.212.3.12 lindon.k02.com +short

echo ""
echo "5. NS Records:"
dig @192.212.3.11 k02.com NS +short
dig @192.212.3.12 k02.com NS +short

echo ""
echo "=== Jika semua output SAMA, zone transfer BERHASIL! ==="

bash
chmod +x verify_zone.sh
./verify_zone.sh