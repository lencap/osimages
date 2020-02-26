#!/bin/bash -eu
# ubuntu-update.sh

echo "==> Disabling apt.daily.service & apt-daily-upgrade.service"
systemctl stop apt-daily.timer apt-daily-upgrade.timer
systemctl mask apt-daily.timer apt-daily-upgrade.timer
systemctl stop apt-daily.service apt-daily-upgrade.service
systemctl mask apt-daily.service apt-daily-upgrade.service
systemctl daemon-reload

echo "==> Updating list of repositories"
plog=/root/packer.log
apt-get update > $plog
printf "\n\n\n" >> $plog
if [[ $UPDATE =~ true || $UPDATE =~ 1 ]]; then
    echo "==> Upgrading packages"
    apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade >> $plog
fi
printf "\n\n\n" >> $plog
apt-get -y install --no-install-recommends build-essential linux-headers-generic ssh curl vim dkms >> $plog

echo "==> Removing the release upgrader"
apt-get -y purge ubuntu-release-upgrader-core
rm -rf /var/lib/ubuntu-release-upgrader
rm -rf /var/lib/update-manager

if [[ $DISABLE_IPV6 =~ true || $DISABLE_IPV6 =~ 1 ]]; then
    echo "==> Disabling IPv6"
    sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
fi

echo "==> Streamline grub boot settings"
sed -i '/^GRUB_TIMEOUT=/aGRUB_RECORDFAIL_TIMEOUT=0' /etc/default/grub
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/' /etc/default/grub
sed -i '/^GRUB_HIDDEN_TIMEOUT=/d' /etc/default/grub
update-grub

echo "==> Shutting down the SSHD service and rebooting..."
# This reboot is required because the kernel and grub were updated
sudo systemctl stop sshd
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120

exit 0
