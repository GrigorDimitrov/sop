# SOP Tutorial
Security Onion Packets (SOP) is a tool which can be used to replay attacks against Security Onion. The tool adds new Snort rules, modifies Snort config file and rewrites Pcap files by changing IP addresses.
This tutorial is the first part of a learning framework developed for analysts training. The second part, https://github.com/GrigorDimitrov/AttacksScapy covers generating malicious traffic within a virtual environment.
## Download and Install Security Onion
Download the latest version of Security Onion ISO file from https://github.com/Security-Onion-Solutions/security-onion/blob/master/Verify_ISO.md. Create new virtual machine with the following requirements:
- Linux Ubuntu (64-bit) 
- Memory: 3 GB
- Two network adapters: Host-Only and NAT
- Storage: 20 GB  
Run the VM and follow the installation guide. You will be prompted to setup management and monitoring interfaces. Make sure your monitoring interface is using a Host-Only network adapter. Follow this video for more details https://www.youtube.com/watch?v=jRoQUVY-2Ic.
## Download and setup SOP
Once Security Onion is installed you can proceed with cloning SOP from GitHub. Open a terminal and verify network connectivity.
> ping 8.8.8.8  

Clone the tool from GitHub.
>git clone https://github.com/GrigorDimitrov/sop.git

Check you network configuration. 
>ifconfig

You should see your two network interfaces. The NAT and Host-Only networks (e.g. 192.168.1.0/24) are defined by your hypervisor. You could check which is your management network interface in /etc/network/interfaces.
>cat /etc/network/interfaces

Your monitoring interface might not have an IPv4 address. If your hypervisor is using DHCP, you can run the following command.
>sudo dhclient <INTERFACE>

Change directory into sop. Run setup.sh script to configure Snort. The script adds new Snort rules from local.rules file, configures the Snort $HOME_NET variable. The Pcap files are rewritten and the IP addresses are changed to match your network. You will be prompted to enter monitoring interface and monitoring network. Wait until the script updates Snort and restarts Security Onion services. 
>sudo ./setup.sh

## Replay Attacks
Now you can run the replay_pcap.sh script. Use the -h tag to see the tool usage instructions.
> sudo ./replay_pcap.sh -h

The script allows you to select an attack to be replayed. Sniffing interface must be specified using -i tag (e.g. -i ens33). You can replay EternalBlue attack using the command below.
>sudo ./replay_pcap.sh -i ens33 -eb
