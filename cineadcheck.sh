#!/bin/bash

#Define Veriables for Parameterize script

cinead_d_package=$1
cinead_p_package=$2

if [ $# -lt 2 ]; then
echo "no arguments"
exit 1
else
echo "Cinead_d_Package: $1"
echo "Cinead_p_Package: $2"

echo "Status for installed packages"
sleep 2
echo ""
echo "Cinead-d Package Status"
echo ""
dpkg -s $1 | grep Status
echo ""
echo "cinead-p Package Status"
echo ""
dpkg -s $2 | grep Status
echo ""
sleep 2
echo "Status for installed services"
echo ""
echo "Cinead-d Service Status"
echo ""
systemctl is-active $1
echo "********************************"
fi