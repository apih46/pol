#!/bin/bash
#shadowsocks-libev obfs 
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
clear
source /etc/os-release
OS=$ID
ver=$VERSION_ID
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/apih46/pol/main/resources/ascii-home
echo "Shadowsocks-obfs"
echo "Progress..."
sleep 3
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted.."
else
red "Permission Denied!"
exit 0
fi
echo -e "
"
date
echo ""
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "

pkgs='build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake'
if ! dpkg -s $pkgs > /dev/null 2>&1; then
   sleep 1
   echo -e "[ ${green}INFO${NC} ] Common pkgs not installed... "
   sleep 3
   echo -e "[ ${green}INFO${NC} ] Installing common pkgs... "
   apt-get install --no-install-recommends $pkgs -y > /dev/null 2>&1
fi

pkgscommon='software-properties-common'
if ! dpkg -s $pkgscommon > /dev/null 2>&1; then
   apt-get install $pkgscommon -y > /dev/null 2>&1
fi

if [[ $OS == 'ubuntu' ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Ubuntu detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks $OS... "
apt install shadowsocks-libev -y > /dev/null 2>&1
apt install simple-obfs -y > /dev/null 2>&1
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 9 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "stretch-backports"` )
if [ "$detect" != "stretch-backports" ]; then
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi
else
touch /etc/apt/sources.list.d/stretch-backports.list
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list
fi

apt update -y > /dev/null 2>&1
apt -t stretch-backports install shadowsocks-libev -y > /dev/null 2>&1
apt -t stretch-backports install simple-obfs -y > /dev/null 2>&1
elif [[ "$ver" = "10" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian ver 10 detected... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing shadowsocks for $OS $ver ... "

if [ -f "/etc/apt/sources.list.d/buster-backports.list" ]; then
detect=( `cat /etc/apt/sources.list.d/buster-backports.list | grep -ow "buster-backports"` )
if [ "$detect" != "buster-backports" ]; then
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi
else
touch /etc/apt/sources.list.d/buster-backports.list
echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list.d/buster-backports.list
fi

apt update -y  > /dev/null 2>&1
apt -t buster-backports install shadowsocks-libev -y > /dev/null 2>&1
apt -t buster-backports install simple-obfs -y > /dev/null 2>&1
fi
fi

#Server konfigurasi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating config shadowsocks..."
cat > /etc/shadowsocks-libev/config.json <<END
{   
    "server":"0.0.0.0",
    "server_port":8488,
    "password":"tes",
    "timeout":60,
    "method":"aes-256-cfb",
    "fast_open":true,
    "nameserver":"8.8.8.8",
    "mode":"tcp_and_udp",
}
END

#mulai ~shadowsocks-libev~ server
sleep 1
echo -e "[ ${green}INFO${NC} ] Enable service on boot..."
systemctl enable shadowsocks-libev.service > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO${NC} ] Start service shadowsocks..."
systemctl start shadowsocks-libev.service > /dev/null 2>&1

#buat client config
cat > /etc/shadowsocks-libev.json <<END
{
    "server":"127.0.0.1",
    "server_port":8388,
    "local_port":1080,
    "password":"",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "mode":"tcp_and_udp",
    "fast_open":true,
    "plugin":"/usr/bin/obfs-local",
    "plugin_opts":"obfs=tls;failover=127.0.0.1:1443;fast-open"
}
END
chmod +x /etc/shadowsocks-libev.json

echo -e "">>"/etc/shadowsocks-libev/akun.conf"

sleep 1
echo -e "[ ${green}INFO${NC} ] Set iptables..."
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2443:3543 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2443:3543 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo ip6tables-save > /etc/ip6tables.up.rules

wget -q -O /usr/bin/add-ss "https://raw.githubusercontent.com/apih46/pol/main/shadowsocks/add-ss.sh" && chmod +x /usr/bin/add-ss
wget -q -O /usr/bin/del-ss "https://raw.githubusercontent.com/apih46/pol/main/shadowsocks/del-ss.sh" && chmod +x /usr/bin/del-ss
wget -q -O /usr/bin/cek-ss "https://raw.githubusercontent.com/apih46/pol/main/shadowsocks/cek-ss.sh" && chmod +x /usr/bin/cek-ss
wget -q -O /usr/bin/renew-ss "https://raw.githubusercontent.com/apih46/pol/main/shadowsocks/renew-ss.sh" && chmod +x /usr/bin/renew-ss
wget -q -O /usr/bin/trial-ss "https://raw.githubusercontent.com/apih46/pol/main/shadowsocks/trial-ss.sh" && chmod +x /usr/bin/trial-ss
wget -q -O /usr/bin/ss-menu "https://raw.githubusercontent.com/apih46/pol/main/menu_all/ss-menu.sh" && chmod +x /usr/bin/ss-menu

sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Shadowsock OBFS successfully installed.."
sleep 5
clear
rm -f /root/ss.sh
