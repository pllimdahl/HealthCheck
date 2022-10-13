#!/bin/bash


echo -e "Checking versions:\n"

echo  "cinead-d `dpkg -s cinead-d | grep -i version`"
echo "cinead-p `dpkg -s cinead-p | grep -i version`"
echo "cinemataztic-config `dpkg -s cinemataztic-config | grep -i version`"
echo "cinemataztic-player `dpkg -s cinemataztic-player | grep -i version`"
echo "cinematazticio24 `dpkg -s cinematazticio24 | grep -i version`"



