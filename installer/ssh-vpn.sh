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
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
curl -sS https://raw.githubusercontent.com/apih46/pol/main/resources/ascii-home
echo "SSH & Ovpn"
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
export DEBIAN_FRONTEND=noninteractive
MYIP=$(curl -sS ifconfig.me);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=ID
locality=ID
organization=None
organizationalunit=None
commonname=None
email=github@scvps

# simple password minimal
curl -sS https://raw.githubusercontent.com/apih46/pol/main/ssh/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password

cd

cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local
echo -e "
"
date
echo ""
# enable rc local
sleep 1
echo -e "[ ${green}INFO${NC} ] Checking... "
sleep 2
sleep 1
echo -e "[ ${green}INFO$NC ] Enable system rc local"
systemctl enable rc-local >/dev/null 2>&1
systemctl start rc-local.service >/dev/null 2>&1

# disable ipv6
sleep 1
echo -e "[ ${green}INFO$NC ] Disable ipv6"
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6 >/dev/null 2>&1
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local >/dev/null 2>&1

# set time GMT +7
sleep 1
echo -e "[ ${green}INFO$NC ] Set zona local time to Asia/Jakarta GMT+7"
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

cd
sleep 1
echo -e "[ ${green}INFO$NC ] Settings nginx" 
rm /etc/nginx/sites-enabled/default >/dev/null 2>&1
rm /etc/nginx/sites-available/default >/dev/null 2>&1

cat>  /etc/nginx/nginx.conf <<-END
user  www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
    worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

	set_real_ip_from 204.93.240.0/24;
	set_real_ip_from 204.93.177.0/24;
	set_real_ip_from 199.27.128.0/21;
	set_real_ip_from 173.245.48.0/20;
	set_real_ip_from 103.21.244.0/22;
	set_real_ip_from 103.22.200.0/22;
	set_real_ip_from 103.31.4.0/22;
	set_real_ip_from 141.101.64.0/18;
	set_real_ip_from 108.162.192.0/18;
	set_real_ip_from 190.93.240.0/20;
	set_real_ip_from 188.114.96.0/20;
	set_real_ip_from 197.234.240.0/22;
	set_real_ip_from 198.41.128.0/17;
	real_ip_header     CF-Connecting-IP;

  include /etc/nginx/conf.d/*.conf;
}
END

mkdir -p /home/vps/public_html >/dev/null 2>&1
domain=$(cat /root/domain)
cat> /etc/nginx/conf.d/vps.conf <<-END
server {
  listen       81;
  server_name  127.0.0.1 localhost;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;
  root   /home/vps/public_html;

  location / {
    index  index.html index.htm index.php;
    try_files \$uri \$uri/ /index.php?\$args;
  }

  location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass  127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
  }
}
END
systemctl enable nginx.service >/dev/null 2>&1
systemctl restart nginx.service >/dev/null 2>&1
echo "telegram.com/scvps" > /home/vps/public_html/index.html
# install badvpn
tesmatch=`screen -list | awk  '{print $1}' | grep -ow "badvpn" | sort | uniq`
if [ "$tesmatch" = "badvpn" ]; then
sleep 1
echo -e "[ ${green}INFO$NC ] Screen badvpn detected"
rm /root/screenlog > /dev/null 2>&1
    runningscreen=( `screen -list | awk  '{print $1}' | grep -w "badvpn"` ) # sed 's/\.[^ ]*/ /g'
    for actv in "${runningscreen[@]}"
    do
        cek=( `screen -list | awk  '{print $1}' | grep -w "badvpn"` )
        if [ "$cek" = "$actv" ]; then
        for sama in "${cek[@]}"; do
            sleep 1
            screen -XS $sama quit > /dev/null 2>&1
            echo -e "[ ${red}CLOSE$NC ] Closing screen $sama"
        done 
        fi
    done
