#!/bin/bash

# update Snort rules
cp -f local.rules /etc/nsm/rules/local.rules && rule-update

# edit Snort variables
## sniffing interface
printf "\nPlesae, enter your sniffing interface name (e.g. ens33)\n"
read -p 'Sniffing Interface: ' intf

# network address
printf "\nPlesae, enter the network address of $intf (e.g. 192.168.198.0/24). Make sure the subnet is included (i.e. /24)\n"
read -p 'Monitoring Network: ' netw

# verify user input
while [[ ! $netw =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9][0-9]$ ]]; do
    echo "Please enter network/subnet (e.g. 192.168.1.0/24)"
    read -p 'Monitoring Network: ' netw
done
echo Selected Network: $netw

# edit /etc/nsm/$hostname+"-"+$intf/snort.conf
sed -i "s|^ipvar HOME_NET .*$|ipvar HOME_NET $netw|" /etc/nsm/"$HOSTNAME-$intf"/snort.conf

# create client/server IP addresses
ip=`echo $netw | sed -e 's/[0-9]*\/.*$//'`
ip1=${ip}1
ip2=${ip}2

# rewrite pcaps
tcprewrite --endpoints=$ip1:$ip2 --cachefile=eternalblue.cache --infile=eternalblue.pcapng --outfile=output/output_eb.pcap --skipbroadcast

tcprewrite --endpoints=$ip1:$ip2 --cachefile=exploit_kit.cache --infile=exploit_kit.pcapng --outfile=output/output_ek.pcap --skipbroadcast

tcprewrite --endpoints=$ip1:$ip2 --cachefile=sql_injection.cache --infile=sql_injection.pcapng --outfile=output/output_sql.pcap --skipbroadcast

tcprewrite --endpoints=$ip1:$ip2 --cachefile=syn_flood.cache --infile=syn_flood.pcapng --outfile=output/output_flood.pcap --skipbroadcast

tcprewrite --endpoints=$ip1:$ip2 --cachefile=syn_scan.cache --infile=syn_scan.pcapng --outfile=output/output_scan.pcap --skipbroadcast

tcprewrite --endpoints=$ip1:$ip2 --cachefile=xss.cache --infile=xss.pcapng --outfile=output/output_xss.pcap --skipbroadcast
