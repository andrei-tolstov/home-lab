#!/opt/bin/sh
#/opt/root/rp_filter_change.sh
for dir in $(ls -1 /proc/sys/net/ipv4/conf/)
do
	echo "1" > /proc/sys/net/ipv4/conf/$dir/rp_filter
done

echo "2" > /proc/sys/net/ipv4/conf/nwg0/rp_filter
