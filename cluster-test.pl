#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;

my $redis = RedisDB::Cluster->new(
    startup_nodes => [
        {
            host => '127.0.0.1',
            port => '7000'
        }
    ]
);

for ( 1 .. 100 ) {
    my $res = $redis->execute( "set", "foo$_", $_ );
    die $res unless $res eq 'OK';
    my $got = $redis->execute( "get", "foo$_" );
    die "got: $got instead of $_" unless $got eq $_;
}
