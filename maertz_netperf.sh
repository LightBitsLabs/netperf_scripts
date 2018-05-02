#!/bin/bash

results=()

host_cpu_num=$(grep -c ^processor /proc/cpuinfo)

function stream()
{
    local ip=$1
    local port=$2
    local pktsize=$3
    local i=$4
    local core=$(($i % $host_cpu_num))
    local test_time=$5
    results[$i]=$(netperf -P 0 -H $ip -T $core,$core -p $port -t omni -l $test_time -f m -- -d maertz -m $pktsize -k THROUGHPUT >> /tmp/_out)
}


if [ "$#" -ne 5 ] ; then
      echo "pass ip address and port number as seperate params"
      exit 1
fi

rm -rf /tmp/_out

for i in `seq 1 $3`; do 
    stream $1 $2 $5 $i $4 &
done

wait
awk -F'=' '{sum+=$2} END {print "Throughput " sum " [Mb/s]"}' /tmp/_out

