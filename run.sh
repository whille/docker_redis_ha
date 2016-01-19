#!/bin/bash
ROLE=MASTER
PEER_IP=192.168.140.149
VIP=192.168.140.250

CUR_DIR=$(dirname $(readlink -f $(ls $0)))

docker run \
    -v /dev:/dev -v /lib/modules:/lib/modules \
    --cap-add=NET_ADMIN --net=host \
    -e ROLE=$ROLE \
    -e PEER_IP=$PEER_IP \
    -e VIP=$VIP \
    --name=redis_ha \
    -d redis_ha
