#!/bin/sh

# capture ip from ethernet interface
filter=$(tshark -1 enp7s0 -T fields -f "udp" -e ip.dst -Y "ip.dst!=192.168.0.0/16 and ip.dst!=10.0.0.0/8 
and ip.dst!=172.16.0.0/12" -c 100 | sort -u | xargs | sed "s/ / and ip.dst!=/g" | sed "s/^/ip.dst!=/g")

# waiting for the user
echo "Press enter and call your target"
read -r line

# process traffic
tshark -i enp7s0 -l -T fields -f "udp" -e ip.dst -Y "$filter" -Y "ip.dst!=192.168.0.0/16 and ip.dst!=10.0.0.0/8
and ip.dst!=172.16.0.0/12" | while read -r line; do whois "$line" > /tmp/b

    #analyse whois information
    filter=$(grep -i -v -E "facebook|google" /tmp/b | xargs | wc -l)

    #log target information
    if [ "$filter" -gt 0 ]; then
        targetinfo=$(grep -i -E "OrgName:|NetName:|Country:" /tmp/b)
        echo "$line --- $targetinfo"
    fi
done