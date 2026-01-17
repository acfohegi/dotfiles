sudo mkswap --uuid clear --size 24G --file /swapfile
sudo swapon /swapfile
sudo echo -e "/swapfile\tnone\tswap\tdefaults\t0\t0" >> /etc/fstab
