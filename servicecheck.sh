#!/bin/bash

#systemctl is-active --quiet cups.service && echo -e "${GREEN}---------- Systemd ok ----------"

RED='\033[0;31m'
GREEN='\033[0;32m'

i=$(ps -eaf | grep -i cups | sed '/^$/d' | wc -l); echo $i
case $i in
    0) echo "The mysql service is 'not running'.";;
    1) echo "The mysql Service has 'failed'. You may need to restart the service";;
    2) echo -e "${GREEN}The mysql service is 'running'. No problems detected.";;
esac