#!/bin/bash -eu
# setup.sh

SSH_USER=${SSH_USERNAME:-vmuser}

echo "==> Adding $SSH_USER user to sudoers"
echo "$SSH_USER        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
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

echo "==> Setting SSH update config and $SSH_USERNAME public key"
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
mkdir -pm 700 /home/$SSH_USER/.ssh
cat <<EOF > /home/$SSH_USER/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyIZo/WEpMT8006pKzqHKhNEAPITJCEWj\
LN+cGSg9snFXVljAIQ9CtLo89PJvnfGj8I9VxXPxCUmC8gew/XXxQuExa0XhSSNYDEqM\
yOvlB8KSoYw8tFwNAYaeHw4rbygIgOSn5+g1lLXEf+FPa5JJJAByoxvqXtxZhwiJP2BO\
kp/ULqsy1UGbHFzGsYHkD8ukYINnr8Yob5K3GuvBSZkb4o02ErC0Tj9Xi52vxgSQEKNQ\
s5BOxzb4gtJ7ozArd11xrpmel02bH7mRfrB/Gpsfvb4WXRG9Kiat09T3XjceMAlcmMUG\
QJD0ip1mgN3elTCGpon8K5ZRWGxrF7G8XqnGQQ== vm insecure public key
EOF
chmod 0600 /home/$SSH_USER/.ssh/authorized_keys
chown -R $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh

echo "==> Setting up /etc/rc.local to call vmnet on bootup"
sed -i "/exit 0/d" /etc/rc.local
chmod +x /etc/rc.local
echo /usr/local/bin/vmnet >> /etc/rc.local

exit 0
