#!/bin/sh

for num in 0 1 2 3 4 5; do
    rm -rf 700$num
    mkdir 700$num
    echo "port 700$num
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
pidfile redis.pid
daemonize yes
logfile 'redis.log'
appendonly yes" > 700$num/redis.conf
done

