#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;
use Getopt::Long;

GetOptions(
    'host=s' => \my $host,
    'port=i' => \my $port,
    'debug'  => \$RedisDB::Cluster::DEBUG,
);

$host //= '127.0.0.1';

my $cluster = RedisDB::Cluster->new(
    startup_nodes => [
        {
            host => $host,
            port => $port
        }
    ]
);
$cluster->remove_node(
    {
        host => $host,
        port => $port
    }
);
