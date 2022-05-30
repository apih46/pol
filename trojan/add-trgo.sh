#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/apih46/pol/main/skkkk > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/apih46/pol/main/skkkk | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/apih46/pol/main/skkkk | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi

clear
trgo="$(cat ~/log-install.txt | grep -w "Trojan Go" | cut -d: -f2|sed 's/ //g')"
pekok=$(curl -sS ipv4.icanhazip.com)
source /var/lib/scrz-prem/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo -e "\E[44;1;39m       ⇱ TROJAN-GO ACCOUNT ⇲       \E[0m"
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		read -rp "User : " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/trojan-go/akun.conf | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo -e "\E[44;1;39m       ⇱ TROJAN-GO ACCOUNT ⇲       \E[0m"
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			read -n 1 -s -r -p "Press any key to back on menu"
			trojan-menu
		fi
	done
x="ok"

bugdigi=/root/.ctech/.kumbang/digi
bugumo=/root/.ctech/.kumbang/umobile
bugmaxis=/root/.ctech/.kumbang/maxis
bugunifi=/root/.ctech/.kumbang/unifi
bugyodoo=/root/.ctech/.kumbang/yodoo
bugcelcom=/root/.ctech/.kumbang/celcom
digi=$(sed -n '1 p' $bugdigi | cut -d' ' -f1)
umo=$(sed -n '1 p' $bugumo | cut -d' ' -f1)
maxis=$(sed -n '1 p' $bugmaxis | cut -d' ' -f1)
unifi=$(sed -n '1 p' $bugunifi | cut -d' ' -f1)
yodoo=$(sed -n '1 p' $bugyodoo | cut -d' ' -f1)
celcom=$(sed -n '1 p' $bugcelcom | cut -d' ' -f1)

while true $x != "ok"
do
echo "1. DIGI"
echo "2. UMOBILE"
echo "3. MAXIS"
echo "4. UNIFI"
echo "5. YODOO"
echo "6. CELCOM"
echo -ne "Input your choice : "; read list
case "$list" in 
   1) bug="$digi";break;;
   2) bug="$umo";break;;
   3) bug="$maxis";break;;
   4) bug="$unifi";break;;
   5) bug="$yodoo";break;;
   6) bug="$celcom";break;;
esac
done


uuidR=$(cat /proc/sys/kernel/random/uuid)
uuid=$(cat /etc/trojan-go/idtrojango)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/"'""$uuid""'"$/a\,"'""$uuidR""'"' /etc/trojan-go/config.json
systemctl restart trojan-go >/dev/null 2>&1
echo -e "### $user $exp $uuidR" | tee -a /etc/trojan-go/akun.conf
linktrgo="trojan-go://${uuidR}@${domain}:${trgo}/?sni=${bug}&type=ws&host=${domain}&path=/scvps&encryption=none#${user}"
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-user.log
echo -e "\E[44;1;39m       ⇱ TROJAN-GO ACCOUNT ⇲       \E[0m" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-user.log
echo -e "Remarks : ${user}" | tee -a /etc/log-create-user.log
echo -e "IP : ${pekok}" | tee -a /etc/log-create-user.log
echo -e "Host : ${domain}" | tee -a /etc/log-create-user.log
echo -e "port : ${trgo}" | tee -a /etc/log-create-user.log
echo -e "Key : ${uuidR}" | tee -a /etc/log-create-user.log
echo -e "Network : ws" | tee -a /etc/log-create-user.log
echo -e "Path : /scvps" | tee -a /etc/log-create-user.log
echo -e "link : ${linktrgo}" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-user.log
echo -e "Expired On : $exp" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "Press any key to back on menu"

trojan-menu
