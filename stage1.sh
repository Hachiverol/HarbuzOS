#!/bin/bash
# FUNCTION DEFINITIONS
border ()
{
echo "#######################################################################################################"
}
welcome ()
{
echo -e "Welcome to WhatTheFuck Linux! This is a stage 1 script\nThat means you will now be installing a pretty standard base of Arch Linux"
echo -e "It is required that you have an internet connection and enable the network time daemon\nAfterwards, partition your drive and mount everything to the desired path"
echo "timedatectl set-ntp true"
echo -e "WARNING!!! DON'T CONTINUE RUNNING THIS SCRIPT IF THE PREVIOUS STEPS HAVEN'T BEEN FULFILLED!!!"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
}

kernelandpacstrap () 
{
	while [ -z $kerneltype ] || [ $kerneltype != 1 ] || [ $kerneltype != 2 ]; do
		read -p "Do you want to use linux(1) or linux-zen(2)?: " kerneltype
		if [ $kerneltype == 1 ]; then
			pacstrap /mnt base base-devel linux linux-headers linux-firmware
			break
		elif [ $kerneltype == 2 ]; then
			pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware
			break
		fi
	done
}


#THIS IS HORRIBLE DO NOT FUCKING DO THIS EVER AGAIN NIGGA
checkforchroot ()
{
echo -e "You're about to enter stage 2!!!\nWarning! Stage 2 has a few defaults set for my specific use case\nIf you live in Moldova and would like to have a similar setup to mine go right ahead\nI might end up fixing this in the future if I get to have some spare time...\n"
read -p "Would you like to execute stage 2?(y/n): " confirm
case $confirm in
	y | yes)		
		echo "Entering chroot and executing stage 2..."
		arch-chroot /mnt bash <(curl -s https://raw.githubusercontent.com/Hachiverol/HarbuzOS/main/stage2.sh)
		;;
	n | no)
		echo "Entering chroot..."
		arch-chroot /mnt
		;;
	*)
		checkforchroot #NIGGA WHAT THE FUCK
esac
}
# DEFINITIONS END HERE

# Main
border
welcome
border
kernelandpacstrap
border
echo "Generating fstab file"
genfstab -U /mnt >> /mnt/etc/fstab
border
read -p "Enter chroot? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
border
checkforchroot


