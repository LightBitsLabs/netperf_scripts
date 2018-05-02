#!/bin/bash

results=()

host_cpu_num=$(grep -c ^processor /proc/cpuinfo)

function stream()
{
    local ip=$1
    local port=$2
    local req_pktsize=$3
    local rcv_pktsize=$4
    local i=$5
    local core=$(($i % $host_cpu_num))
    local test_time=$6
    results[$i]=$(netperf -P 0 -H $ip -T $core,$core -p $port -t omni -l $test_time -f m -- -d rr -r $req_pktsize,$rcv_pktsize -D 1,1 -k THROUGHPUT,TRANSACTION_RATE >> /tmp/_out)
}


if [ "$#" -ne 6 ] ; then
      exit 1
fi

rm -rf /tmp/_out

for i in `seq 1 $3`; do 
    stream $1 $2 $5 $6 $i $4 &
done

wait
awk -F'TRANSACTION_RATE=' '{sum+=$2} END {print "Transcation rate " sum}' /tmp/_out
awk -F'THROUGHPUT=' '{sum+=$2} END {print "Throughput " sum " [Mb/s]"}' /tmp/_out
