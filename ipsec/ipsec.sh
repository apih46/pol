#!/bin/bash
# Debian 9 & 10 64bit
# Ubuntu 18.04 & 20.04 bit
# ==================================================
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
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/apih46/pol/main/resources/ascii-home
echo "IPSEC"
echo "Progress..."
echo ""
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
echo -e "[ ${green}INFO${NC} ] Checking... "

VPN_IPSEC_PSK='myvpn'
NET_IFACE=$(ip -o $NET_IFACE -4 route show to default | awk '{print $5}');
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
source /etc/os-release
OS=$ID
ver=$VERSION_ID
sleep 1
echo -e "[ ${green}INFO${NC} ] VPN setup in progress... Please be patient."

# Create and change to working dir
mkdir -p /opt/src
cd /opt/src
sleep 1
echo -e "[ ${green}INFO${NC} ] Trying to auto discover IP of this server..."
PUBLIC_IP=$(curl -sS ifconfig.me);
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing packages required for the VPN..."
if [[ ${OS} == "centos" ]]; then
epel_url="https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm"
yum -y install epel-release || yum -y install "$epel_url" > /dev/null 2>&1l
sleep 1
echo -e "[ ${green}INFO${NC} ] Installing packages required for the VPN..."

REPO1='--enablerepo=epel'
REPO2='--enablerepo=*server-*optional*'
REPO3='--enablerepo=*releases-optional*'
REPO4='--enablerepo=PowerTools'

yum -y install nss-devel nspr-devel pkgconfig pam-devel \
  libcap-ng-devel libselinux-devel curl-devel nss-tools \
  flex bison gcc make ppp > /dev/null 2>&1

yum "$REPO1" -y install xl2tpd > /dev/null 2>&1


if [[ $ver == '7' ]]; then
  yum -y install systemd-devel iptables-services > /dev/null 2>&1
  yum "$REPO2" "$REPO3" -y install libevent-devel fipscheck-devel > /dev/null 2>&1
elif [[ $ver == '8' ]]; then
  yum "$REPO4" -y install systemd-devel libevent-devel fipscheck-devel > /dev/null 2>&1
fi
else
apt install openssl iptables iptables-persistent -y > /dev/null 2>&1
jembs="libnss3-dev libnspr4-dev pkg-config \
  libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev \
  libcurl4-nss-dev flex bison gcc make libnss3-tools \
  libevent-dev ppp xl2tpd pptpd"
if ! dpkg -s $jembs >/dev/null 2>&1; then
 apt install -y $jembs >/dev/null 2>&1
fi
fi

SWAN_VER=3.32
swan_file="libreswan-$SWAN_VER.tar.gz"
swan_url1="https://github.com/libreswan/libreswan/archive/v$SWAN_VER.tar.gz"
swan_url2="https://download.libreswan.org/$swan_file"
if ! { wget -q -t 3 -T 30 -nv -O "$swan_file" "$swan_url1" || wget -q -t 3 -T 30 -nv -O "$swan_file" "$swan_url2"; }; then
  exit 1
fi
/bin/rm -rf "/opt/src/libreswan-$SWAN_VER" > /dev/null 2>&1
tar xzf "$swan_file" && /bin/rm -f "$swan_file" > /dev/null 2>&1
cd "libreswan-$SWAN_VER" || exit 1
cat > Makefile.inc.local <<'EOF'
WERROR_CFLAGS = -w
USE_DNSSEC = false
USE_DH2 = true
USE_DH31 = false
USE_NSS_AVA_COPY = true
USE_NSS_IPSEC_PROFILE = false
USE_GLIBC_KERN_FLIP_HEADERS = true
EOF
if ! grep -qs IFLA_XFRM_LINK /usr/include/linux/if_link.h; then
  echo "USE_XFRM_INTERFACE_IFLA_HEADER = true" >> Makefile.inc.local
fi
if [[ ${OS} == "debian" ]]; then
#if [ "$(packaging/utils/lswan_detect.sh init)" = "systemd" ]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Debian packages detected..."
  apt-get -y install libsystemd-dev > /dev/null 2>&1
#  fi
elif [[ ${OS} == "ubuntu" ]]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Ubuntu packages detected..."
#if [ "$(packaging/utils/lswan_detect.sh init)" = "systemd" ]; then
  apt-get -y install libsystemd-dev > /dev/null 2>&1
