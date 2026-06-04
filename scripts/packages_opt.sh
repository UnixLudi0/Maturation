#davinci-resolve-studio
yay -S --noconfirm davinci-resolve-studio
sudo mkdir /opt/resolve/libs/disabled-libraries
sudo mv /opt/resolve/libs/libglib* /opt/resolve/libs/libgio* /opt/resolve/libs/libgmodule* disabled-libraries

#throne
yay -S --noconfirm throne
