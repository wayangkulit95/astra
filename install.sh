#!/bin/bash

# Ensure the script is being run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Update the system
echo "Updating system packages for Debian 11..."
apt update && apt upgrade -y

# Install dependencies
echo "Installing necessary dependencies..."
apt install curl -y

# Download and install Cesbo Astra
echo "Downloading Cesbo Astra..."
curl -Lo /usr/bin/astra https://cesbo.com/astra-latest

# Make the Astra binary executable
echo "Making Astra executable..."
chmod +x /usr/bin/astra

# Verify the installation
echo "Verifying Astra installation..."
astra -v

# Initialize Astra
echo "Initializing Astra..."
astra init

# Start the Astra service
echo "Starting Cesbo Astra service..."
systemctl start astra

# Enable Astra service to start on boot
echo "Enabling Cesbo Astra to start at boot..."
systemctl enable astra

# Check the status of the Astra service
echo "Checking Cesbo Astra service status..."
systemctl status astra

# Output message to indicate where to access Astra
ip_addr=$(hostname -I | awk '{print $1}')
echo "Cesbo Astra installation complete!"
echo "Access Astra at: http://$ip_addr:8000"
echo "Default login: admin/admin"

# Recommendation to change the default password
echo "IMPORTANT: Log in to the web interface and change the default admin password."
