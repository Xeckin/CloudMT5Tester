#!/bin/bash

# Step 1: Install XRDP
# Update the list of packages in the reposity index
sudo apt update
# Install the main xrdp package
sudo apt install xrdp
# Ensure xrdp is restarted if the machine reboots
sudo systemctl enable xrdp
# Open up the RDP port 3389 in the firewall
sudo ufw allow from any to any port 3389 proto tcp
# Show/store the IP Address of the machine
ip_address=$(hostname -I | awk '{print $1}')
echo "IP Address is: ${ip_address}"

# Step 2: Install Wine-devel (SSH)
sudo dpkg --add-architecture i386 
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
# Use the correct source based on the version of Ubuntu you are running
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/lunar/winehq-lunar.sources
sudo apt update
sudo apt install --install-recommends winehq-devel

# Step 3: Edit /etc/hosts "localhost" with the ipaddress saved from above (might have to remove 127.0.0.1)
echo "${ip_address} localhost" | sudo tee -a /etc/hosts

# Step 4: Install Metatrader
wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5ubuntu.sh
chmod +x mt5ubuntu.sh
./mt5ubuntu.sh

# Step 5: Open all ports needed based on cpu's available on the machine.  Example: 32 core then you will open 2000:2031
ufw allow 2000:2031/tcp
