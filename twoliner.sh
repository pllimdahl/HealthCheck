echo -e "\n"
echo -e "\nSTARTING HEALTH CHECK\n"
echo -e "\nCHECKING NVIDIA DRIVER:\n"
if nvidia-smi &>/dev/null; then echo -e "NVIDIA driver is installed and active.\n"; else echo -e "NVIDIA driver is not installed.\n"; fi
echo -e "SCREEN RES AND OUTPUT:\n"
sudo runuser -l player -c 'export DISPLAY=:0 && xrandr | grep HDMI-0'
echo -e "\nCHECKING NETWORK:\n"
echo -e "IP and MAC: $(hostname --ip-address)\n"
curl -s --head --request GET http://api.cinemataztic.com --max-time 10 > /dev/null 2>&1 && echo -e "\n---------- API is reachable ----------\n" || echo -e "\n---------- API not reachable ----------\n"
echo -e "CHECKING VERSIONS:\n"


packages=("dch-p" "cinead-d" "cinead-p" "cinegame-d" "cinegame-p" "cinecard-d" "cinecard-p" "cinematazticio24" "nodejs")

for package in "${packages[@]}"; do
    if dpkg -s "$package" &> /dev/null; then
        echo "$package $(dpkg -s "$package" | grep -i version)"
    else
        echo "$package is NOT installed"
    fi
done


echo -e "\nCHECKING SERVICES:\n"
echo "dch-p status: $(systemctl is-active dch-p.service)"
echo "cinead-d status: $(systemctl is-active cinead-d.service)"
echo "cinegame-d status: $(systemctl is-active cinegame-d.service)"
echo "cinecard-d status: $(systemctl is-active cinecard-d.service)"
echo "cinematazticio24 status: $(systemctl is-active cinematazticio24.service)"
echo -e "\n"


# Ask the user if they want to see the boot info
read -p "Do you want to see the last boot time and possible reboot reasons? (y/n) " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    # Display the last boot time
    echo -e "\nLAST BOOT TIME:\n"
    echo -e "$(who -b)\n"

    # Display logs from the previous boot to infer the reason for the last reboot
    echo -e "POSSIBLE REASON FOR LAST REBOOT/BOOT:\n"
    sudo journalctl --boot=-1 -e | grep -Ei 'shutting down|reboot|starting' | tail
    echo -e "\n"
else
    echo "Boot info display skipped."
fi







