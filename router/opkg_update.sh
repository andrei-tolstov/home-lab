#!/opt/bin/sh
opkg update && opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade