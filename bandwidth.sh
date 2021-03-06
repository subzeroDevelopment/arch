#!/bin/bash

################################
# Shows bandwidth
#
# @param {String(tx|rx)} type: The bandwidth type to check
# @return {Number(kB/s)}: Speed of the interface
################################

dir=$(dirname $0)
source $dir/util.sh

#type=$BLOCK_INSTANCE
type=$1


file=/tmp/i3blocks_bandwidth_$type
touch $file

prev=$(cat $file)
cur=0

netdir=/sys/class/net
for iface in $(ls -1 $netdir); do
	# Skip the loopback interface
	if [ "$iface" == "lo" ]; then continue; fi

	f=$netdir/$iface/statistics/${type}_bytes
	n=$(cat $f)
	cur=$(expr $cur + $n)
done

delta=$(calc "$cur - $prev")
echo "$(calc "$delta / 1000") kB/s"

# store result
echo $cur > $file
