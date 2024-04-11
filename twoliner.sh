sudo echo -e "\n"
echo -e "\033[0;34m\nSTARTING HEALTH CHECK\n\033[0m"
echo -e "\033[0;36m\nCHECKING NVIDIA DRIVER:\n\033[0m"
if nvidia-smi &>/dev/null; then echo -e "\033[0;32mNVIDIA driver is installed and active.\n\033[0m"; else echo -e "\033[0;31mNVIDIA driver is not installed.\n\033[0m"; fi
echo -e "\033[0;36mSCREEN RES AND OUTPUT:\n\033[0m"

output=$(sudo runuser -l player -c 'export DISPLAY=:0 && xrandr | grep HDMI-0')

if [[ $output == *"disconnected"* ]]; then
    echo -e "\033[0;31mNo HDMI connected. Check for DP or DVI with xrandr\033[0m"
else
    echo "$output"
fi

echo -e "\033[0;36m\nCHECKING NETWORK:\n\033[0m"
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo -e "\033[0;33mIP: $(hostname -I | awk '{print $1}')\n\033[0m"
echo -e "\033[0;33mMAC: $(ip link show $INTERFACE | awk '/link/ {print $2}')\n\033[0m"
curl -s --head --request GET http://api.cinemataztic.com --max-time 10 > /dev/null 2>&1 && echo -e "\033[0;32m\n---------- API is reachable ----------\n\033[0m" || echo -e "\033[0;31m\n---------- API not reachable ----------\n\033[0m"
echo -e "\033[0;36mCHECKING VERSIONS:\n\033[0m"

packages=("dch-p" "cinead-d" "cinead-p" "cinegame-d" "cinegame-p" "cinecard-d" "cinecard-p" "cinematazticio24" "nodejs")

for package in "${packages[@]}"; do
    if dpkg -s "$package" &> /dev/null; then
        echo -e "\033[0;32m$package $(dpkg -s "$package" | grep -i version)\033[0m"
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