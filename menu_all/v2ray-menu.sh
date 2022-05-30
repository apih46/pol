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


x="ok"
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m                  ⇱ XRAY MENU ⇲                   \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

rekk='XRAY'
kjj='xray'
else
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m                  ⇱ V2RAY MENU ⇲                  \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

rekk='V2RAY'
kjj='v2ray'
fi
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
chck_pid(){
	PID=`ps -ef |grep -v grep | grep $kjj |awk '{print $2}'`
}
menu_sts(){
	if [[ -e /usr/bin/$kjj ]]; then
		chck_pid
		if [[ ! -z "${PID}" ]]; then
			echo -e "Current status: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Running${Font_color_suffix}"
		else
			echo -e "Current status: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Not Running${Font_color_suffix}"
		fi
	#	cd "${ssr_folder}"
	else
		echo -e "Current status: ${Red_font_prefix}Not Installed${Font_color_suffix}"
	fi
}

while true $x != "ok"
do
cek=/home/shws
if [[ -f "$cek" ]]; then
sts="\033[1;32m◉ \033[0m"
else
sts="\033[1;31m○ \033[0m"
fi

menu_sts
echo -e "
[\033[0;32m01\033[0m] • Create $rekk Vmess Websocket Account
[\033[0;32m02\033[0m] • Deleting $rekk Vmess Websocket Account
[\033[0;32m03\033[0m] • Extending $rekk Vmess Account Active Life
[\033[0;32m04\033[0m] • Check User Login $rekk

\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m05\033[0m] • Create $rekk Vless Websocket Account
[\033[0;32m06\033[0m] • Deleting $rekk Vless Websocket Account
[\033[0;32m07\033[0m] • Extending $rekk Vless Account Active Life
[\033[0;32m08\033[0m] • Check User Login $rekk

\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m09\033[0m] • Create Vless TCP XTLS Account
[\033[0;32m10\033[0m] • Deleting Vless TCP XTLS Account
[\033[0;32m11\033[0m] • Extending Vless TCP XTLS Account
[\033[0;32m12\033[0m] • Chek User Login XTLS"
if [[ "$rekk" = "V2RAY" ]]; then
echo -e "
\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m13\033[0m] • Create VMess Grpc Account
[\033[0;32m14\033[0m] • Deleting Vless Grpc Account
[\033[0;32m15\033[0m] • Extending Vless Grpc Account
[\033[0;32m16\033[0m] • Chek User Login Grpc"
elif [[ "$rekk" = "XRAY" ]]; then
echo -e "
\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m21\033[0m] • Create VMess Grpc Account
[\033[0;32m22\033[0m] • Deleting VMess Grpc Account
[\033[0;32m23\033[0m] • Extending VMess Grpc Account
[\033[0;32m24\033[0m] • Chek User Login Grpc

\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m25\033[0m] • Create Vless Grpc Account
[\033[0;32m26\033[0m] • Deleting Vless Grpc Account
[\033[0;32m27\033[0m] • Extending Vless Grpc Account
[\033[0;32m28\033[0m] • Chek User Login Grpc

\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m

[\033[0;32m29\033[0m] • Create Trojan Grpc Account
[\033[0;32m30\033[0m] • Deleting Trojan Grpc Account
[\033[0;32m31\033[0m] • Extending Trojan Grpc Account
[\033[0;32m32\033[0m] • Chek User Login Grpc"
fi
echo -e "
[00] • Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   add-ws
   break
   ;;
   2 | 02)
   clear
   del-ws 
   break
   ;;
   3 | 03)
   clear
   renew-ws
   break
   ;;
   4 | 04)
   clear
   cek-ws
   break
   ;;
   5 | 05)
   clear
   add-vless
   break
   ;;
   6 | 06)
   clear
   del-vless
   break
   ;;
   7 | 07)
   clear
   renew-vless
   break
   ;;
   8 | 08)
   clear
   cek-vless
   break
   ;;
   9 | 09)
   clear
   addxtls
   break
   ;;
   10)
   clear
   delxtls
   break
   ;;
   11)
   clear
   renewxtls
   break
   ;;
   12)
   clear
   cekxtls
   break
   ;;
   13)
   clear
   add-grpc
   break
   ;;
   14)
   clear
   del-grpc
   break
   ;;
   15)
   clear
   renew-grpc
   break
   ;;
   16)
   clear
   cek-grpc
   break
   ;;
   21)
   clear
   add-grws
   break
   ;;
   22)
   clear
   del-grws
   break
   ;;
   23)
   clear
   renew-grws
   break
   ;;
   24)
   clear
   cek-grws
   break
   ;;
   25)
   clear
   add-grvl
   break
   ;;
   26)
   clear
   del-grvl
   break
   ;;
   27)
   clear
   renew-grvl
   break
   ;;
   28)
   clear
   cek-grvl
   break
   ;;
   29)
   clear
   add-grtr
   break
   ;;
   30)
   clear
   del-grtr
   break
   ;;
   31)
   clear
   renew-grtr
   break
   ;;
   32)
   clear
   cek-grtr
   break
   ;;
   0 | 00)
   clear
   menu
   break
   ;;
   *)
   clear
esac
done
#fim