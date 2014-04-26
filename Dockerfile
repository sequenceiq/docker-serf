# Creates a base centos image with serf and dnsmasq
#
# it aims to create a dynamic cluster of docker containers
# each able to refer other by fully qulified domainnames
#
# this isn't trivial as docker has readonly /etc/hosts

FROM tianon/centos
MAINTAINER SequenceIQ

RUN yum install -y dnsmasq unzip curl

# dnsmasq configuration
ADD dnsmasq.conf /etc/dnsmasq.conf
ADD resolv.dnsmasq.conf /etc/resolv.dnsmasq.conf

# install serfdom.io
RUN curl -Lso /tmp/serf.zip https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip
RUN unzip /tmp/serf.zip -d /bin

# configure serf
ADD event-router.sh /etc/serf/event-router.sh
RUN chmod +x /etc/serf/event-router.sh

ADD member-join.sh /etc/serf/handlers/member-join/member-join.sh
RUN chmod +x /etc/serf/handlers/member-join/member-join.sh

ADD serf.sysv.init /etc/init.d/serf
RUN chmod +x /etc/init.d/serf

ENTRYPOINT /bin/bash

# # ssh
# RUN yum install -y sudo openssh-server openssh-clients ntp
#
# # ssh config
# RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
# RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
# RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
# RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
