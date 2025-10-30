chmod +x $HOME/.config/udev/udev_scripts/*
sudo mkdir -vp /usr/local/bin/udev_scripts/
sudo mkdir -vp /etc/udev/rules.d/
sudo ln -vs $HOME/.config/udev/udev_rules/* /etc/udev/rules.d/
sudo ln -vs $HOME/.config/udev/udev_scripts/* /usr/local/bin/udev_scripts/
sudo udevadm control --reload-rules

