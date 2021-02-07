FROM centos:7

MAINTAINER Dusty Lefevre <dusty.lefevre@cronos.be>

LABEL Component="httpd" \
      Name="do288/httpd-parent" \
      Version="1.0" \
      Release="1"

LABEL io.k8s.description="A basic Apache HTTPD Server parent image wiht ONBUILD instructions." \
      io.k8s.display-name="Apache HTTPD Server parent image" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="apache,httpd"

ENV DOCROOT=/var/www/html \
    LANG=en_US \
    LOG_PATH=/var/log/httpd

RUN yum install -y --setopt=tsflags=nodocs --noplugins httpd \
 && yum clean all --noplugins -y \
 && echo "Hello from the httpd-parent container!" > ${HOME}/index.html
    
ONBUILD COPY src/ ${DOCROOT}/

EXPOSE 80

RUN rm -rf /run/httpd \
 && mkdir -p /run/httpd

USER root

CMD /usr/sbin/apachectl -DFOREGROUND
