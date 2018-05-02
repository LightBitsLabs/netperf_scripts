# netperf_scripts
scripts to measure network performance using netperf

- run fix_core_affinity.sh as root : sudo fix_core_affinity.sh <iface_name>

- run netserver on target : netserver -L <target iface_ip> -p <port>

- for running stream/maertz tests on client : stream/maertz_netperf.sh <target_ip> <target_port> <cores> <test_time_in_seconds> <packet_size_in_bytes>

- for running rr_test on client : rr_netperf.sh <target_ip> <target_port> <cores> <test_time> <test_time_in_seconds> <local_pkt_size> <remote_packet_size>
