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

# Make profiles uploadable via Octoprint
chown octo:octo /etc/redeem/

# Run depmod to fix 
sleep 10
depmod -a
systemctl restart pvrsrv
systemctl restart toggle


update_initramfs () {
        if [ -f /boot/initrd.img-$(uname -r) ] ; then
                sudo update-initramfs -u -k $(uname -r)
        else
                sudo update-initramfs -c -k $(uname -r)
        fi
}

update_initramfs

echo "BB-BONE-REPLICAP:00B3" > /sys/bus/platform/devices/bone_capemgr/slots
systemctl restart replicape

