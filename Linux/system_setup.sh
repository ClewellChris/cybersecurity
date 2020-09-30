#!/bin/bash

# A simple server setup script

# Make sure the script is run by a sudo or root user

if [ ! $UID -ne 0 ]
then
  echo "Run this script as sudo"
  exit
fi

# Create a Log File to monitor progress of set up

log_file=/var/log/system_setup.log

echo "Log file for server set up" >> $log_file
echo "##########################" >> $log_file
echo "Log created on: $(date)" >> $log_file
echo "##########################" >> $log_file
echo "" >> $log_file

packages=(
 'nano'
 'wget'
 'net-tools'
 'python'
 'tripwire'
 'tree'
 'curl'
)

for package in ${packages=[@]}
do
 if [ ! $(which $package) ]
 then
 apt install -y $package
 fi
done

# Print out package installs and log it
echo "$(date) Installed needed packages: ${packages[@]}" | tee -a $log_file

# Create sysadmin user
useradd sysadmin
chage -d 0 sysadmin

# Created sysadmin user, password to added upon log-in

echo "$(date) Created sys_admin user, set password on first log in" | tee -a $log_file

# Change permissons on sensitve /etc folders

chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/group
chmod 644 /etc/passwd

echo "$(date) Changed permissions on senistive /etc files." | tee -a $log_file

# Setup a scripts folder in the /home directory

if [ ! -d /home/scripts ]
then
 mkdir /home/scripts
 chown sysadmin:sysadmin /home/scripts
fi

# Add scripts folder to the .bashrc file

echo "" >> /home/sysadmin/.bashrc
echo "PATH=$PATH:/home/sysadmin/scripts" >> /home/sysadmin/.bashrc
echo "" >> /home/sysadmin/.bashrc

echo "$(date) Added ~/scripts directory to the sysadmins PATH." | tee -a $log_file

echo "$(date) Script Finished. Exiting."
echo "$(date) Script Finished. Exiting." >> $log_file

exit
 
