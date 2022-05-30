#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.me/ip);
echo "Checking VPS"
#EDIT IZIN


rekk='xray'


Sortt() {
#Vless
echo -n > /tmp/oth.txt
data=( `cat /usr/local/etc/xray/vnone.json | grep '^#&' | cut -d ' ' -f 2`);

for akun in "${data[@]}"
do
echo -n >> /tmp/$akun
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvlss.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $rekk | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access2.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
for lx in "${jum[@]}" 
do
echo "#!/bin/bash" >> /tmp/$akun
echo "iptables -A INPUT -s $lx -j DROP" >> /tmp/$akun
done
fi

jum2=$(cat /tmp/ipvlss.txt)
sed -i "/$jum2/d" /tmp/oth.txt > /dev/null 2>&1
done
echo "sleep 60" >> /tmp/$akun

data23=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep $rekk | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip2 in "${data23[@]}"
do
jum2=$(cat /var/log/xray/access2.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip2 | sort | uniq)
if [[ "$jum2" = "$ip2" ]]; then
echo "iptables -D INPUT -s $jum2 -j DROP" >> /tmp/$akun

fi
done

if [[ $(wc -l </tmp/$akun) -ge 6 ]] 
then
chmod +x /tmp/$akun
mv /tmp/$akun /etc/multi >/dev/null 2>&1

cat> /etc/cron.d/$akun <<END
SHELL=/bin/sh
PATH=/etc/multi:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
*/1 * * * * root /etc/multi/$akun
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

else
rm -f /etc/multi/$akun >/dev/null 2>&1
rm -f /etc/cron.d/$akun >/dev/null 2>&1
fi

rm -f /tmp/ipvlss.txt
rm -f /tmp/oth.txt
rm -f /tmp/$akun
done
}
sleep 1.5
Sortt

exp=$(date)
echo -e "Berhasil cek pada : ${exp}"