#!/bin/bash -eu
# centos-update.sh

echo "==> Removing/installing required packages"
plog=/root/packer.log
yum -y remove aic94xx-firmware ivtv-firmware iwl*-firmware mariadb-libs >> $plog
printf "\n\n\n" >> $plog
yum -y install epel-release >> $plog
# Avoid epel SSL cert issues from some networks
sed -i 's/\(.*-http\)s/\1/' /etc/yum.repos.d/epel.repo
sync
yum -y install bind-utils binutils bzip2 curl lsof lvm2 make rsync sysstat tcpdump >> $plog
sync
yum -y install dkms gcc iputils kernel-devel kernel-headers nmap-ncat postfix time vim-enhanced >> $plog
printf "\n\n\n" >> $plog
yum -y update >> $plog
printf "\n\n\n" >> $plog
yum clean all >> $plog

echo "==> Updating grub settings"
if [[ $DISABLE_IPV6 =~ true || $DISABLE_IPV6 =~ 1 ]]; then
    sed -ri 's/^GRUB_CMDLINE_LINUX="(.*)"/GRUB_CMDLINE_LINUX="\1 ipv6.disable=1"/g' /etc/default/grub
    echo "AddressFamily inet" >> /etc/ssh/sshd_config
    sed -ri 's/^inet_protocols = all/inet_protocols = ipv4/' /etc/postfix/main.cf
fi
sed -ri 's/ rhgb quiet//' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

echo "==> Shutting down the SSHD service and rebooting..."
# This reboot is required because the kernel and grub were updated
sudo systemctl stop sshd
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120

exit 0
