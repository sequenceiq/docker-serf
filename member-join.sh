#!/bin/bash

#for var in ${!SERF*}; do echo ${var}=${!var};done

while read line ;do
  NEXT_HOST=$(echo $line|cut -d' ' -f 1)
  NEXT_SHORT=${NEXT_HOST%%.*}
  NEXT_IP=$(echo $line|cut -d' ' -f 2)
  cat >> /etc/dnsmasq.d/0hosts <<EOF
address="/$NEXT_HOST/$NEXT_SHORT/$NEXT_IP"
EOF

done

service dnsmasq restart
