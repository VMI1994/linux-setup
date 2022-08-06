#!/bin/bash


# Install and activate aliases
clear
echo 'Installing and activating aliases'
sleep 1
cat ~/linux-setup/alias.txt >> ~/.bashrc
bash ~/linux-setup/alias.sh &
echo 'done...'
sleep 1


# Install nala frontend for apt
clear
echo "Installing python3 and nala frontend for apt"
sudo apt update
sudo apt install python3 wget
echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
sudo apt update
sudo apt install nala
sleep 2


# Update system with nala.  Will fall back to apt if nala install failed
clear
echo "Updating the system"
which nala > /dev/null
if [ $? == 0 ]; then
  echo "nala install succeeded"
  sudo nala upgrade
else
  echo "nala install failed"
  sudo apt dist-upgrade
fi


# Install common programs
clear
echo "Installing common programs"
sleep 1
# Create list of apps to install from apps.txt
apps=(`cat ~/linux-setup/apps.txt`)
noofelements=${#apps[*]}
counter=0
list=("")
while [ $counter -lt $noofelements ]
do
    new=("${apps[$counter]}")
    list=("$list ""$new")
    counter=$(( $counter + 1 ))
done
apps=("$list")
which nala > /dev/null
if [ $? == 0 ]; then
  sudo nala install $apps
else
  sudo apt install $apps
fi


# Cleaning up unneeded files
sudo apt autoremove


# Set up unattended-upgrades (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Setting up unattended-upgrades...at the prompt please select 'Yes'..."
sleep 5
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo mv /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.old
sudo cp ~/linux-setup/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
sudo mv /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.old
sudo cp ~/linux-setup/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
sleep 2

# Configure OpenSSH-Server (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Configuring OpenSSH-Server"
sleep 1
echo "Regenerating SSH keys....Please press enter at all prompts..."
sudo ssh-keygen -t ed25519
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo cp ~/linux-setup/sshd_config /etc/ssh/sshd_config
echo "SSH configured....restarting service"
sleep 2
sudo systemctl restart sshd
echo "SSH service restarted"
sleep 2


# Setup Fail2ban
clear
echo "Setting up Fail2ban"
sudo cp ~/linux-setup/jail.local /etc/fail2ban/jail.local
echo "Fail2ban is Setup"
sleep 2

# Cleanup & exit
clear
echo "setup is complete...."
sleep 1
echo "Setup is now erasing files and exiting"
sleep 1
sleep 5 && sudo rm -rf ~/linux-setup
exit
