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
bugdigi=/root/.ctech/.kumbang/digi
bugumo=/root/.ctech/.kumbang/umobile
bugmaxis=/root/.ctech/.kumbang/maxis
bugunifi=/root/.ctech/.kumbang/unifi
bugyodoo=/root/.ctech/.kumbang/yodoo
bugcelcom=/root/.ctech/.kumbang/celcom
installed=/root/.ctech/.kumbang/install
done=$(cat $installed | grep -w "done" | wc -l)
if [[ ${done} == '1' ]]; then
    echo -ne "BUG DIGI : "
    read bug_digi
    echo "$bug_digi" >$bugdigi
    echo -ne "BUG UMOBILE : "
    read bug_digi
    echo "$bug_digi" >$bugumo
    echo -ne "BUG MAXIS : "
    read bug_digi
    echo "$bug_digi" >$bugmaxis
    echo -ne "BUG UNIFI : "
    read bug_digi
    echo "$bug_digi" >$bugunifi
    echo -ne "BUG YODOO : "
    read bug_digi
    echo "$bug_digi" >$bugyodoo
    echo -ne "BUG CELCOM : "
    read bug_digi
    echo "$bug_digi" >$bugcelcom

else
mkdir /root/.ctech
mkdir /root/.ctech/.kumbang
echo 'ctechdidik.me' >$bugdigi
echo 'ctechdidik.me' >$bugumo
echo 'ctechdidik.me' >$bugmaxis
echo 'ctechdidik.me' >$bugunifi
echo 'ctechdidik.me' >$bugyodoo
echo 'ctechdidik.me' >$bugcelcom
echo 'done' >$installed
clear
kumbang
fi

read -n 1 -s -r -p "Press any key to back on menu"
menu