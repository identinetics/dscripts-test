FROM centos:centos7
LABEL maintainer="Rainer Hörbe <r2h2@hoerbe.at>" \
      version="0.0.0" \
      didi_dir="https://raw.githubusercontent.com/identinetics/dscripts-test/master/didi" \
      capabilities='--cap-drop=all'

# EPEL
RUN yum -y install epel-release \
 && yum clean all
