# Creates a base centos image with serf and dnsmasq
#
# it aims to create a dynamic cluster of docker containers
# each able to refer other by fully qulified domainnames
#
# this isn't trivial as docker has readonly /etc/hosts

FROM tianon/centos:6.5
MAINTAINER SequenceIQ

RUN yum install -y dnsmasq unzip curl

# dnsmasq configuration
ADD dnsmasq.conf /etc/dnsmasq.conf
ADD resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

# install serfdom.io
RUN curl -Lso /tmp/serf.zip https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip
RUN unzip /tmp/serf.zip -d /bin

ENV SERF_CONFIG_DIR /etc/serf

# configure serf
ADD serf-config.json $SERF_CONFIG_DIR/serf-config.json

ADD event-router.sh $SERF_CONFIG_DIR/event-router.sh
RUN chmod +x  $SERF_CONFIG_DIR/event-router.sh

ADD handlers $SERF_CONFIG_DIR/handlers

# docker.io hangs on ADD ???
# https://index.docker.io/builds/github/4622/sequenceiq/docker-serf/builds/brvni7g9r73bb92nqaszgbp/
#ADD serf.sysv.init /etc/init.d/serf
#RUN chmod +x /etc/init.d/serf

ADD start-serf-agent.sh  $SERF_CONFIG_DIR/start-serf-agent.sh
RUN chmod +x  $SERF_CONFIG_DIR/start-serf-agent.sh

EXPOSE 7373

#ENTRYPOINT ["/bin/serf", "agent", "-config-dir", "/etc/serf", "-node", "$(hostname -f)"]
#CMD ["-log-level", "debug"]

CMD /etc/serf/start-serf-agent.sh
