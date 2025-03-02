#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Update package lists
sudo apt update -y

# Upgrade installed packages
sudo apt upgrade -y

# Remove existing Docker packages
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# Install necessary dependencies
sudo apt install -y ca-certificates curl gnupg lsb-release

# Ensure lsb_release is installed
if ! command -v lsb_release &> /dev/null; then
    sudo apt install -y lsb-release
fi

# Create directory for Docker keyrings
sudo mkdir -p /etc/apt/keyrings

# Download and install Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository to package sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt update -y

# Install Docker and Docker Compose Plugin
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Ensure Docker service is enabled and started
sudo systemctl enable --now docker

# Allow user to run Docker without sudo (optional, uncomment if needed)
# sudo usermod -aG docker $USER

# Install btop (a better system monitor)
sudo apt install -y btop

# Deploy Portainer Agent
sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    portainer/agent:latest

# Sleep before reboot to allow SSH session to close cleanly
sleep 5

sudo reboot
