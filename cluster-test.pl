#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;
use Time::HiRes qw(usleep);

my $redis = RedisDB::Cluster->new(
    startup_nodes => [
        {
            host => '127.0.0.1',
            port => '7000'
        }
    ]
);

$RedisDB::Cluster::DEBUG=1;

my $n = 0;
while ( 1 ) {
    my $i = int rand 16383;
    my $res = $redis->execute( "set", "foo$i", $i );
    warn $res unless "$res" eq 'OK';
    my $got = $redis->execute( "get", "foo$i" );
    warn "got: $got instead of $i" unless "$got" eq $i;

    ($n %= 3)++;
    $res = $redis->execute( "set", "{hash$n}$i", $i);
    warn $res unless "$res" eq 'OK';
    $res = $redis->execute("get", "{hash$n}$i");
    warn "got: $res instead of expected $i" unless "$got" eq $i;

    usleep 100_000;
}
