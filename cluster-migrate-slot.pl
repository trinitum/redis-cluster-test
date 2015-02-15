#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;
$RedisDB::Cluster::DEBUG=1;

my $cluster = RedisDB::Cluster->new(startup_nodes => [{host => '127.0.0.1', port => '7000'}]);
$cluster->migrate_slot(4414, {host => '127.0.0.1', port => 7000});
