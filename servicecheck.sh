#!/bin/bash

# MUCH better but requires sudo:

#echo "cups status:"
#systemctl is-active cups.service



echo -e "checking services:\n"

i=$(ps -eaf | grep -i cinead-d | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinead-d service is not running.\n";;
    1) echo -e "${RED}The cinead-d Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinead-d service is running. No problems detected.\n";;
esac

i=$(ps -eaf | grep -i cinemataztic-player | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinemataztic-player service is not running.\n";;
    1) echo -e "${RED}The cinemataztic-player Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinemataztic-player service is running. No problems detected.\n";;
esac

i=$(ps -eaf | grep -i cinematazticio24 | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The cinematazticio24 service is not running.\n";;
    1) echo -e "${RED}The cinematazticio24 Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The cinematazticio24 service is running. No problems detected.\n";;
esac