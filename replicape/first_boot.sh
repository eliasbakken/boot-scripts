#!/bin/bash

# Make folder for octoprint
mkdir -p /home/octo
mkdir -p "/home/octo/.octoprint"
chown -R octo:octo "/home/octo/.octoprint"

# Fix permissions for STL upload folder
chown octo:octo /usr/share/models
chmod 777 /usr/share/models

# Make config file for Octoprint
echo "cura:"					 > "/home/octo/.octoprint/config.yaml"
echo "  config: /etc/cura/printer.ini"		>> "/home/octo/.octoprint/config.yaml"
echo "  enabled: true" 				>> "/home/octo/.octoprint/config.yaml"
echo "  path: /usr/share/cura/cura.sh"		>> "/home/octo/.octoprint/config.yaml"
echo "folder:"					>> "/home/octo/.octoprint/config.yaml"
echo "  uploads: /usr/share/models"		>> "/home/octo/.octoprint/config.yaml"
echo "serial:"					>> "/home/octo/.octoprint/config.yaml"
echo "  additionalPorts:"			>> "/home/octo/.octoprint/config.yaml"
echo "    - /dev/octoprint_1"			>> "/home/octo/.octoprint/config.yaml"
echo "  baudrate: 115200"			>> "/home/octo/.octoprint/config.yaml"
echo "  port: /dev/octoprint_1"			>> "/home/octo/.octoprint/config.yaml"

chown octo:octo "/home/octo/.octoprint/config.yaml"

# Run depmod to fix 
sleep 10
depmod -a
systemctl restart pvrsrv
systemctl restart toggle



