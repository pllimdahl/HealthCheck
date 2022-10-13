#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "Checking versions:\n"

echo  "cinead-d `dpkg -s cinead-d | grep -i version`"
echo "cinead-p `dpkg -s cinead-p | grep -i version`"
echo "cinemataztic-config `dpkg -s cinemataztic-config | grep -i version`"
echo "cinemataztic-player `dpkg -s cinemataztic-player | grep -i version`"
echo -e "cinematazticio24 `dpkg -s cinematazticio24 | grep -i version`\n"

echo -e "checking services:\n"

i=$(ps -eaf | grep -i cinead-d | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinead-d service is not running.\n";;
    1) echo -e "${RED}The cinead-d Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinead-d service is running. No problems detected.\n";;
esac

i=$(ps -eaf | grep -i cinead-p | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinead-p service is not running.\n";;
    1) echo -e "${RED}The cinead-p Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinead-p service is running. No problems detected.\n";;
esac

i=$(ps -eaf | grep -i cinemataztic-player | sed '/^$/d' | wc -l); echo $i
case $i in
    0) 
    echo -e "${RED}The cinemataztic-player service is not running.\n";;
    1) 
    echo -e "${RED}The cinemataztic-player Service has failed. You may need to restart the service\n";;
    2) 
    echo -e "${GREEN}The cinemataztic-player service is running. No problems detected.\n";;
esac

i=$(ps -eaf | grep -i cinematazticio24 | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinematazticio24 service is not running.\n";;
    1) echo -e "${RED}The cinematazticio24 Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinematazticio24 service is running. No problems detected.\n";;
esac

ping -c1 api.cinemataztic.com > /dev/null
if [ $? -eq 0 ]
  then 
    echo -e "${NC}checking network:\n"
    echo -e "${GREEN}---------- API is reachable ----------\n" 
    exit 0
  else
    echo -e "${RED}----------API not reachable---------\n"
fi



