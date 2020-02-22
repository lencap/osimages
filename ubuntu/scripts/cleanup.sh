#!/bin/bash -eu
# cleanup.sh

SSH_USER=${SSH_USERNAME:-vmuser}

echo "==> Doing apt update and cache cleanup"
apt -y autoremove --purge
apt update
apt clean

echo "==> Cleaning up tmp"
rm -rf /tmp/*

echo "==> Removing Bash history"
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

echo "==> Truncating log files"
find /var/log -type f -exec truncate --size=0 {} \;

echo "==> Clear out swap and disable until reboot"
set +e
swapuuid=$(blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x$swapuuid" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/${swapuuid})
    swapoff $swappart
    dd if=/dev/zero of=$swappart bs=1M || echo "dd exit code $? is suppressed"
    mkswap -U $swapuuid $swappart
fi

echo "==> Zeroing out the free disk space to save space in the final image"
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY
sync   # So Packer doesn't quit too early, before the large file is deleted

echo "==> Disk usage after cleanup"
df -h

exit 0