#fi
fi

if [ ! -d /usr/local/libexec/ipsec ]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Compiling and installing Libreswan..."
NPROCS=$(grep -c ^processor /proc/cpuinfo)
[ -z "$NPROCS" ] && NPROCS=1
make "-j$((NPROCS))" -s base > /dev/null 2>&1 && make -s install-base > /dev/null 2>&1
else
sleep 1
echo -e "[ ${green}INFO${NC} ] Skip compiling because already installed..."
fi

cd /opt/src || exit 1 > /dev/null 2>&1
/bin/rm -rf "/opt/src/libreswan-$SWAN_VER" > /dev/null 2>&1
if ! /usr/local/sbin/ipsec --version 2>/dev/null | grep -qF "$SWAN_VER"; then
  #exiterr "Libreswan $SWAN_VER failed to build." 2>/dev/null
  echo -ne
fi
sleep 1
echo -e "[ ${green}INFO${NC} ] Creating VPN configuration..."

L2TP_NET=192.168.42.0/24
L2TP_LOCAL=192.168.42.1
L2TP_POOL=192.168.42.10-192.168.42.250
XAUTH_NET=192.168.43.0/24
XAUTH_POOL=192.168.43.10-192.168.43.250
DNS_SRV1=8.8.8.8
DNS_SRV2=8.8.4.4
DNS_SRVS="\"$DNS_SRV1 $DNS_SRV2\""
[ -n "$VPN_DNS_SRV1" ] && [ -z "$VPN_DNS_SRV2" ] && DNS_SRVS="$DNS_SRV1"

# Create IPsec config
cat > /etc/ipsec.conf <<EOF
version 2.0

config setup
  virtual-private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:!$L2TP_NET,%v4:!$XAUTH_NET
  protostack=netkey
  interfaces=%defaultroute
  uniqueids=no

conn shared
  left=%defaultroute
  leftid=$PUBLIC_IP
  right=%any
  encapsulation=yes
  authby=secret
  pfs=no
  rekey=no
  keyingtries=5
  dpddelay=30
  dpdtimeout=120
  dpdaction=clear
  ikev2=never
  ike=aes256-sha2,aes128-sha2,aes256-sha1,aes128-sha1,aes256-sha2;modp1024,aes128-sha1;modp1024
  phase2alg=aes_gcm-null,aes128-sha1,aes256-sha1,aes256-sha2_512,aes128-sha2,aes256-sha2
  sha2-truncbug=no

conn l2tp-psk
  auto=add
  leftprotoport=17/1701
  rightprotoport=17/%any
  type=transport
  phase2=esp
  also=shared

conn xauth-psk
  auto=add
  leftsubnet=0.0.0.0/0
  rightaddresspool=$XAUTH_POOL
  modecfgdns=$DNS_SRVS
  leftxauthserver=yes
  rightxauthclient=yes
  leftmodecfgserver=yes
  rightmodecfgclient=yes
  modecfgpull=yes
  xauthby=file
  ike-frag=yes
  cisco-unity=yes
  also=shared

