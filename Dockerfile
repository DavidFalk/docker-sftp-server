FROM      debian:jessie

MAINTAINER David Falk

RUN      apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN groupadd sftpusers

ADD ./sshd_config /etc/ssh/sshd_config
ADD ./start.sh /start.sh

RUN chmod 644 /etc/ssh/sshd_config
RUN chmod +x /start.sh

VOLUME /backup/
VOLUME /ssh
EXPOSE 22

CMD ./start.sh
