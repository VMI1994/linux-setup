#!/bin/bash


# Install and activate aliases
clear
echo 'Installing and activating aliases'
sleep 1
cat ~/linux-setup/alias.txt >> ~/.bashrc
bash ~/linux-setup/alias.sh &
echo
echo
echo 'done...Press Enter to continue'
read junk


# Install respositories
clear
echo "Installing additional repositories"
# Additional needed repositories
sudo add-apt-repository -y ppa:teejee2008/timeshift #repo for timeshift
echo "deb https://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list #nala repo
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null #nala key
echo
echo
echo "Done, press Enter to continue"
read junk


# Update system
clear
echo "Updating the system"
sudo apt update
sudo apt dist-upgrade -y
echo
echo
echo "The system has been updated, Press Enter to contue"
read junk

# Remove cloud-init if present and Install common programs
clear
echo "Checking for presence of cloud-init"
which cloud-init > /dev/null
if [ $? == 0 ]
then
  echo "Cloud-init detected, removing"
  sudo apt remove cloud-init -y
else
  echo "Cloud-init not installed, continuing"
fi
sleep 2
clear
echo "Installing common programs"
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
sudo apt install $apps -y
curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh && sudo chmod +x /usr/local/bin/cht.sh
echo
echo
echo "Programs installed, Press Enter to continue"
read junk

# Cleaning up unneeded files
echo "Removing unused packages"
sudo apt autoremove -y
echo
echo
echo "Done, Press Enter"
read junk

# Set up unattended-upgrades (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Setting up unattended-upgrades...at the prompt please select 'Yes'..."
echo "Press Enter to continue"
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo rm /etc/apt/apt.conf.d/20auto-upgrades
sudo cp ~/linux-setup/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
sudo rm /etc/apt/apt.conf.d/50unattended-upgrades
sudo cp ~/linux-setup/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
echo
echo
echo "Press Enter to continue"

# Configure OpenSSH-Server (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Configuring OpenSSH-Server"
sleep 1
echo
echo
echo "Regenerating SSH keys....Please press enter at all prompts..."
echo "Press Enter to continue"
read junk
sudo ssh-keygen -t ed25519
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo cp ~/linux-setup/sshd_config /etc/ssh/sshd_config
echo
echo
echo "SSH configured....restarting service"
sleep 2
sudo systemctl restart sshd
echo
echo
echo "SSH service restarted"


# Setup Fail2ban
clear
echo "Setting up Fail2ban"
sudo cp ~/linux-setup/jail.local /etc/fail2ban/jail.local
echo
echo
echo "Fail2ban is Setup"
echo "Press Enter"
read junk

# Attempt to install nala (frontend for apt package manager)
clear
echo "Installing nala, press Enter to continue"
read junk
sudo apt install nala -y

# Cleanup & exit
clear
echo "setup is complete...."
sleep 1
echo
echo
echo "Setup is now erasing files and exiting"
sleep 1
sleep 5 && sudo rm -rf ~/linux-setup
exit
