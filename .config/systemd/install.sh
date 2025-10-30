sudo mkdir -vp /etc/systemd/logind.conf.d
sudo ln -vs $HOME/.config/systemd/logind.conf.d/* /etc/systemd/logind.conf.d

sudo mkdir -vp /etc/systemd/sleep.conf.d
sudo ln -vs $HOME/.config/systemd/sleep.conf.d/* /etc/systemd/sleep.conf.d