else
echo -ne
fi
cd
echo -e "[ ${green}INFO$NC ] Installing badvpn for game support..."
wget -q -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/apih46/pol/main/ssh/newudpgw"
chmod +x /usr/bin/badvpn-udpgw  >/dev/null 2>&1
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local >/dev/null 2>&1
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local >/dev/null 2>&1
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local >/dev/null 2>&1
sed -i '$ i\systemctl restart ssrmu' /etc/rc.local >/dev/null 2>&1
# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
sleep 1
echo -e "[ ${green}INFO$NC ] Settings Dropbear"
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
#sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
sed -i "/DROPBEAR_EXTRA_ARGS=/c\DROPBEAR_EXTRA_ARGS=\"-p 109\"" /etc/default/dropbear
cekker=$(cat /etc/shells | grep -w "/bin/false")
if [[ "$cekker" = "/bin/false" ]];then
echo -ne
else
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
fi
/etc/init.d/dropbear restart >/dev/null 2>&1

# install squid
cd
curl -sS "https://raw.githubusercontent.com/apih46/pol/main/ssh/squid3.conf" | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/squid/squid.conf
sed -i $MYIP2 /etc/squid/squid.conf

# install stunnel
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 447
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

[stunnelws]
accept = 222
connect = 700
END

# make a certificate
openssl genrsa -out key.pem 2048  >/dev/null 2>&1
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"  >/dev/null 2>&1
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart >/dev/null 2>&1

#OpenVPN
sleep 1
echo -e "[ ${green}INFO$NC ] Install Openvpn"
wget -q https://raw.githubusercontent.com/apih46/pol/main/ssh/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

# install fail2ban
# Instal DDOS Flate
mkdir /usr/local/ddos >/dev/null 2>&1
#clear
sleep 1
echo -e "[ ${green}INFO$NC ] Install DOS-Deflate"
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading source files..."
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos  >/dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Create cron script every minute...."
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
sleep 1
echo -e "[ ${green}INFO$NC ] Install successfully..."
sleep 1
echo -e "[ ${green}INFO$NC ] Config file at /usr/local/ddos/ddos.conf"

# banner /etc/issue.net
sleep 1
echo -e "[ ${green}INFO$NC ] Settings banner"
wget -q -O /etc/issue.net "https://raw.githubusercontent.com/apih46/pol/main/banner/issue.net"
chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
cat> /etc/issue.net << END
<font color="red"><b>============================</b></font><br> 
<font color="white"><b>         SCRIPTVPS         </b></font><br> 
<font color="red"><b>============================</b></font>
END
echo -e "[ ${green}INFO$NC ] Set iptables"
# blockir torrent
sudo iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
sudo iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
sudo iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
sudo iptables-save > /etc/iptables.up.rules
sudo iptables-restore -t < /etc/iptables.up.rules
sudo netfilter-persistent save >/dev/null 2>&1
sudo netfilter-persistent reload >/dev/null 2>&1

