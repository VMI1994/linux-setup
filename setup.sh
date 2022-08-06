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
sudo apt install python3 nala
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

# Anything below this line has yet to be scripted
# Any recommendations for bash aliases and good programs to add are welcome

# Generate SSH keys

# Lock down SSH

# Fix anything related to cloud-init

# Any other security related concerns


