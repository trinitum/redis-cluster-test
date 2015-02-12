#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB::Cluster;
use List::Util qw(min);

my @node;
my $slot           = 0;
my $MAXSLOT        = 16383;
my $slots_per_node = int( ( $MAXSLOT + 1 ) / 3 + 1 );
my $cluster        = RedisDB::Cluster->new(
    startup_nodes => [
        {
            host => '127.0.0.1',
            port => 7000
        }
    ],
);

my $cluster_nodes;
for ( 0 .. 5 ) {
    my $new_node = {
        host => '127.0.0.1',
        port => 7000 + $_
    };
    say "Initializing '127.0.0.1:700$_'";
    if ( $_ % 2 ) {
        my $master_addr = "127.0.0.1:700" . ( $_ - 1 );
        my ($master_id) =
          map  { $_->{node_id} }
          grep { $_->{address} eq $master_addr } @$cluster_nodes;
        print "Adding new node as a replica of $master_id ($master_addr): ";
        say $cluster->add_new_node( $new_node, $master_id );
    }
    else {
        if ($_) {
            print "Adding new node as a master: ";
            say $cluster->add_new_node($new_node);
        }
        my @slots = $slot .. min( $slot + $slots_per_node, $MAXSLOT );
        $slot += $slots_per_node + 1;
        my $redis = RedisDB->new($new_node);
        print "Adding slots: ";
        say $redis->cluster( 'ADDSLOTS', @slots );
        $cluster_nodes = $redis->cluster_nodes;
    }
}

sleep 3;
say $cluster->random_connection->cluster('nodes');
