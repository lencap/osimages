#!/bin/bash -eu
# setup.sh

SSH_USER=${SSH_USERNAME:-vmuser}

echo "==> Giving $SSH_USER sudo powers"
echo "$SSH_USER        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/$SSH_USER
chmod 440 /etc/sudoers.d/$SSH_USER
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo "==> Installing VirtualBox Guest Additions"
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

echo "Setting up bashrc and vimrc"
printf "\nalias h='history'\nalias vi='vim'\n" >> /root/.bashrc
cat <<EOF > /root/.vimrc
syntax on
hi comment ctermfg=blue
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set ruler
EOF
chown -R root:root /root/.vimrc

echo "==> Setting rc.local to call vmnet on bootup"
rcFile=/etc/rc.d/rc.local
if [[ -e $rcFile ]]; then
    sed -i "/exit 0/d" $rcFile
else
    echo "#!/bin/bash" > $rcFile
fi
echo "logger \"Running /usr/local/bin/vmnet\"" >> $rcFile
echo "/usr/local/bin/vmnet" >> $rcFile
echo "exit 0" >> $rcFile
chmod +x $rcFile
systemctl enable rc-local

exit 0
