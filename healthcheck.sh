#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "checking services:\n"

i=$(ps -eaf | grep -i cups | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo -e "${RED}The mysql service is not running.";;
    1) echo -e "${RED}The mysql Service has failed. You may need to restart the service\n";;
    2) echo -e "${GREEN}The mysql service is running. No problems detected.\n";;
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



