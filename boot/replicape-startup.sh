#!/bin/bash

echo "Replicape first boot script"

# Make folder for octoprint
mkdir -p /home/octo
mkdir -p "/home/octo/.octoprint"
chown -R octo:octo "/home/octo/.octoprint"

# Fix permissions for STL upload folder
chown octo:octo /usr/share/models
chmod 777 /usr/share/models

# Make config file for Octoprint
cp /opt/scripts/replicape/config.yaml /home/octo/.octoprint/
chown octo:octo "/home/octo/.octoprint/config.yaml"

chown octo:octo /etc/redeem/

# Run depmod to fix 
sleep 10
depmod -a
systemctl restart pvrsrv
systemctl restart toggle



