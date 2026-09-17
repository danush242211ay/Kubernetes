#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "======= 1. Updating System Packages ======="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "======= 2. Installing Prerequisites ======="
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "======= 3. Adding Docker's Official GPG Key ======="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "======= 4. Setting Up Docker Apt Repository ======="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "======= 5. Installing Docker Engine & Plugins ======="
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "======= 6. Managing System Services ======="
sudo systemctl enable docker
sudo systemctl start docker

echo "======= 7. Configuring Non-Root User Permissions ======="
# Add the currently logged-in user (usually 'ubuntu' on AWS) to the docker group
sudo usermod -aG docker $USER

echo "============================================="
echo "✅ Docker installation successful!"
echo "⚠️ IMPORTANT: Please log out and log back in (or restart your SSH session) for group changes to take effect."
echo "============================================="
