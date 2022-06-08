#!/bin/bash
set -e
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
################################################################################################
echo Script to mount DATA drive and symlink folders
################################################################################################

## Find correct partition
#blkid
lsblk -fs
read -p "Select the partition you want to mount (e.x. sdaX with X being the partition number): " part
PART_ID=$(blkid -o value -s UUID /dev/$part)
fs_type=$(blkid -o value -s TYPE /dev/$part)

# Prompt user for folder name
read -p "Enter desired folder name: " name
if [ ! -d /mnt/$name ]; then
	mkdir /mnt/$name
fi
read -p "Enter owner/user name: " user_name

echo Taking ownership of DATA partition
if [[ $(findmnt -M /mnt/$name) ]]; then
	echo "Already mounted"
	## see if this fixes permission issues when trying to run script again.
	chown -R $user_name: /mnt/$name
else
	mount /dev/$part /mnt/$name
	chown -R $user_name: /mnt/$name
fi
echo "---------done---------"

echo "---------checking for existing folders"
#Desktop
if [ ! -d /mnt/$name/Desktop ]; then
	mkdir /mnt/$name/Desktop
else
	echo "Desktop folder exists"
fi
#Documents
if [ ! -d /mnt/$name/Documents ]; then
	mkdir /mnt/$name/Documents
else
	echo "Documents folder exists"
fi
#Downloads
if [ ! -d /mnt/$name/Downloads ]; then
	mkdir /mnt/$name/Downloads
else
	echo "Downloads folder exists"
fi
#Music
if [ ! -d /mnt/$name/Music ]; then
	mkdir /mnt/$name/Music
else
	echo "Music folder exists"
fi
#Pictures
if [ ! -d /mnt/$name/Pictures ]; then
	mkdir /mnt/$name/Pictures
else
	echo "Pictures folder exists"
fi
#Videos
if [ ! -d /mnt/$name/Videos ]; then
	mkdir /mnt/$name/Videos
else
	echo "Videos folder exists"
fi
#Git
if [ ! -d /mnt/$name/Nextcloud ]; then
	mkdir /mnt/$name/Nextcloud
else
	echo "Git folder exists"
fi
#Games
if [ ! -d /mnt/$name/Games ]; then
	mkdir /mnt/$name/Games
else
	echo "Games folder exists"
fi
#GameShortcuts
#if [ ! -d /mnt/$name/GameShortcuts ]; then
#	mkdir /mnt/$name/GameShortcuts
#else
#	echo "GameShortcuts folder exists"
#fi
#Applications
if [ ! -d /mnt/$name/Applications ]; then
	mkdir /mnt/$name/Applications
else
	echo "Applications folder exists"
fi
if [ ! -d /mnt/$name/.ssh ]; then
	mkdir /mnt/$name/.ssh
else
	echo "Applications folder exists"
fi
echo "---------done---------"
#################################################
echo "Removing default home folders"
if [ ! -d /home/$user_name/Documents ]; then
	echo "Documents removed"
else
	rm -R /home/$user_name/Documents
fi

if [ ! -d /home/$user_name/Desktop ]; then
	echo "Documents removed"
else
	rm -R /home/$user_name/Desktop
fi

if [ ! -d /home/$user_name/Downloads ]; then
	echo "Downloads removed"
else
	rm -R /home/$user_name/Downloads
fi

if [ ! -d /home/$user_name/Music ]; then
	echo "Music removed"
else
	rm -R /home/$user_name/Music
fi

if [ ! -d /home/$user_name/Nextcloud ]; then
	echo "Nextcloud removed"
else
	rm -R /home/$user_name/Nextcloud
fi

if [ ! -d /home/$user_name/Pictures ]; then
	echo "Pictures removed"
else
	rm -R /home/$user_name/Pictures
fi

if [ ! -d /home/$user_name/Videos ]; then
	echo "Videos removed"
else
	rm -R /home/$user_name/Videos
fi

echo "---------done---------"
######################################################
echo "Symlinking DATA folders"
if [ ! -d /home/$user_name/Documents ]; then
	ln -s /mnt/$name/Documents /home/$user_name
fi

if [ ! -d /home/$user_name/Desktop ]; then
	ln -s /mnt/$name/Desktop /home/$user_name
fi

if [ ! -d /home/$user_name/Downloads ]; then
	ln -s /mnt/$name/Downloads /home/$user_name
fi

if [ ! -d /home/$user_name/Games ]; then
	ln -s /mnt/$name/Games /home/$user_name
fi

#if [ ! -d /home/$user_name/GameShortcuts ]; then
#	ln -s /mnt/$name/GameShortcuts /home/$user_name
#fi

if [ ! -d /home/$user_name/Music ]; then
	ln -s /mnt/$name/Music /home/$user_name
fi

if [ ! -d /home/$user_name/Pictures ]; then
	ln -s /mnt/$name/Pictures /home/$user_name
fi

if [ ! -d /home/$user_name/Videos ]; then
	ln -s /mnt/$name/Videos /home/$user_name
fi

if [ ! -d /home/$user_name/Nextcloud ]; then
	ln -s /mnt/$name/Nextcloud /home/$user_name
fi

if [ ! -d /home/$user_name/Applications ]; then
	ln -s /mnt/$name/Applications /home/$user_name
fi
if [ ! -d /home/$user_name/.ssh ]; then
	ln -s /mnt/$name/.ssh /home/$user_name
fi
echo "---------done---------"

chown -R $user_name: /mnt/$name

###########################################################################################################
echo "adding DATA part UUID to fstab"
if grep -Fxq "UUID=$PART_ID /mnt/$name $fs_type defaults,noatime 0 2" /etc/fstab; then
	echo "Already in fstab"
else
	name=DATA
	echo "UUID=$PART_ID /mnt/$name $fs_type defaults,noatime 0 2" >> /etc/fstab
fi
echo "---------done---------"

echo "DATA successfully linked"
