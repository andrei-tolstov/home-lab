#!/bin/sh
#/opt/etc/ndm/netfilter.d/100-redirect.sh
# opkg install ipset ip


[ "$type" == "ip6tables" ] && exit 0

if [ -z "$(iptables-save 2>/dev/null | grep amneziawg)" ]; then

   ipset create amneziawg hash:ip -exist
   iptables -I PREROUTING -t mangle -m set --match-set amneziawg dst -j MARK --set-mark 1
   ip route add table vpnrouting default dev nwg0
   ip rule add prio 99 fwmark 1 lookup vpnrouting
   sh /opt/root/rp_filter_change.sh
fi


# перенаправляю все днс 

if [ -z "$(iptables-save 2>/dev/null | grep "udp \-\-dport 53 \-j DNAT")" ]; then
   iptables -w -t nat -I PREROUTING -i br0 -p udp --dport 53 -j DNAT --to 192.168.50.1
fi

if [ -z "$(iptables-save 2>/dev/null | grep "tcp \-\-dport 53 \-j DNAT")" ]; then
   iptables -w -t nat -I PREROUTING -i br0 -p tcp --dport 53 -j DNAT --to 192.168.50.1
fi

exit 0

# if [ -z "$(iptables-save 2>/dev/null | grep unblock)" ]; then
   # ipset create unblock hash:net -exist
   # insmod /lib/modules/4.9-ndm-5/xt_multiport.ko
   # insmod /lib/modules/4.9-ndm-5/xt_connbytes.ko
   # insmod /lib/modules/4.9-ndm-5/xt_NFQUEUE.ko

   # iptables -t mangle -I POSTROUTING -o ppp0 -p tcp -m set --match-set zapret dst -j NFQUEUE --queue-num 200 --queue-bypass
   #iptables -w -t nat -A PREROUTING -i br0 -p tcp -m set --match-set unblock dst -j REDIRECT --to-port 999
   
  # iptables -w -t nat -A PREROUTING -i sstp0 -p tcp -m set --match-set unblock dst -j REDIRECT --to-port 999

   #iptables -t nat -A OUTPUT -p tcp -m set --match-set unblock dst -j REDIRECT --to-port 999
# fi