#!/bin/bash -eu

echo "==> Adding vmuser user to sudoers"
echo "vmuser        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo "==> Disabling daily apt unattended updates"
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

echo "==> Installing VirtualBox Guest Additions"
mount -o loop /tmp/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

echo "==> Installing vmnet"
sudo mv /tmp/vmnet /usr/local/bin/
sudo chmod +x /usr/local/bin/vmnet
