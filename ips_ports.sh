#!/bin/sh

NETWORK=192.168.XX
FILE="ips_ports_improve.txt"
true > "$FILE"  # Ensure the file is empty

printf "********** SCANNING NETWORK ********** %s\n" "$NETWORK"

# Use xargs to run search_ports in parallel
seq 1 254 | xargs -n 1 -P 50 -I {} bash -c "
search_ports() {
    TARGET=\"\$1\"
    save_ip=false

    for PORT in \$(seq 1 1024); do
        if echo \"\" | nc -w 1 -z \"\$TARGET\" \"\$PORT\" >/dev/null 2>&1; then
            if [ \"\$save_ip\" = false ]; then
                printf \"\nFound IP \$TARGET\"
                echo \"IP \$TARGET\" >> \"$FILE\"
                save_ip=true
            fi

            echo \"Port \$PORT is open!\"
            echo \"- port \$PORT\" >> \"$FILE\"
        fi
    done
}
search_ports \"$NETWORK.{}\"
"
