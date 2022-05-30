#!/bin/bash
lsof -i:80
trojango=`trojan-go -version | grep -w "Trojan-Go" | awk 'NR==1 {print $2}'`