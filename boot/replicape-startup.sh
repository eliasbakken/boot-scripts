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

# Grant octo redeem restart rights
echo "%octo ALL=NOPASSWD: /bin/systemctl restart redeem.service" >> /etc/sudoers
echo "%octo ALL=NOPASSWD: /bin/systemctl restart toggle.service" >> /etc/sudoers

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

easy_install requests==2.3.0


apt-mark hold python-flask python-werkzeug python-tornado \
python-sockjs-tornado python-PyYAML \
python-Flask-Login python-Flask-Principal python-Flask-Babel \
python-Flask-Assets python-pyserial python-netaddr \
python-watchdog python-sarge python-netifaces python-pylru \
python-rsa python-pkginfo python-requests python-semantic-version python-psutil

update_initramfs () {
        if [ -f /boot/initrd.img-$(uname -r) ] ; then
                sudo update-initramfs -u -k $(uname -r)
        else
                sudo update-initramfs -c -k $(uname -r)
        fi
}

update_initramfs


# Update the EEPROM if missing
update_eeprom () {
        header=`head -c 4 /sys/bus/i2c/drivers/at24/2-0054/at24-1/nvmem`
        valid=`echo -n -e '\xaa\x55\x33\xee'`
        if [ "$header" == "$valid" ] ; then
                echo "Found valid signaure, not updating"
        else
                echo "Invalid header signature, updating to Replicape Rev 00B3"
                cat /opt/scripts/replicape/Replicape_00B3.eeprom > /sys/bus/i2c/drivers/at24/2-0054/at24-1/nvmem
        fi
}

update_eeprom
