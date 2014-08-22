FROM sequenceiq/pam
MAINTAINER SequenceIQ

RUN yum install -y unzip curl && curl -Lso /tmp/serf.zip https://dl.bintray.com/mitchellh/serf/0.6.1_linux_amd64.zip && mkdir -p /usr/local/serf/bin && unzip /tmp/serf.zip -d /usr/local/serf/bin && ln -s /usr/local/serf/bin/serf /usr/local/bin/serf && rm /tmp/serf.zip
ENV SERF_HOME /usr/local/serf
ADD serf $SERF_HOME

EXPOSE 7373 7946
CMD /usr/local/serf/bin/start-serf-agent.sh
