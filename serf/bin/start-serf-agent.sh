#!/bin/bash

SERF_HOME=/usr/local/serf
SERF_BIN=$SERF_HOME/bin/serf
SERF_CONFIG_DIR=$SERF_HOME/etc

# if SERF_JOIN_IP env variable set generate a config json for serf
[[ -n $SERF_JOIN_IP ]] && cat > $SERF_CONFIG_DIR/join.json <<EOF
{
  "start_join" : ["$SERF_JOIN_IP"]
}
EOF

# by default only short hostname would be the nodename
# we need FQDN
cat > $SERF_CONFIG_DIR/node.json <<EOF
{
  "node_name" : "$(hostname -f)"
}
EOF

$SERF_BIN agent -config-dir $SERF_CONFIG_DIR

# or you can use the following oneliner on you Dockerfile
# RUN yum install -y unzip curl && curl -Lso /tmp/serf.zip https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip && unzip /tmp/serf.zip -d /usr/local/bin && rm /tmp/serf.zip
