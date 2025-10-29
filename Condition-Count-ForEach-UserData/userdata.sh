#!/bin/bash
# ========================================================
# Script: install_httpd.sh
# Purpose: Install and start Apache HTTP Server
# Works on: Amazon Linux / RHEL / CentOS
# ========================================================

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating system packages..."
sudo yum update -y

echo "Installing Apache HTTP Server (httpd)..."
sudo yum install -y httpd

echo "Starting httpd service..."
sudo systemctl start httpd

echo "Enabling httpd to start on boot..."
sudo systemctl enable httpd

echo "Creating a sample index.html..."
echo "<h1>Hello from $(hostname) - Apache Web Server is Running!</h1>" | sudo tee /var/www/html/index.html

echo "Installation complete! Visit this server’s public IP in your browser."
