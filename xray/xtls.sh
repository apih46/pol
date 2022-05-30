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
yell='\e[1;33m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
exit 0
fi

if [ -f /etc/v2ray/domain ]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$(cat /etc/xray/domain)
fi

[[ ! -d /usr/bin/xray ]] && {
archAffix(){
    case "${1:-"$(uname -m)"}" in
        i686|i386)
            echo '32'
        ;;
        x86_64|amd64)
            echo '64'
        ;;
        armv5tel)
            echo 'arm32-v5'
        ;;
        armv6l)
            echo 'arm32-v6'
        ;;
        armv7|armv7l)
            echo 'arm32-v7a'
        ;;
        armv8|aarch64)
            echo 'arm64-v8a'
        ;;
        *mips64le*)
            echo 'mips64le'
        ;;
        *mips64*)
            echo 'mips64'
        ;;
        *mipsle*)
            echo 'mipsle'
        ;;
        *mips*)
            echo 'mips'
        ;;
        *s390x*)
            echo 's390x'
        ;;
        ppc64le)
            echo 'ppc64le'
        ;;
        ppc64)
            echo 'ppc64'
        ;;
        riscv64)
            echo 'riscv64'
        ;;
        *)
            return 1
        ;;
    esac
	return 0
}

rm -rf /usr/bin/xray
unamee=$(archAffix)
mkdir -p /usr/bin/xray
cd /usr/bin/xray
wget -q -O /usr/bin/xray/x.zip https://github.com/XTLS/Xray-core/releases/download/v1.4.2/Xray-linux-${unamee}.zip
unzip -o x.zip > /dev/null 2>&1
rm -f x.zip
cd
}

mkdir -p /var/log/xtls && chown -R root:root /var/log/xtls
mkdir -p /usr/local/etc/xtls

cat> /usr/local/etc/xtls/config.json << END
{
  "log": {
    "access": "/var/log/xtls/access.log",
    "error": "/var/log/xtls/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$(cat /proc/sys/kernel/random/uuid)",
            "flow": "xtls-rprx-direct"
#vlessXTLS
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 80
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "tcpSettings": {},
        "kcpSettings": {},
        "wsSettings": {},
        "httpSettings": {},
        "quicSettings": {},
        "grpcSettings": {},
        "xtlsSettings": {
          "certificates": [
            {
              "certificateFile": "/root/.acme.sh/${domain}_ecc/fullchain.cer",
              "keyFile": "/root/.acme.sh/${domain}_ecc/${domain}.key"
            }
          ],
          "alpn": [
            "http/1.1"
          ]
        }
      },
      "domain": "${domain}"
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
END

cat <<EOF> /etc/systemd/system/xtls.service
[Unit]
Description=XRAY XTLS Service
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/xray/xray -config /usr/local/etc/xtls/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload > /dev/null 2>&1
systemctl enable xtls > /dev/null 2>&1
systemctl restart xtls > /dev/null 2>&1

wget -q -O /usr/bin/addxtls "https://raw.githubusercontent.com/apih46/pol/main/xray/add.sh" && chmod +x /usr/bin/addxtls
wget -q -O /usr/bin/delxtls "https://raw.githubusercontent.com/apih46/pol/main/xray/del.sh" && chmod +x /usr/bin/delxtls
wget -q -O /usr/bin/cekxtls "https://raw.githubusercontent.com/apih46/pol/main/xray/chk.sh" && chmod +x /usr/bin/cekxtls
wget -q -O /usr/bin/renewxtls "https://raw.githubusercontent.com/apih46/pol/main/xray/rnw.sh" && chmod +x /usr/bin/renewxtls
wget -q -O /usr/bin/portxtls "https://raw.githubusercontent.com/apih46/pol/main/xray/pxt.sh" && chmod +x /usr/bin/portxtls
