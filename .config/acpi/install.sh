sudo systemctl enable --now acpid
sudo ln -vs $XDG_CONFIG_HOME/acpi/events/* /etc/acpi/events/lid
sudo ln -vs $XDG_CONFIG_HOME/acpi/scripts/* /etc/acpi
sudo systemctl restart acpid

