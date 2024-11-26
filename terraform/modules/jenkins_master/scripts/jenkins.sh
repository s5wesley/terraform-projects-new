#!/bin/bash

function jenkins_installation {
    sudo apt update
    sudo apt install curl -y 
    sudo apt install wget -y    
    sudo apt install vim -y
    
    ## Set vim as default text editor
    sudo update-alternatives --set editor /usr/bin/vim.basic
    sudo update-alternatives --set vi /usr/bin/vim.basic
    sudo apt install fontconfig openjdk-17-jre -y
    java -version
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
}

jenkins_installation