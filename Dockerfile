FROM tianon/centos:6.5
MAINTAINER SequenceIQ

ADD serf /usr/local/serf
RUN /usr/local/serf/bin/install-serf.sh

EXPOSE 7373 7946
CMD /usr/local/serf/bin/start-serf-agent.sh
