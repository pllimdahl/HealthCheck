# Initial newline and header
echo -e "\nSTARTING HEALTH CHECK\n"

# Screen resolution and output for player user
echo -e "SCREEN RES AND OUTPUT:\n"
sudo runuser -l player -c 'export DISPLAY=:0 && xrandr | grep HDMI-0'
echo -e "\nCHECKING NETWORK:\n"

# IP and MAC address
echo -e "IP and MAC: $(hostname --ip-address)\n"

# Check if API is reachable
curl -s --head --request GET http://api.cinemataztic.com > /dev/null 2>&1 && echo -e "\n---------- API is reachable ----------\n" || echo -e "\n---------- API not reachable ----------\n"


# Checking versions
echo -e "CHECKING VERSIONS:\n"
echo "dch-p   $(dpkg -s dch | grep -i version)"
echo "cinead-d $(dpkg -s cinead-d | grep -i version)"
echo "cinead-p $(dpkg -s cinead-p | grep -i version)"
echo "cinegame-d    $(dpkg -s cinegame-d | grep -i version)"
echo "cinegame-p    $(dpkg -s cinegame-p | grep -i version)"
echo "cinecard-d    $(dpkg -s cinecard-d | grep -i version)"
echo "cinecard-p    $(dpkg -s cinecard-p | grep -i version)"
echo -e "cinematazticio24 $(dpkg -s cinematazticio24 | grep -i version)\n"

# Checking services
echo -e "CHECKING SERVICES:\n"
echo "dch-p status: $(systemctl is-active dch.service)"
echo "cinead-d status: $(systemctl is-active cinead-d.service)"
echo "cinegame-d status: $(systemctl is-active cinegame-d.service)"
echo "cinecard-d status: $(systemctl is-active cinecard-d.service)"
echo "cinematazticio24 status: $(systemctl is-active cinematazticio24.service)"
echo -e "\n"
