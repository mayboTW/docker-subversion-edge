FROM centos:7

# Upgrading system
RUN yum -y update && \
    yum -y install wget && \
    yum install -y java-1.8.0-openjdk && \
    yum clean all && \
    mkdir /usr/java && \
    ln -s /etc/alternatives/jre /usr/java/latest

ENV JAVA_HOME /etc/alternatives/jre

RUN \
  yum install -y epel-release && \
  yum install -y net-tools python-setuptools hostname inotify-tools yum-utils && \
  yum clean all && \
  easy_install supervisor

ENV FILE https://downloads-guests.open.collab.net/files/documents/61/17071/CollabNetSubversionEdge-5.2.0_linux-x86_64.tar.gz

RUN wget -q ${FILE} -O /tmp/csvn.tgz && \
    mkdir -p /opt/csvn && \
    tar -xzf /tmp/csvn.tgz -C /opt/csvn --strip=1 && \
    rm -rf /tmp/csvn.tgz

ENV RUN_AS_USER collabnet


RUN useradd collabnet && \
    chown -R collabnet.collabnet /opt/csvn && \
    cd /opt/csvn && \
    ./bin/csvn install && \
    mkdir -p ./data-initial && \
    cp -r ./data/* ./data-initial

EXPOSE 3343 4434 18080

ADD files /

VOLUME /opt/csvn/data

WORKDIR /opt/csvn

ENTRYPOINT ["/config/bootstrap.sh"]