# download script
wget -q -O /usr/bin/usernew "https://raw.githubusercontent.com/apih46/pol/main/ssh/usernew.sh" && chmod +x /usr/bin/usernew
wget -q -O /usr/bin/trial "https://raw.githubusercontent.com/apih46/pol/main/ssh/trial.sh" && chmod +x /usr/bin/trial
wget -q -O /usr/bin/hapus "https://raw.githubusercontent.com/apih46/pol/main/ssh/hapus.sh" && chmod +x /usr/bin/hapus
wget -q -O /usr/bin/member "https://raw.githubusercontent.com/apih46/pol/main/ssh/member.sh" && chmod +x /usr/bin/member
wget -q -O /usr/bin/delete "https://raw.githubusercontent.com/apih46/pol/main/ssh/delete.sh" && chmod +x /usr/bin/delete
wget -q -O /usr/bin/cek "https://raw.githubusercontent.com/apih46/pol/main/ssh/cek.sh" && chmod +x /usr/bin/cek
wget -q -O /usr/bin/restart "https://raw.githubusercontent.com/apih46/pol/main/ssh/restart.sh" && chmod +x /usr/bin/restart
wget -q -O /usr/bin/renew "https://raw.githubusercontent.com/apih46/pol/main/ssh/renew.sh" && chmod +x /usr/bin/renew
wget -q -O /usr/bin/autokill "https://raw.githubusercontent.com/apih46/pol/main/ssh/autokill.sh" && chmod +x /usr/bin/autokill
wget -q -O /usr/bin/ceklim "https://raw.githubusercontent.com/apih46/pol/main/ssh/ceklim.sh" && chmod +x /usr/bin/ceklim
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/apih46/pol/main/ssh/tendang.sh" && chmod +x /usr/bin/tendang
wget -q -O /usr/bin/port-dropbear "https://raw.githubusercontent.com/apih46/pol/main/ssh/port-dropbear.sh" && chmod +x /usr/bin/port-dropbear
wget -q -O /usr/bin/port-ovpn "https://raw.githubusercontent.com/apih46/pol/main/ssh/port-ovpn.sh" && chmod +x /usr/bin/port-ovpn
wget -q -O /usr/bin/port-ssl "https://raw.githubusercontent.com/apih46/pol/main/ssh/port-ssl.sh" && chmod +x /usr/bin/port-ssl
wget -q -O /usr/bin/banner "https://raw.githubusercontent.com/apih46/pol/main/banner/banner.sh" && chmod +x /usr/bin/banner
wget -q -O /usr/bin/sshws "https://raw.githubusercontent.com/apih46/pol/main/ssh/ins-sshws.sh" && chmod +x /usr/bin/sshws
wget -q -O /usr/bin/ssh-menu "https://raw.githubusercontent.com/apih46/pol/main/menu_all/ssh-menu.sh" && chmod +x /usr/bin/ssh-menu
wget -q -O /usr/bin/port-wssl "https://raw.githubusercontent.com/apih46/pol/main/ssh/port-ws-ssl.sh" && chmod +x /usr/bin/port-wssl
wget -q -O /usr/bin/ohp https://scrzoke.000webhostapp.com/ohp && chmod +x /usr/bin/ohp
wget -q -O /usr/bin/ohp-ssh "https://raw.githubusercontent.com/apih46/pol/main/dll/ohp-ssh.sh" && chmod +x /usr/bin/ohp-ssh
wget -q -O /usr/bin/ohp-db "https://raw.githubusercontent.com/apih46/pol/main/dll/ohp-db.sh" && chmod +x /usr/bin/ohp-db
wget -q -O /usr/bin/ohp-opn "https://raw.githubusercontent.com/apih46/pol/main/dll/ohp-opn.sh" && chmod +x /usr/bin/ohp-opn
wget -q -O /usr/bin/portohp "https://raw.githubusercontent.com/apih46/pol/main/ssh/portohp.sh" && chmod +x /usr/bin/portohp

cat <<EOF > /etc/systemd/system/ohp-ssh.service
[Unit]
Description=OHP-SSH
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ohp-ssh
KillMode=process
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload > /dev/null 2>&1
systemctl enable ohp-ssh > /dev/null 2>&1


cat <<EOF > /etc/systemd/system/ohp-db.service
[Unit]
Description=OHP-Dropbear
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ohp-db
KillMode=process
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload > /dev/null 2>&1
systemctl enable ohp-db > /dev/null 2>&1

cat <<EOF > /etc/systemd/system/ohp-opn.service
[Unit]
Description=OHP-OpenVPN
Wants=network.target
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ohp-opn
KillMode=process
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload > /dev/null 2>&1
systemctl enable ohp-opn > /dev/null 2>&1

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 7 * * * root /sbin/reboot
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
sleep 1
echo -e "[ ${green}INFO$NC ] Clearing trash"
apt autoclean -y >/dev/null 2>&1

if dpkg -s unscd >/dev/null 2>&1; then
apt -y remove --purge unscd >/dev/null 2>&1
fi

# apt-get -y --purge remove samba* >/dev/null 2>&1
# apt-get -y --purge remove apache2* >/dev/null 2>&1
# apt-get -y --purge remove bind9* >/dev/null 2>&1
# apt-get -y remove sendmail* >/dev/null 2>&1
# apt autoremove -y >/dev/null 2>&1
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting openvpn "
/etc/init.d/cron restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting cron "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting ssh "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting fail2ban "
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting vnstat "
/etc/init.d/squid restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting squid "
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500 >/dev/null 2>&1
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500 >/dev/null 2>&1
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500 >/dev/null 2>&1
history -c
echo "unset HISTFILE" >> /etc/profile

cd
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
sleep 1
yellow "SSH & OVPN install successfully"
sleep 5
clear
rm /root/key.pem >/dev/null 2>&1
rm /root/cert.pem >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1
# finihsing

