#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;
use Getopt::Long;

GetOptions(
    'host=s'            => \my $host,
    'port=i'            => \my $port,
    'master=s'          => \my $master,
    'cluster-address=s' => \my @startup_nodes,
    'debug'             => \$RedisDB::Cluster::DEBUG,
);

$host //= '127.0.0.1';
$port or die "You must specify port of the redis instance";

@startup_nodes =
  map { my ( $host, $port ) = split /:/; { host => $host, port => $port } }
  @startup_nodes;

my $cluster = RedisDB::Cluster->new(
    startup_nodes => \@startup_nodes,
);

$cluster->add_new_node(
    {
        host => $host,
        port => $port
    },
    $master
);
my $redis = RedisDB->new(
    host => $host,
    port => $port
);
my $cluster_nodes = $redis->cluster_nodes;
my ($new_node) = grep { $_->{flags}{myself} } @$cluster_nodes;

say "added node has id $new_node->{id}";
