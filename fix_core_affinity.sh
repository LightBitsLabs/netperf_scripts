#!/bin/bash

set +x 

ifconfig $1 mtu 1500

eth0irq=`cat /proc/interrupts | grep $1 | awk '{print$1}' | sed 's/://g'`
core=0
for i in $eth0irq; 
do
	echo "Setting $1 affinity of $i to $core"
	echo "Was `cat /proc/irq/$i/smp_affinity`"
	echo "$core" > /proc/irq/$i/smp_affinity_list
	echo "Now `cat /proc/irq/$i/smp_affinity`"
	core=$(($core + 1))
	echo "Core is $core"
done
