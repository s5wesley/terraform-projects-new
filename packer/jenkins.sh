#!/bin/bash

# Update package list
sudo apt update

# Install OpenJDK 17 runtime
sudo apt install -y fontconfig openjdk-17-jre

# Verify Java installation
java -version

# Add Jenkins key and repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list again to include Jenkins packages
sudo apt-get update

# Install Jenkins
sudo apt-get install -y jenkins
