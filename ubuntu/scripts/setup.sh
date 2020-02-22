#!/bin/bash -eu
# setup.sh

SSH_USER=${SSH_USERNAME:-vmuser}

echo "==> Giving $SSH_USER sudo powers"
echo "$SSH_USER        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/$SSH_USER
chmod 440 /etc/sudoers.d/$SSH_USER
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Fix stdin not being a tty
if grep -q "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
    echo "==> Fixed stdin not being a tty."
fi

echo "==> Disabling daily apt unattended updates"
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

echo "==> Installing VirtualBox Guest Additions"
apt-get -y install --no-install-recommends dkms
mount -o loop /home/$SSH_USER/VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -f /home/$SSH_USER/VBoxGuestAdditions.iso

echo "==> Set up /usr/local/bin/vmnet"
mv /home/$SSH_USER/vmnet /usr/local/bin/
chmod +x /usr/local/bin/vmnet
chown root:root /usr/local/bin/vmnet

echo "==> Updating SSH settings and $SSH_USER public key"
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

echo "==> Setting /etc/rc.local to call vmnet on bootup"
sed -i "/exit 0/d" /etc/rc.local
chmod +x /etc/rc.local
echo /usr/local/bin/vmnet >> /etc/rc.local

exit 0
