#!/bin/bash

sudo echo -e "\n"
echo -e "\033[0;34m\nSTARTING HEALTH CHECK\n\033[0m"
echo -e "\033[0;36m\nCHECKING NVIDIA DRIVER:\n\033[0m"
if nvidia-smi &>/dev/null; then echo -e "\033[0;32mNVIDIA driver is installed and active.\n\033[0m"; else echo -e "\033[0;31mNVIDIA driver is not installed.\n\033[0m"; fi
echo -e "\033[0;36mSCREEN RES AND OUTPUT:\n\033[0m"

output=$(sudo runuser -l player -c 'export DISPLAY=:0 && xrandr')

# Check if a display is detected
if [[ $output == *"can't open display"* ]]; then
    echo -e "\033[0;31mError: No display detected.\033[0m"
    exit 1
fi

current_resolution=$(echo "$output" | grep -oP "current \K[0-9]+ x [0-9]+")
connected_source=$(echo "$output" | grep " connected" | awk '{print $1}')
current_refresh_rate=$(echo "$output" | grep -oP "\s+\K[0-9]+\.?[0-9]*\*")

# Check if the current resolution, connected source, and current refresh rate are found
if [[ -z "$current_resolution" ]]; then
    echo -e "\033[0;31mError: Current resolution not found.\033[0m"
fi

if [[ -z "$connected_source" ]]; then
    echo -e "\033[0;31mError: Connected source not found.\033[0m"
fi

if [[ -z "$current_refresh_rate" ]]; then
    echo -e "\033[0;31mError: Current refresh rate not found.\033[0m"
fi

echo -e "Connected Source: \033[0;33m$connected_source\033[0m"
echo -e "Current Resolution: \033[0;33m$current_resolution\033[0m"
echo -e "Current Refresh Rate: \033[0;33m${current_refresh_rate%\*} Hz\033[0m"

echo -e "\033[0;36m\nCHECKING SOUND:\n\033[0m"

output=$(sudo runuser -l player -c 'pacmd list-sinks')

# Check if the PulseAudio daemon is not running
if [[ $output == *"No PulseAudio daemon running, or not running as session daemon."* ]]; then
    echo -e "\033[0;31m$output\033[0m"
else

# tbh this next  awk part was entirely written by copilot and is beyond my bash scripting knowledge lol
# Use awk to parse the output and extract the required information
alsa_name=$(echo "$output" | awk '
    /[*] index:/ {           # Look for the line with "* index:"
        found=1              # Set a flag to start capturing lines
    }
    found && /alsa.name/ {   # If within a relevant block, look for "alsa.name"
        gsub(/^ +| +$/, "")  # Remove leading and trailing spaces
        print $0             # Print the alsa.name line
        exit                 # Exit after finding the alsa.name (assuming only one active index)
    }
')

# Replace "alsa.name =" with "Sound sink connected:"
alsa_name=$(echo "$alsa_name" | sed 's/alsa.name =//')
# Why doesnt this align the left like the rest???
echo -e "Sound sink connected: \033[0;33m$alsa_name\033[0m"
fi

echo -e "\033[0;36m\nCHECKING NETWORK:\n\033[0m"
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo -e "IP: \033[0;33m$(hostname -I | awk '{print $1}')\033[0m"
echo -e "MAC: \033[0;33m$(cat /sys/class/net/$INTERFACE/address)\033[0m"
curl -s --head --request GET http://api.cinemataztic.com --max-time 10 > /dev/null 2>&1 && echo -e "\033[0;32m\n---------- API is reachable ----------\n\033[0m" || echo -e "\033[0;31m\n---------- API not reachable ----------\n\033[0m"
echo -e "\033[0;36mCHECKING VERSIONS:\n\033[0m"

packages=("dch-p" "cinead-d" "cinead-p" "cinead-p" "cinegame-d" "cinegame-p" "cinecard-d" "cinecard-p" "cinematazticio24" "nodejs")

for package in "${packages[@]}"; do
    if dpkg -s "$package" &> /dev/null; then
        version=$(dpkg -s "$package" 2>/dev/null | grep -i version)
        echo -e "\033[0;32m$package $version\033[0m"
    else
        echo -e "\033[0;31m$package is NOT installed\033[0m"
    fi
done

echo -e "\033[0;36m\nCHECKING SERVICES:\n\033[0m"

for service in dch-p.service cinead-d.service cinegame-d.service cinecard-d.service cinematazticio24.service; do
    status=$(systemctl is-active $service)
    if [[ $status == "active" ]]; then
        echo -e "\033[0;32m${service%.*} status: $status\033[0m"
    else
        echo -e "\033[0;31m${service%.*} status: $status\033[0m"
    fi
done

echo -e "\n"

# Ask the user if they want to see the boot info
read -p $'\033[0;33mDo you want to see the last boot time and possible reboot reasons? (y/n) \033[0m' answer

if [[ -n "$answer" && "$answer" =~ ^[Yy]$ ]]; then
    # Display the last boot time
    echo -e "\033[0;36m\nLAST BOOT TIME:\n\033[0m"
    echo -e "\033[0;32m$(who -b)\n\033[0m"

    # Display logs from the previous boot to infer the reason for the last reboot
    echo -e "\033[0;36mPOSSIBLE REASON FOR LAST REBOOT/BOOT:\n\033[0m"

sudo journalctl --boot=-1 -e | grep -Ei 'shutting down|reboot|starting' | GREP_COLOR='01;32' grep --color=always -E 'normally|power-off|rebooted' || GREP_COLOR='01;31' grep --color=always -E 'error|failed|panic'    echo -e "\n"
else
    echo -e "\033[0;31mBoot info display skipped.\033[0m"
fi