#!/bin/bash
border ()
{
echo "#######################################################################################################"
}

sethosts ()
{
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\tlocalhost" >> /etc/hosts
echo -e "127.0.0.1\t$hostdenominator.localdomain\t$hostdenominator" >> /etc/hosts
echo -e "127.0.0.1\tlocalhost"
echo -e "::1\tlocalhost"
echo -e "127.0.0.1\t$hostdenominator.localdomain\t$hostdenominator"
}

refindinstall () #not again bruh
{
read -p "Would you like to execute refind-install?: " confirm
case $confirm in
	y | yes)
		refind-install
		;;
	n | no)
		echo "Assuming existing refind install"
		;;
	*)
		refindinstall # this is really not going to fucking work longterm bruh
		;;
esac
}

fixboot ()
{
sed -i "s/archisobasedir.*/"rw\ root=UUID=$rootuuid\""/" /boot/refind_linux.conf
}

border
echo "Stage 2 initiated succesfully"
read -p "Insert Hostname: " hostdenominator
read -p "Insert Username: " userdenominator
rootuuid=$(blkid -s UUID -s TYPE | grep ext4 | sed -n 's/.*UUID=\"\([^\"]*\)\".*/\1/p')
echo "ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime"
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
echo "hwclock --systohc"
hwclock --systohc
echo "en_US.UTF-8 UTF-8\nro_RO.UTF-8 UTF-8"
echo -e "en_US.UTF-8 UTF-8\nro_RO.UTF-8 UTF-8" >> /etc/locale.gen
echo "locale-gen"
locale-gen
echo "LANG=en_US.UTF-8"
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo $hostdenominator
echo $hostdenominator >> /etc/hostname
border
sethosts
mkinitcpio -P
border
echo -e "Root password\n"
passwd
border
useradd -m -G wheel $userdenominator
echo -e "User password\n"
passwd $userdenominator
border
pacman -S refind --noconfirm
refindinstall
fixboot
border
echo "Stage 2 completed."

