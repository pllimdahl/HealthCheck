#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "\Starting Healthcheck\n"

echo -e "Checking Software versions:\n"

echo  "cinead-d `dpkg -s cinead-d | grep -i version`"
echo "cinead-p `dpkg -s cinead-p | grep -i version`"
echo "cinemataztic-config `dpkg -s cinemataztic-config | grep -i version`"
echo "cinemataztic-player `dpkg -s cinemataztic-player | grep -i version`"
echo -e "cinematazticio24 `dpkg -s cinematazticio24 | grep -i version`\n"

echo -e "checking service status:\n"

echo "cinead-d status:"
systemctl is-active cinead-d.service

echo "cinemataztic-player:"
systemctl is-active cinemataztic-player.service

echo "cinematazticio24:"
systemctl is-active cinematazticio24.service

echo -e "\nChecking screen and res\n"

sudo runuser - player -c 'export DISPLAY=:0 && xrandr | grep HDMI-0'

echo -e "\nChecking network:\n"

echo -e "IP and MAC: `hostname --ip-address`\n"

ping -c1 api.cinemataztic.com > /dev/null
if [ $? -eq 0 ]
  then 

    echo -e "${GREEN}---------- API is reachable ----------\n" 
    exit 0
  else
    echo -e "${RED}----------API not reachable---------\n"
fi
