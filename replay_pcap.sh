#!/bin/bash

# Loop through supplied arguments to find the sniffing interface
args=( "$@" )
i=0
while [[ $i -lt $# ]]
do
    if [[ ${args[$i]} == '-i' ]]; then
        INTERFACE=${args[$i+1]}
    elif [[ ${args[$i]} == '-h' ]]; then
        echo " "
        echo "Usage: replay_pcap.sh -i ens33 <ATTACK>"
        echo "Sniffing Interface Must be supplied (i.e -i ens33)"
        echo " "
        echo "Tags:"
        echo "-i        Sniffing Interface"
        echo "-h        Help"
        echo "Attacks: "
        echo "-eb       EternalBlue"
        echo "-ek       Exploit Kit"
        echo "-scan     SYN Scan"
        echo "-flood    SYN Flood"
        echo "-sql      SQL Injection"
        echo "-xss      XSS"
    fi
    ((i++))
done

# exit if the interface is not supplied
if [ -z "$INTERFACE" ]
then
      echo " "
      echo "Exit: missing interface"
      echo "-h for help"
      exit
else
      echo " "
      echo "...interface supplied"
fi

# select attack
while [ $# -ne 0 ]
do
    opt=$1
    case "$opt" in
    -eb)
       echo "Running EternalBlue"
       tcpreplay -i $INTERFACE eternalblue.pcap
       ;;
    -ek)
       echo "Running Exploit Kit"
       tcpreplay -i $INTERFACE exploit_kit.pcapng
       ;;
    -scan)
       echo "Running SYN Scan"
       tcpreplay -i $INTERFACE syn_scan.pcapng
       ;;
    -flood)
       echo "Running SYN Flood"
       tcpreplay -i $INTERFACE syn_flood.pcapng
       ;;
    -sql)
       echo "Running SQL Injection"
       tcpreplay -i $INTERFACE sql_injection.pcapng
       ;;
    -xss)
       echo "Running XSS"
       tcpreplay -i $INTERFACE xss.pcapng
       ;;
    -i)
       ;;
    -h)
       ;;
    -*)
       echo "Invalid option: '$opt'"
       ;;
   esac
   shift
done
