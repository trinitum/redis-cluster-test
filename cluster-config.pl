#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use RedisDB;
use List::Util qw(min);

my @node;
my $slot           = 0;
my $MAXSLOT        = 16383;
my $slots_per_node = int( ( $MAXSLOT + 1 ) / 3 + 1 );
my $cluster_nodes;
for ( 0 .. 5 ) {
    say "Initializing '127.0.0.1:700$_'";
    $node[$_] = RedisDB->new(
        host => '127.0.0.1',
        port => 7000 + $_
    );
    if ($_) {
        print "Introducing new node: ";
        say $node[$_]->cluster( 'MEET', '127.0.0.1', 7000 + $_ - 1 );
        $cluster_nodes = $node[$_]->cluster_nodes();
    }
    if ( $_ % 2 ) {
        my $master_addr = "127.0.0.1:700" . ($_-1);
        my ($master) =
          map  { $_->{node_id} }
          grep { $_->{address} eq $master_addr } @$cluster_nodes;
        print "Replicating from $master: ";
        say $node[$_]->cluster( 'REPLICATE', $master );
    }
    else {
        my @slots = $slot .. min( $slot + $slots_per_node, $MAXSLOT );
        $slot += $slots_per_node;
        print "Adding slots: ";
        say $node[$_]->cluster( 'ADDSLOTS', @slots );
    }
}
