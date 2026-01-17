sudo sed -i '/^#en_US\.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo sed -i '/^#en_DK\.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo sed -i '/^#ru_RU\.UTF-8 UTF-8/s/^#//' /etc/locale.gen

sudo locale-gen

echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
echo "LC_TIME=en_DK.UTF-8" | sudo tee -a /etc/locale.conf

sudo timedatectl set-timezone Asia/Tbilisi
