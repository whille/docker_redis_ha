#!/bin/bash
#
#Script start Redis and promote to MASTER/SLAVE
#(The MIT License)
#Copyright (C) 2011 Alex Williams
#
# Usage Options:
#   -m    promote the redis-server to MASTER
#   -s    promote the redis-server to SLAVE
#   -k    start the redis-server and promote it to MASTER
#
#########################
# User Defined Variables
#########################

DAEMON=/usr/local/bin/redis-server
DAEMON_ARGS=/etc/redis.conf
REDIS_COMMANDS="/usr/local/bin/redis-cli"
REDIS_MASTER_IP="192.168.1.10"   #the VIP
REDIS_MASTER_PORT=6379


##############
# Exit Codes
##############

E_INVALID_ARGS=65
E_INVALID_COMMAND=66
E_NO_SLAVES=67
E_DB_PROBLEM=68

##########################
# Script Functions
##########################
error() {
        E_CODE=$?
        echo "Exiting: ERROR ${E_CODE}: $E_MSG"

        exit $E_CODE
}

start_redis() {
      alive=`${REDIS_COMMANDS} PING`
      if [ "$alive" != "PONG" ]; then
        ${DAEMON} ${DAEMON_ARGS}
        sleep 1
      fi
}

start_master() {
        ${REDIS_COMMANDS} SLAVEOF no one
}

start_slave() {
        ${REDIS_COMMANDS} SLAVEOF ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT}
}

usage() {
        echo  "Start Redis and promote to MASTER/SLAVE  "
        echo  "Options: "
        echo  "-m promote the redis-server to MASTER"
        echo  "-s promote the redis-server to SLAVE"
        echo  "-k start the redis-server and promote it to MASTER"
        echo  ""

        exit $E_INVALID_ARGS
}
for arg in "$@"
do
        case $arg in
        -m) arg_m=true;;
        -s) arg_s=true;;
        -k) arg_k=true;;
        *) usage;;
        esac
done

if [ $arg_m ]; then
        echo  "Promoting redis-server to MASTER"
        start_redis
        wait
        start_master
elif [ $arg_s ]; then
        echo  "Promoting redis-server to SLAVE"
        start_redis
        wait
        start_slave
elif [ $arg_k ]; then
        echo  "Starting redis-server and promoting to MASTER"
        start_redis
        wait
        start_master
else
        usage
fi
