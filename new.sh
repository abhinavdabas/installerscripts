#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Update package lists
sudo apt update

# Upgrade installed packages
sudo apt upgrade -y

# Remove existing Docker packages
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install necessary dependencies
sudo apt install ca-certificates curl gnupg lsb-release -y

# Create directory for Docker keyrings
sudo mkdir -p /etc/apt/keyrings

# Download and install Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository to package sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt update

# Install Docker and Docker Compose
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y

# Install Cockpit
sudo apt install btop -y

sudo reboot
