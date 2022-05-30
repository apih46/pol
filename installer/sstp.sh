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
clear
MYIP=$(curl -sS ifconfig.me);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NIC=$(ip -o $ANU -4 route show to default | awk '{print $5}');

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'

curl -sS https://raw.githubusercontent.com/apih46/pol/main/resources/ascii-home
echo "SSTP"
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
sleep 3
sleep 1
source /etc/os-release
OS=$ID
ver=$VERSION_ID
if [[ $OS == 'ubuntu' ]]; then
if [[ "$ver" = "18.04" ]]; then
yoi=Ubuntu18
elif [[ "$ver" = "20.04" ]]; then
yoi=Ubuntu20
fi
elif [[ $OS == 'debian' ]]; then
if [[ "$ver" = "9" ]]; then
yoi=Debian9
elif [[ "$ver" = "10" ]]; then
yoi=Debian10
fi
fi

echo -e "[ ${green}INFO${NC} ] Checking... "
mkdir -p /home/sstp > /dev/null 2>&1
touch /home/sstp/sstp_account
touch /var/lib/scrz-prem/data-user-sstp

#detail nama perusahaan
country=ID
state=ID
locality=ID
organization=None
organizationalunit=None
commonname=None
email=sc@vipscript.vps
cd
sstppkgs='cmake gcc libpcre3-dev libssl-dev liblua5.1-0-dev ppp'
if ! dpkg -s $sstppkgs >/dev/null 2>&1; then

        echo -e "[ ${green}INFO${NC} ] Installing sstp packages..."
        apt-get install -y $sstppkgs >/dev/null 2>&1
        git clone https://github.com/accel-ppp/accel-ppp.git /opt/accel-ppp-code >/dev/null 2>&1
        mkdir -p /opt/accel-ppp-code/build >/dev/null 2>&1
        cd /opt/accel-ppp-code/build/
        cmake -DBUILD_IPOE_DRIVER=TRUE -DBUILD_VLAN_MON_DRIVER=TRUE -DCMAKE_INSTALL_PREFIX=/usr -DKDIR=/usr/src/linux-headers-`uname -r` -DLUA=TRUE -DCPACK_TYPE=$yoi ..
        make >/dev/null 2>&1
        cpack -G DEB >/dev/null 2>&1
        dpkg -i accel-ppp.deb >/dev/null 2>&1

fi
sleep 1
echo -e "[ ${green}INFO${NC} ] Setting config... "
mv /etc/accel-ppp.conf.dist /etc/accel-ppp.conf > /dev/null 2>&1
curl -sS "https://raw.githubusercontent.com/apih46/pol/main/sstp/accel.conf" | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/accel-ppp.conf
sed -i $MYIP2 /etc/accel-ppp.conf
chmod +x /etc/accel-ppp.conf
sleep 1
echo -e "[ ${green}INFO${NC} ] Enable & start accel-ppp services... "
systemctl enable accel-ppp > /dev/null 2>&1
systemctl restart accel-ppp > /dev/null 2>&1
#gen cert sstp
cd /home/sstp
sleep 1
echo -e "[ ${green}INFO${NC} ] Generating key... "
openssl genrsa -out ca.key 4096 > /dev/null 2>&1
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1
openssl genrsa -out server.key 4096 > /dev/null 2>&1
openssl req -new -key server.key -out ia.csr \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" > /dev/null 2>&1
openssl x509 -req -days 3650 -in ia.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt > /dev/null 2>&1
cp /home/sstp/server.crt /home/vps/public_html/server.crt
sleep 1
echo -e "[ ${green}INFO${NC} ] Setting iptables... "
sudo iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 444 -j ACCEPT
sudo iptables -I INPUT -m state --state NEW -m udp -p udp --dport 444 -j ACCEPT
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sleep 1
echo -e "[ ${green}INFO${NC} ] Reload netfilter... "
sudo netfilter-persistent save > /dev/null 2>&1
sudo netfilter-persistent reload > /dev/null 2>&1
#input perintah sstp
wget -q -O /usr/bin/add-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/add-sstp.sh" && chmod +x /usr/bin/add-sstp
wget -q -O /usr/bin/del-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/del-sstp.sh" && chmod +x /usr/bin/del-sstp
wget -q -O /usr/bin/cek-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/cek-sstp.sh" && chmod +x /usr/bin/cek-sstp
wget -q -O /usr/bin/renew-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/renew-sstp.sh" && chmod +x /usr/bin/renew-sstp
wget -q -O /usr/bin/trial-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/trial-sstp.sh" && chmod +x /usr/bin/trial-sstp
wget -q -O /usr/bin/port-sstp "https://raw.githubusercontent.com/apih46/pol/main/sstp/port-sstp.sh" && chmod +x /usr/bin/port-sstp
wget -q -O /usr/bin/sstp-menu "https://raw.githubusercontent.com/apih46/pol/main/menu_all/sstp-menu.sh" && chmod +x /usr/bin/sstp-menu

sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "
SSTP successfully installed..
"
sleep 5
clear
rm -f /root/sstp.sh
