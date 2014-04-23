# Creates an Ambari Server base on vanilla centos
#
# docker build -t seq/ambari ambari-base

FROM tianon/centos
#FROM ambnew-installed-clean
MAINTAINER SequenceIQ

# dnsmasq
RUN yum install -y dnsmasq

# dnsmasq configuration
RUN echo 'listen-address=127.0.0.1' >> /etc/dnsmasq.conf
RUN echo 'resolv-file=/etc/resolv.dnsmasq.conf' >> /etc/dnsmasq.conf
RUN echo 'conf-dir=/etc/dnsmasq.d' >> /etc/dnsmasq.conf
RUN echo 'user=root' >> /etc/dnsmasq.conf

# google dns
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf
RUN echo 'nameserver 8.8.4.4' >> /etc/resolv.dnsmasq.conf

# google dns
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.dnsmasq.conf
RUN echo 'nameserver 8.8.4.4' >> /etc/resolv.dnsmasq.conf


RUN yum install -y sudo openssh-server openssh-clients unzip curl ntp

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# service sshd start

# install serfdom.io
RUN curl -Lso /tmp/serf.zip https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip
RUN unzip /tmp/serf.zip -d /bin

ADD event-router.sh /etc/serf/event-router.sh
RUN chmod +x /etc/serf/event-router.sh

ADD member-join.sh /etc/serf/handlers/member-join/member-join.sh
RUN chmod +x /etc/serf/handlers/member-join/member-join.sh

ADD serf.sysv.init /etc/init.d/serf
RUN chmod +x /etc/init.d/serf
