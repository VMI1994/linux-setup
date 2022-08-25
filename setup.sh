#!/bin/bash


# Define functions
pause() {
echo
echo
echo "Press Enter to continue"
read junk
}


# Get information for configuration
clear
echo 'Enter a hostname for this server (example ubuntu-server)'
read hostname
clear
sudo hostnamectl set-hostname $hostname
echo "hostname has been set to $hostname"
pause


# Install and activate aliases
clear
echo 'Installing and activating aliases'
sleep 1
cat ~/linux-setup/alias.txt >> ~/.bashrc
bash ~/linux-setup/alias.sh &
pause


# Install respositories
clear
echo "Installing additional repositories"
# Additional needed repositories
sudo add-apt-repository -y ppa:teejee2008/timeshift #repo for timeshift
pause


# Update system
clear
echo "Updating the system"
sudo apt update
sudo apt dist-upgrade -y
pause


# Remove cloud-init if present and Install common programs
clear
echo "Checking for presence of cloud-init"
which cloud-init > /dev/null
if [ $? == 0 ]
then
  echo "Cloud-init detected, removing"
  sudo apt purge cloud-init -y
else
  echo "Cloud-init not installed, continuing"
fi
pause


# Install common programs
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
pause


# Cleaning up unneeded files
echo "Removing unused packages"
sudo apt autoremove -y
pause


# Set up unattended-upgrades (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Setting up unattended-upgrades...at the prompt please select 'Yes'..."
pause
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo rm /etc/apt/apt.conf.d/20auto-upgrades
sudo cp ~/linux-setup/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
sudo rm /etc/apt/apt.conf.d/50unattended-upgrades
sudo cp ~/linux-setup/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
pause


# Configure OpenSSH-Server (Credit to Jay LaCroix - learnlinux.tv)
clear
echo "Configuring OpenSSH-Server"
sleep 1
echo
echo
echo "Regenerating SSH keys....Please press enter at all prompts..."
pause
sudo ssh-keygen -t ed25519
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo cp ~/linux-setup/sshd_config /etc/ssh/sshd_config
echo
echo
echo "SSH configured....restarting service"
sudo systemctl restart sshd
pause


# Setup Fail2ban
clear
echo "Setting up Fail2ban"
sudo cp ~/linux-setup/jail.local /etc/fail2ban/jail.local
echo "Fail2ban is Setup"
pause


# Run tasksel
echo "tasksel will now run."
echo
echo "Select any additional software to install"
pause
sudo tasksel


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
