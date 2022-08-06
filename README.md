# linux-setup
Setup script for Debian based distros

This is a BASH script I use with Debian based distros to add common programs and aliases I use.
It also addresses security issues regarding ssh.  To use this script you must have NON-root access
with sudo privileges.

INSTALLATION:

cd ~
git clone
cd ~/linux-setup
chmod +x setup.sh
./setup.sh

or you use this 1 liner

cd ~ && sudo apt install git && git clone  && bash ~/linux-setup/setup.sh
