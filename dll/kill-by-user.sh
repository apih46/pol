#!/bin/bash

UserBy=$1
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log"
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure"
fi

if [[ ${1+x} ]]; then
cat $LOG | grep -i dropbear | grep -w "$UserBy" > /root/login-db.txt
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`)
for PID in "${proc[@]}"
do
cat /root/login-db.txt | grep "dropbear\[$PID\]" > /root/login-db-pid.txt;
NUM=`cat /root/login-db-pid.txt | wc -l`
USER=`cat /root/login-db-pid.txt | awk '{print $10}'`
IP=`cat /root/login-db-pid.txt | awk '{print $12}'`
kill -9 $PID
done
cat $LOG | grep -i sshd | grep -w "$UserBy" > /root/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`)
for PID in "${data[@]}"
do
cat /root/login-db.txt | grep "sshd\[$PID\]" > /root/login-db-pid.txt
NUM=`cat /root/login-db-pid.txt | wc -l`;
USER=`cat /root/login-db-pid.txt | awk '{print $9}'`
IP=`cat /root/login-db-pid.txt | awk '{print $11}'`
kill -9 $PID
done
else
echo -ne
fi