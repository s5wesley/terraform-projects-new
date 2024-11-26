#!/bin/bash
set -e  # Exit immediately if any command fails

# Update the system
sudo apt-get update -y

# Install Apache
sudo apt-get install -y apache2

# Start and enable Apache to run on boot
sudo systemctl start apache2
sudo systemctl enable apache2

# Install wget and unzip utilities
sudo apt-get install -y wget unzip

# Change to the web root directory
cd /var/www/html/

# Remove default index.html and any existing content
sudo rm -rf *

# Download and unzip the content from S3 bucket
wget https://vougepay-bucket.s3.us-east-2.amazonaws.com/AJ+Free+Website+Template+-+Free-CSS.com.zip

if [ -f "AJ+Free+Website+Template+-+Free-CSS.com.zip" ]; then
    # Unzip the content and move it to the web root
    unzip AJ+Free+Website+Template+-+Free-CSS.com.zip
    sudo cp -r aj/* .

    # Clean up the zip file and directory
    sudo rm -rf AJ+Free+Website+Template+-+Free-CSS.com aj
else
    echo "Failed to download AJ+Free+Website+Template+-+Free-CSS.com.zip from S3."
    exit 1
fi

# Restart Apache to make sure changes take effect
sudo systemctl restart apache2