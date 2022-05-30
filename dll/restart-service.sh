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
green='\e[1;32m'
yl='\033[1;33m'
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

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
rekk='xray'
else
rekk='v2ray'
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      • Restart ALL Service •      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

systemctl restart ohp-ssh
echo -e "[ ${green}ok${NC} ] Restarting ohp "
sleep 1
systemctl restart ohp-db
systemctl restart ohp-opn
systemctl restart stunnel4
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
sleep 1
systemctl restart wg-quick@wg0
echo -e "[ ${green}ok${NC} ] Restarting wireguard "
sleep 1
systemctl restart l2tpd
echo -e "[ ${green}ok${NC} ] Restarting l2tp "
sleep 1
systemctl restart accel-ppp
echo -e "[ ${green}ok${NC} ] Restarting sstp "
systemctl restart pptpd
echo -e "[ ${green}ok${NC} ] Restarting pptp "
sleep 1
systemctl restart trojan-go
echo -e "[ ${green}ok${NC} ] Restarting trojan go "
sleep 1
systemctl restart shadowsocks-libev
echo -e "[ ${green}ok${NC} ] Restarting shadowsokcs "
sleep 1
systemctl restart $rekk
echo -e "[ ${green}ok${NC} ] Restarting $rekk "
sleep 1
systemctl restart ssrmu
echo -e "[ ${green}ok${NC} ] Restarting shadowsocks-r "
sleep 1
systemctl restart dropbear
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
sleep 1
systemctl restart xtls
echo -e "[ ${green}ok${NC} ] Restarting xtls "
sleep 1
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
