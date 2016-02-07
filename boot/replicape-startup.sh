#!/bin/bash

echo "Replicape first boot script"

# Make folder for octoprint
mkdir -p /home/octo
mkdir -p "/home/octo/.octoprint"
chown -R octo:octo "/home/octo/.octoprint"

# Fix permissions for STL upload folder
mkdir -p /usr/share/models
chown octo:octo /usr/share/models
chmod 777 /usr/share/models

# Make config file for Octoprint
cp /opt/scripts/replicape/config.yaml /home/octo/.octoprint/
chown octo:octo "/home/octo/.octoprint/config.yaml"

# Copy profiles into Cura. 
mkdir -p /home/octo/.octoprint/slicingProfiles/cura/
cp /opt/scripts/replicape/Cura/profiles/*.profile /home/octo/.octoprint/slicingProfiles/cura/
chown octo:octo /home/octo/.octoprint/slicingProfiles/cura/

# Make profiles uploadable via Octoprint
chown octo:octo /etc/redeem/

# Port forwarding
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
/usr/sbin/netfilter-persistent save

# Run depmod to fix 
sleep 10
depmod -a


update_initramfs () {
        if [ -f /boot/initrd.img-$(uname -r) ] ; then
                sudo update-initramfs -u -k $(uname -r)
        else
                sudo update-initramfs -c -k $(uname -r)
        fi
}

update_initramfs

