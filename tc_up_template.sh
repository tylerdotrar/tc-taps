#!/bin/bash

# Author: Tyler McCann (@tylerdotrar)
# Arbitrary Version Number: 1.0.0
# Link: https://github.com/tylerdotrar/tc-taps

###
#    Every VM/LXC has a network TAP interface based on their ID's and interface(s).
#
#    VM Example:      ID: 125 ; net0: vmbr0, net1: vmbr5
#    Network Tap(s):  tap125i0, tap125i1
#
#    LXC Example:     ID: 203 ; net0: vmbr9
#    Network Tap(s):  veth203i0
#
#    Check With:      ip --brief a | grep 'tap\|veth' | sed 's/@.*//g'
###

# TAP anything involving 10 (e.g., 1001 - 1099 range).
ID_RANGE=10
# Virtual SPAN port to mirror traffic to.
SPAN_PORT='vmbr100'

# Add TAPs for above ID range to a 'network_taps' file.
ip --brief a | grep "tap\|veth" | sed 's/@.*//g' | grep $ID_RANGE | awk '{print $1}' > network_taps

# OR you can manually include specific ID's.
#echo tap<id_1>i0 > network_taps
#echo tap<id_2>i0 >> network_taps

echo "Enabling TC Network TAPs:"

# Read every TAP interface in 'network_taps' and forward traffic to a designated SPAN port
while read i;
do
    echo "- $i"
    tc qdisc add dev $i ingress
    tc filter add dev $i parent ffff: protocol all u32 match u8 0 0 action mirred egress mirror dev $SPAN_PORT
    tc qdisc add dev $i handle 1: root prio
    tc filter add dev $i parent 1: protocol all u32 match u8 0 0 action mirred egress mirror dev $SPAN_PORT
done < network_taps
