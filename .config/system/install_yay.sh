sudo pacman -Syy
sudo pacman -S --needed --noconfirm base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
if command -v yay $> /dev/null; then
    echo "Success"
    yay --version
else
    echo "Error installing yay"
    exit 1
fi

cd ..
rm -rf yay

