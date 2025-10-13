##A. Install ApacheBench di ELROND
bash
apt update
apt install -y apache2-utils

##B. Jalankan Load Testing
#1. Test ke /app/ (Web Dinamis - Vingilot)
bash
ab -n 500 -c 10 http://www.k02.com/app/ > /tmp/ab_app.txt
cat /tmp/ab_app.txt

#2. Test ke /static/ (Web Statis - Lindon)
bash
ab -n 500 -c 10 http://www.k02.com/static/ > /tmp/ab_static.txt
cat /tmp/ab_static.txt

##C. Ekstrak Hasil
Script Otomatis untuk Rangkum Hasil
bash
cat > /root/benchmark_summary.sh << 'EOF'
#!/bin/bash


echo "=========================================="
echo "   ApacheBench Load Testing Summary"
echo "   Client: $(hostname) ($(hostname -I | awk '{print $1}'))"
echo "=========================================="
echo ""


# Test /app/
echo "Testing http://www.k02.com/app/ ..."
ab -n 500 -c 10 -q http://www.k02.com/app/ > /tmp/ab_app.txt 2>&1


# Test /static/
echo "Testing http://www.k02.com/static/ ..."
ab -n 500 -c 10 -q http://www.k02.com/static/ > /tmp/ab_static.txt 2>&1


echo ""
echo "=========================================="
echo "                RESULTS TABLE"
echo "=========================================="
printf "%-20s | %-15s | %-15s\n" "Metric" "/app/" "/static/"
echo "--------------------------------------------------------"


# Extract data
APP_RPS=$(grep "Requests per second" /tmp/ab_app.txt | awk '{print $4}')
STATIC_RPS=$(grep "Requests per second" /tmp/ab_static.txt | awk '{print $4}')


APP_TIME=$(grep "Time per request.*mean" /tmp/ab_app.txt | head -1 | awk '{print $4}')
STATIC_TIME=$(grep "Time per request.*mean" /tmp/ab_static.txt | head -1 | awk '{print $4}')


APP_FAILED=$(grep "Failed requests" /tmp/ab_app.txt | awk '{print $3}')
STATIC_FAILED=$(grep "Failed requests" /tmp/ab_static.txt | awk '{print $3}')


APP_TOTAL=$(grep "Time taken for tests" /tmp/ab_app.txt | awk '{print $5}')
STATIC_TOTAL=$(grep "Time taken for tests" /tmp/ab_static.txt | awk '{print $5}')


APP_MIN=$(grep "min.*mean.*max" /tmp/ab_app.txt | awk '{print $2}')
APP_MAX=$(grep "min.*mean.*max" /tmp/ab_app.txt | awk '{print $4}')
STATIC_MIN=$(grep "min.*mean.*max" /tmp/ab_static.txt | awk '{print $2}')
STATIC_MAX=$(grep "min.*mean.*max" /tmp/ab_static.txt | awk '{print $4}')


# Print table
printf "%-20s | %-15s | %-15s\n" "Total Requests" "500" "500"
printf "%-20s | %-15s | %-15s\n" "Concurrency" "10" "10"
printf "%-20s | %-15s | %-15s\n" "Total Time (s)" "$APP_TOTAL" "$STATIC_TOTAL"
printf "%-20s | %-15s | %-15s\n" "Requests/sec" "$APP_RPS" "$STATIC_RPS"
printf "%-20s | %-15s | %-15s\n" "Time/req (ms)" "$APP_TIME" "$STATIC_TIME"
printf "%-20s | %-15s | %-15s\n" "Failed Requests" "$APP_FAILED" "$STATIC_FAILED"
printf "%-20s | %-15s | %-15s\n" "Min Response (ms)" "$APP_MIN" "$STATIC_MIN"
printf "%-20s | %-15s | %-15s\n" "Max Response (ms)" "$APP_MAX" "$STATIC_MAX"


echo "=========================================="
echo ""
echo "Detail reports saved:"
echo "  /tmp/ab_app.txt"
echo "  /tmp/ab_static.txt"
echo ""
EOF


chmod +x /root/benchmark_summary.sh
Jalankan Script
bash
/root/benchmark_summary.sh

##D. Contoh Output
==========================================
   ApacheBench Load Testing Summary
   Client: elrond (192.212.2.11)
==========================================


Testing http://www.k02.com/app/ ...
Testing http://www.k02.com/static/ ...


==========================================
                RESULTS TABLE
==========================================
Metric               | /app/           | /static/       
--------------------------------------------------------
Total Requests       | 500             | 500            
Concurrency          | 10              | 10             
Total Time (s)       | 2.456           | 1.234          
Requests/sec         | 203.58          | 405.19         
Time/req (ms)        | 49.12           | 24.68          
Failed Requests      | 0               | 0              
Min Response (ms)    | 25              | 15             
Max Response (ms)    | 156             | 89             
==========================================

##E. Lihat Detail (Opsional)
bash
# Detail /app/
cat /tmp/ab_app.txt
# Detail /static/
cat /tmp/ab_static.txt

##F. Monitoring di Backend (Opsional)
#Di Vingilot
bash
# Monitor real-time access log
tail -f /var/log/nginx/app.k02.com.access.log

#Di Lindon
bash
# Monitor real-time access log
tail -f /var/log/nginx/static.k02.com.access.log

#Di Sirion
bash
# Monitor proxy log
tail -f /var/log/nginx/sirion-proxy.access.log