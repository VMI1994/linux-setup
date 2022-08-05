#!/bin/bash

clear

# update the system and install tmux
cd ~/
echo "Updating System"
sleep 1
sudo apt update
echo "Starting Upgrade"
sudo apt upgrade
clear


# Install common programs
clear
echo "Installing common programs using nala..."
sleep 1
sudo apt install nala
sudo nala install neofetch tmux 


# install aliases for terminal
clear
echo "Installing common aliases"
sleep 1
echo 'alias ll="ls -lha"' >> ~/.bashrc
echo 'alias bashrc="nano ~/.bashrc && exec bash"' >> ~/.bashrc
echo 'alias help="cat ~/.bashrc | grep alias"' >> ~/.bashrc
exec bash

clear
echo "Setup is Complete"
exit
