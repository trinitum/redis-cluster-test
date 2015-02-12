#!/bin/sh

./stop_cluster.sh
./generate_redis_conf.sh
sleep 1
./start_cluster.sh
