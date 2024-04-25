#!/bin/bash

sudo systemctl stop dch-p


# Remove the BASE_URL line from system.conf
sudo sed -i '/^BASE_URL=/d' /etc/systemd/system.conf

# Ask the user to choose between Production, Staging, and Development
echo "Choose an environment:"
environments=("Production" "Staging" "Development")
for ((i=0; i<${#environments[@]}; i++)); do
    echo "$((i+1)). ${environments[i]}"
done

# Get user input for environment
read -p "Enter the number of your choice (1-3): " env_choice

# Validate user input for environment
re='^[0-9]+$'
if ! [[ $env_choice =~ $re ]] || ((env_choice < 1)) || ((env_choice > 3)); then
    echo "Invalid choice. Please enter a valid number (1-3)."
    exit 1
fi

# Set the environment based on user choice
if ((env_choice == 1)); then
    environment="Production"
elif ((env_choice == 2)); then
    environment="Staging"
elif ((env_choice == 3)); then
    environment="Development"
else
    echo "Invalid environment choice."
    exit 1
fi



# Array of options
options=("cinemataztic-en" "drf-dk" "finnkino-fi" "itv-in" "mdn-no" "valmorgan-au" "valmorgan-nz" "weischer-de" "wideeyemedia-ie"  "filmstaden-se")
# Display the menu
echo "Choose a market:"
for ((i=0; i<${#options[@]}; i++)); do
    echo "$((i+1)). ${options[i]}"
done

# Get user input
read -p "Enter the number of your choice: " choice

# Validate user input
re='^[0-9]+$'
if ! [[ $choice =~ $re ]] || ((choice < 1)) || ((choice > ${#options[@]})); then
    echo "Invalid choice. Please enter a valid number."
    exit 1
fi

selected_option="${options[choice-1]}"

sudo sed -i "s/^DefaultEnvironment=MARKET=.*/DefaultEnvironment=MARKET=$selected_option/" /etc/systemd/system.conf

echo "MARKET environment variable updated to '$selected_option' in /etc/systemd/system.conf"

# Depending on the selected environment, set appropriate market options and BASE_URL
case "$environment" in
    "Production")
        options=("cinemataztic-en" "drf-dk" "finnkino-fi" "itv-in" "mdn-no" "valmorgan-au" "valmorgan-nz" "weischer-de" "wideeyemedia-ie" "filmstaden-se")
        ;;
    "Staging")
        options=("cinemataztic-en" "finnkino-fi")
        # Set BASE_URL for Staging environment
        if [[ "$selected_option" == "finnkino-fi" ]]; then
            BASE_URL="BASE_URL=https://finnkino.fi.api.player.staging.cinemataztic.com/v2"
        else
            BASE_URL="BASE_URL=https://cinemataztic.en.api.player.staging.cinemataztic.com/v2"
        fi
        ;;
    "Development")
        options=("cinemataztic-en" "finnkino-fi")
        # Set BASE_URL for Development environment
        if [[ "$selected_option" == "finnkino-fi" ]]; then
            BASE_URL="BASE_URL=https://finnkino.fi.api.player.dev.cinemataztic.com/v2"
        else
            BASE_URL="BASE_URL=https://cinemataztic.en.api.player.dev.cinemataztic.com/v2"
        fi
        ;;
    *)
        echo "Invalid environment choice."
        exit 1
        ;;
esac



if [[ "$environment" == "Staging" || "$environment" == "Development" ]]; then
    sudo sed -i "s|MARKET.*|& $BASE_URL|" /etc/systemd/system.conf
fi

echo "BASE_URL environment variable updated to '$BASE_URL' in /etc/systemd/system.conf"


sleep 3


read -p "Do you want to reboot the system now to apply the changes? (y/n): " reboot_choice
if [[ $reboot_choice =~ ^[Yy]$ ]]; then
    sudo rm -r /opt/DCH-P/realm/*
    sudo reboot
else
    echo "Reboot not requested. Exiting script."
    sudo systemctl restart dch-p
fi


