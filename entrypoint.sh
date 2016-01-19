#!/bin/bash

KA_CONF=/etc/keepalived/keepalived.conf

if [[ $ROLE != "MASTER" ]]; then
    sed -i 's/REDIS_1/REDIS_2/'           $KA_CONF
    sed -i 's/state MASTER/state BACKUP/' $KA_CONF
    sed -i 's/priority 150/priority 100/' $KA_CONF
fi

sed -i 's/^daemonize.*/daemonize yes/' /etc/redis.conf
sed -i "s/\(REDIS_MASTER_IP=\).*/\1${PEER_IP}/" /usr/local/bin/redis_ctl.sh

exec "$@"
