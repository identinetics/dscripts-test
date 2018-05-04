FROM centos:centos7
LABEL maintainer="Rainer Hörbe <r2h2@hoerbe.at>" \
      version="0.0.0" \
      #UID_TYPE: select one of root, non-root or random to announce container behavior wrt USER
      UID_TYPE="random" \
      #didi_dir="https://raw.githubusercontent.com/identinetics/dscripts-test/master/didi" \
      capabilities='--cap-drop=all'

ARG UID=343001
ARG USERNAME=default
ENV GID 0
RUN useradd --gid $GID --uid $UID $USERNAME

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl git iproute lsof net-tools openssl tar unzip which wget \
 && yum -y install yum install https://centos7.iuscommunity.org/ius-release.rpm \
 && yum -y install python36u python36u-pip \
 && yum clean all

RUN cd /tmp \
 && curl -O http://shibboleth.net/downloads/tools/xmlsectool/latest/xmlsectool-2.0.0-bin.zip

RUN mkdir -p /opt
COPY install/opt /opt/
RUN chmod +x /opt/bin/*

CMD /opt/bin/start.sh
USER $USERNAME
COPY REPO_STATUS /opt/etc/REPO_STATUS
COPY install/opt/bin/manifest2.sh /opt/bin/manifest2.sh