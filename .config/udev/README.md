You can't use $HOME in udev scripts. So it's best to place them in a system directory:

```
chmod +x $HOME/.config/udev/udev_scripts/*
sudo mkdir -vp /usr/local/bin/udev_scripts/
sudo mkdir -vp /etc/udev/rules.d/
sudo ln -s $HOME/.config/udev/udev_rules/* /etc/udev/rules.d/
sudo ln -s $HOME/.config/udev/udev_scripts/* /usr/local/bin/udev_scripts/
sudo udevadm control --reload-rules
```

2025-04-03: Simplified udev rules for switching output. There is an issue with xrandr delay after booting. Logs with a description are included.

