#!/bin/bash

clear

# update the system and install tmux
cd ~/
echo "updating system and installing nala and tmux"
sudo update
sudo apt install tmux nala
echo "starting upgrade"
sudo apt upgrade -y

# Install common programs



# install aliases for terminal
echo 'alias ll="ls -lha"' >> ~/.bashrc
echo 'alias bashrc="nano ~/.bashrc && exec bash"' >> ~/.bashrc
echo 'alias help="cat ~/.bashrc | grep alias"' >> ~/.bashrc
exec bash
exit
