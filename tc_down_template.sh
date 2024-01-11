#!/bin/bash

# Author: Tyler McCann (@tylerdotrar)
# Arbitrary Version Number: 1.0.1
# Link: https://github.com/tylerdotrar/tc-taps

###
#    If 'network_taps' no longers exists, you can verify active TAPs with the following command:
#
#    tc qdisc show | grep ingress | awk '{print $5}' > network_taps
###

echo "Disabling TC Network TAP(s):"

# Read every active TAP interface in 'network_taps' and Murder Death Kill them
while read i;
do
    echo "- $i"
    tc qdisc del dev $i ingress
    tc qdisc del dev $i root
    tc filter del dev $i root
done < network_taps
