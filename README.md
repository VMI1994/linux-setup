# linux-setup
Setup script for Debian based distros

This is a BASH script I use with Debian based distros to add common programs and aliases I use.
It also addresses security issues regarding ssh.  To use this script you must have NON-root access
with sudo privileges.

INSTALLATION:

cd ~

git clone https://github.com/VMI1994/linux-setup.git

cd ~/linux-setup

chmod +x setup.sh

./setup.sh

or you use this 1 liner:

cd ~ && sudo apt install git && git clone https://github.com/VMI1994/linux-setup.git && bash ~/linux-setup/setup.sh

-------------------------------------------------------------------------------------------------------------------

What it does in a nutshell is:
  1. Add aliases in the alias.txt file to ~/.bashrc
  2. Calls a seperate program (alias.sh) to activate the aliases(if done in main script it halts the script)
  3. Install nala if available (nala is a frontend for the apt package manager)
  4. Update the packages
  5. Upgrade the packages
  6. Installs the programs in apps.txt
  7. Runs apt autoremove to clean packages
  8. Installs and configures unattended-upgrades and moves config files into place (config is 20auto-upgrades & 50unattended-upgrades)
  9. Installs and configures OpenSSH-server, generates ssh keys and restarts the service
  10. Installs and configures fail2ban (check jail.local for configuration settings)
  11. Attempts to install nala (frontend for apt package manager)
  12. Finishes and deletes all downloaded files


