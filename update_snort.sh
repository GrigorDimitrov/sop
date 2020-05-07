#!/bin/bash

# update Snort rules
cp -f local.rules /etc/nsm/rules/local.rules && rule-update

# edit Snort variables
## sniffing interface
printf "\nPlesae, enter your sniffing interface name (e.g. ens33)\n"
read -p 'Sniffing Interface: ' intf

## network address
printf "\nPlesae, enter the network address of $intf (e.g. 192.168.198.0/24). Make sure the subnet is included (i.e. /24)\n"
read -p 'Monitoring Network: ' netw

# edit /etc/nsm/$hostname+"-"+$intf/snort.conf

sed -i "s|^ipvar HOME_NET .*$|ipvar HOME_NET $netw|" /etc/nsm/"$HOSTNAME-$intf"/snort.conf
