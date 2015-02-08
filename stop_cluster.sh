#!/bin/sh

for num in 0 1 2 3 4 5; do
    kill `cat 700$num/redis.pid`
done
