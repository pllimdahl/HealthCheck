sudo echo -e "\n"
echo -e "\033[0;34m\nSTARTING HEALTH CHECK\n\033[0m"
echo -e "\033[0;36m\nCHECKING NVIDIA DRIVER:\n\033[0m"
if nvidia-smi &>/dev/null; then echo -e "\033[0;32mNVIDIA driver is installed and active.\n\033[0m"; else echo -e "\033[0;31mNVIDIA driver is not installed.\n\033[0m"; fi
echo -e "\033[0;36mSCREEN RES AND OUTPUT:\n\033[0m"
sudo runuser -l player -c 'export DISPLAY=:0 && xrandr | grep HDMI-0'
echo -e "\033[0;36m\nCHECKING NETWORK:\n\033[0m"
echo -e "\033[0;33mIP and MAC: $(hostname --ip-address)\n\033[0m"
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
echo -e "\033[0;33mdch-p status: $(systemctl is-active dch-p.service)\033[0m"
echo -e "\033[0;33mcinead-d status: $(systemctl is-active cinead-d.service)\033[0m"
echo -e "\033[0;33mcinegame-d status: $(systemctl is-active cinegame-d.service)\033[0m"
echo -e "\033[0;33mcinecard-d status: $(systemctl is-active cinecard-d.service)\033[0m"
echo -e "\033[0;33mcinematazticio24 status: $(systemctl is-active cinematazticio24.service)\033[0m"
echo -e "\n"

# Ask the user if they want to see the boot info
read -p $'\033[0;33mDo you want to see the last boot time and possible reboot reasons? (y/n) \033[0m' answer

if [[ -n "$answer" && "$answer" =~ ^[Yy]$ ]]; then
    # Display the last boot time
    echo -e "\033[0;36m\nLAST BOOT TIME:\n\033[0m"
    echo -e "\033[0;32m$(who -b)\n\033[0m"

    # Display logs from the previous boot to infer the reason for the last reboot
    echo -e "\033[0;36mPOSSIBLE REASON FOR LAST REBOOT/BOOT:\n\033[0m"
    sudo journalctl --boot=-1 -e | grep -Ei 'shutting down|reboot|starting' | tail
    echo -e "\n"
else
    echo -e "\033[0;31mBoot info display skipped.\033[0m"
fi