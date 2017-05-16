#!/bin/bash

sudo cat <<EOF > /etc/hosts
127.0.0.1 localhost
127.0.1.1 xubuntu Samuel
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

sudo hostnamectl set-hostname PXEMaster
sudo service avahi-daemon restart

filepath=/home/Samuel/PXE

sudo cp -rv $filepath/puppet /etc/

sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -y puppetmaster wakeonlan isc-dhcp-server tftpd-hpa squid-deb-proxy

sudo cp -v $filepath/isc-dhcp-server /etc/default/
sudo cp -v $filepath/dhcpd.conf /etc/dhcp/

sudo service isc-dhcp-server restart

sudo wget https://atlas.hashicorp.com/hashicorp/boxes/precise64/versions/1.1.0/providers/virtualbox.box -O /etc/puppet/modules/physical/files/precise64.box
sudo wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz -O /var/lib/tftpboot/netboot.tar.gz
sudo tar -xvf /var/lib/tftpboot/netboot.tar.gz -C /var/lib/tftpboot/

sudo cp -v $filepath/syslinux.cfg /var/lib/tftpboot/ubuntu-installer/amd64/boot-screens/
sudo cp -v $filepath/preseed.cfg /var/lib/tftpboot/ubuntu-installer/amd64/
sudo cp -v $filepath/postinstall.sh /var/lib/tftpboot/
sudo cp -v $filepath/firstboot /var/lib/tftpboot/

echo "done"
