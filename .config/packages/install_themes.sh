sudo pacman -S lxappearance kvantummanager

echo "Starting Tela Circle icon theme installation"
cd /tmp
git clone https://github.com/vinceliuice/Tela-circle-icon-theme
cd Tela-circle-icon-theme
echo "Installing Tela Circle icon theme"
./install.sh -c black
rm -rf /tmp/Tela-circle-icon-theme

echo "Starting Graphite GTK theme installation"
cd /tmp
git clone https://github.com/vinceliuice/Graphite-gtk-theme
cd Graphite-gtk-theme
echo "Installing dependencies for Graphite GTK theme"
sudo pacman -S sassc gnome-themes-extra
yay -S gtk-engine-murrine
echo "Installing Graphite GTK theme"
./install.sh --libadwaita --tweaks black
rm -rf /tmp/Graphite-gtk-theme
echo "Change your GTK theme in lxappearance"

echo "Starting Graphite KDE theme installation"
cd /tmp
git clone https://github.com/vinceliuice/Graphite-kde-theme
cd Graphite-kde-theme
echo "Installing Graphite KDE theme"
./install.sh --libadwaita --tweaks black
rm -rf /tmp/Graphite-kde-theme
echo "Change your KDE theme in kvantummanager"

