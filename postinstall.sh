sudo tftp 192.168.1.129 -c get firstboot
sudo mv firstboot /etc/init.d/
sudo chmod +x /etc/init.d/firstboot
update-rc.d firstboot defaults