include /etc/ipsec.d/*.conf
EOF

if uname -m | grep -qi '^arm'; then
  if ! modprobe -q sha512; then
    sed -i '/phase2alg/s/,aes256-sha2_512//' /etc/ipsec.conf
  fi
fi

# Specify IPsec PSK
cat > /etc/ipsec.secrets <<EOF
%any  %any  : PSK "$VPN_IPSEC_PSK"
EOF

# Create xl2tpd config
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[global]
port = 1701

[lns default]
ip range = $L2TP_POOL
local ip = $L2TP_LOCAL
require chap = yes
refuse pap = yes
require authentication = yes
name = l2tpd
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF

# Set xl2tpd options
cat > /etc/ppp/options.xl2tpd <<EOF
+mschap-v2
ipcp-accept-local
ipcp-accept-remote
noccp
auth
mtu 1280
mru 1280
proxyarp
lcp-echo-failure 4
lcp-echo-interval 30
connect-delay 5000
ms-dns $DNS_SRV1
EOF

if [ -z "$VPN_DNS_SRV1" ] || [ -n "$VPN_DNS_SRV2" ]; then
cat >> /etc/ppp/options.xl2tpd <<EOF
ms-dns $DNS_SRV2
EOF
fi

# Create VPN credentials
cat > /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
cat > /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Create PPTP config
cat >/etc/pptpd.conf <<END
option /etc/ppp/options.pptpd
logwtmp
localip 192.168.41.1
remoteip 192.168.41.10-100
END
cat >/etc/ppp/options.pptpd <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
lock
nobsdcomp 
novj
novjccomp
nologfd
END
sleep 1
echo -e "[ ${green}INFO${NC} ] Updating IPTables rules..."
service fail2ban stop >/dev/null 2>&1
sudo iptables -t nat -I POSTROUTING -s 192.168.43.0/24 -o $NET_IFACE -j MASQUERADE
sudo iptables -t nat -I POSTROUTING -s 192.168.42.0/24 -o $NET_IFACE -j MASQUERADE
sudo iptables -t nat -I POSTROUTING -s 192.168.41.0/24 -o $NET_IFACE -j MASQUERADE
if [[ ${OS} == "centos" ]]; then
service iptables save > /dev/null 2>&1
sudo iptables-restore < /etc/sysconfig/iptables 
else
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save > /dev/null 2>&1
sudo netfilter-persistent reload > /dev/null 2>&1
fi
sleep 1
echo -e "[ ${green}INFO${NC} ] Enabling services on boot..."
systemctl enable xl2tpd > /dev/null 2>&1
systemctl enable ipsec > /dev/null 2>&1
systemctl enable pptpd > /dev/null 2>&1

for svc in fail2ban ipsec xl2tpd; do
  update-rc.d "$svc" enable >/dev/null 2>&1
  systemctl enable "$svc" >/dev/null 2>&1
done
sleep 1
echo -e "[ ${green}INFO${NC} ] Starting services..."
sysctl -e -q -p > /dev/null 2>&1
chmod 600 /etc/ipsec.secrets* /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*

mkdir -p /run/pluto > /dev/null 2>&1
service fail2ban restart > /dev/null 2>&1
service ipsec restart > /dev/null 2>&1
service xl2tpd restart > /dev/null 2>&1
wget -q -O /usr/bin/add-l2tp https://raw.githubusercontent.com/apih46/pol/main/ipsec/add-l2tp.sh && chmod +x /usr/bin/add-l2tp
wget -q -O /usr/bin/del-l2tp https://raw.githubusercontent.com/apih46/pol/main/ipsec/del-l2tp.sh && chmod +x /usr/bin/del-l2tp
wget -q -O /usr/bin/add-pptp https://raw.githubusercontent.com/apih46/pol/main/ipsec/add-pptp.sh && chmod +x /usr/bin/add-pptp
wget -q -O /usr/bin/del-pptp https://raw.githubusercontent.com/apih46/pol/main/ipsec/del-pptp.sh && chmod +x /usr/bin/del-pptp
wget -q -O /usr/bin/renew-pptp https://raw.githubusercontent.com/apih46/pol/main/ipsec/renew-pptp.sh && chmod +x /usr/bin/renew-pptp
wget -q -O /usr/bin/renew-l2tp https://raw.githubusercontent.com/apih46/pol/main/ipsec/renew-l2tp.sh && chmod +x /usr/bin/renew-l2tp
wget -q -O /usr/bin/trial-pptp https://raw.githubusercontent.com/apih46/pol/main/ipsec/trial-pptp.sh && chmod +x /usr/bin/trial-pptp
wget -q -O /usr/bin/trial-l2tp https://raw.githubusercontent.com/apih46/pol/main/ipsec/trial-l2tp.sh && chmod +x /usr/bin/trial-l2tp

touch /var/lib/scrz-prem/data-user-l2tp > /dev/null 2>&1
touch /var/lib/scrz-prem/data-user-pptp > /dev/null 2>&1

wget -q -O /usr/bin/ipsec-menu "https://raw.githubusercontent.com/apih46/pol/main/menu_all/ipsec-menu.sh" && chmod +x /usr/bin/ipsec-menu

sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "L2TP / PPTP successfully installed.."
sleep 5
clear
rm -f /root/ipsec.sh
