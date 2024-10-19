#!/bin/bash

# Ensure the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "Installing necessary dependencies..."
sudo apt install wget curl -y

# Add Cesbo Astra repository
echo "Adding Cesbo Astra repository..."
echo "deb http://cesbo.com/deb/release $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cesbo.list

# Add the Cesbo public key
echo "Downloading and adding Cesbo GPG key..."
wget -O - http://cesbo.com/deb/cesbo.gpg | sudo apt-key add -

# Update the package list after adding new repository
echo "Updating package list..."
sudo apt update

# Install Cesbo Astra
echo "Installing Cesbo Astra..."
sudo apt install astra -y

# Start the Astra service
echo "Starting Cesbo Astra service..."
sudo systemctl start astra

# Enable Astra service to start on boot
echo "Enabling Astra to start at boot..."
sudo systemctl enable astra

# Check if UFW (Uncomplicated Firewall) is installed, and open the necessary port
if ufw status | grep -q "Status: active"; then
  echo "UFW is active. Opening port 8000 for Astra..."
  sudo ufw allow 8000/tcp
  sudo ufw reload
else
  echo "UFW is not active or installed. Skipping firewall configuration..."
fi

# Display the status of the Astra service
echo "Checking Astra service status..."
sudo systemctl status astra

# Output message to indicate where to access Astra
ip_addr=$(hostname -I | awk '{print $1}')
echo "Cesbo Astra installation complete!"
echo "Access Astra at: http://$ip_addr:8000"
echo "Default login: admin/admin"

# Recommendation to change default password
echo "IMPORTANT: Log in to the web interface and change the default admin password."
