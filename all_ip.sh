#!/bin/bash

NETWORK=192.168.80
FILE_NAME="all_ip.txt"
true > $FILE_NAME

echo "Scanning on network $NETWORK.0/24"
echo "Scanning on network $NETWORK.0/24" > $FILE_NAME

for HOST in $(seq 1 254); do
    if ping -c 1 -W 1 $NETWORK.$HOST >/dev/null 2>&1; then
        echo "Device found at $NETWORK.$HOST"
        echo "Device found at $NETWORK.$HOST" >> $FILE_NAME
    fi
done