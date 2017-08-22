# DUT Configuration: #

## in /etc/rc.conf: ##

### Use static ARP: ###
static_arp_pairs="pktgen pktrecv"
static_arp_pktgen="192.168.100.101 00:25:90:05:7B:AC"
static_arp_pktrecv="192.168.102.101 00:25:90:05:7B:AD"

### Use static routes for the test networks: ###
static_routes="pktgen pktrecv"
route_pktgen="-net 198.18.10.1/24 -gateway 192.168.100.101"
route_pktrecv="-net 198.19.10.1/24 -gateway 192.168.102.101"

## in /etc/sysctl.conf: ##

### Enable forwarding: ###
net.inet.ip.forwarding=1

### Disable ethernet flow control ###
dev.ix.0.fc=0
dev.ix.1.fc=0

## in /boot/loader.conf: ##

### Disable ethernet flow control ###
hw.ix.flow_control=0
