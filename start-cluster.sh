#!/bin/bash

: ${MYDOMAIN:=mycorp.com}
: ${NODES:=2}
: ${IMAGE:=serf}

# starts the first instance
FIRST=$(docker run -d -dns 127.0.0.1 -h node0.$MYDOMAIN -p 7373 -p 53 $IMAGE)
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" $FIRST)
echo $FIRST_IP

# starts "slaves"
for i in $(seq $NODES); do
  docker run -d -e JOIN_IP=$FIRST_IP -dns 127.0.0.1 -h node${i}.mycorp.com -p 7373 -p 53 $IMAGE
done
