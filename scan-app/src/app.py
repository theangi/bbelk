from scapy.all import *

print('Start Scanning')
ans, unans = sr(IP(dst="192.168.0.2-254")/ICMP())
print(ans)
print(unans)
print('*' * 80)
ans, unans = sr( IP(dst="192.168.0.*")/TCP(dport=80,flags="S") )
print(ans)
print(unans)
print('*' * 80)