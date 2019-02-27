#Dockerfile for a Postfix email relay service
FROM centos:latest
MAINTAINER Juan Luis Baptiste juan.baptiste@gmail.com

RUN yum install -y epel-release && yum update -y
RUN yum install -y cyrus-sasl cyrus-sasl-plain cyrus-sasl-md5 mailx
RUN yum install -y perl supervisor postfix rsyslog \
    && rm -rf /var/cache/yum/* \
    && yum clean all
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf

COPY etc/*.conf /etc/
COPY etc/rsyslog.d/* /etc/rsyslog.d
COPY run.sh /
RUN chmod +x /run.sh
COPY checksitehealth.sh /
RUN chmod +x /checksitehealth.sh
COPY sites.txt /
RUN chmod +x /sites.txt
COPY etc/supervisord.d/*.ini /etc/supervisord.d/
RUN newaliases

EXPOSE 25
#ENTRYPOINT ["/run.sh"]
CMD ["/run.sh"]