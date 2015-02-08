#!/bin/sh

for num in 0 1 2 3 4 5; do
    (cd 700$num; redis-server redis.conf;)
done
