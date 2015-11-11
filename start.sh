#!/bin/bash
: ${CLIENTS:?"Need to set CLIENTS"}

if ls /ssh/ssh_host_* 1> /dev/null 2>&1; then
    rm -v /etc/ssh/ssh_host_*
    cp /ssh/ssh_host_* /etc/ssh/
else
    cp /etc/ssh/ssh_host_* /ssh/
fi
chmod -R 700 /etc/ssh/ssh_host_*

IFS=':' read -a clientsarray <<< "$CLIENTS"

for client in "${clientsarray[@]}"; do
    useradd --shell /usr/sbin/nologin --home-dir /backup/$client --no-create-home -G sftpusers $client
    usermod -p '*' $client
    if [ ! -d /backup/$client ]
    then
        echo "Creating $client home directory"
	mkdir -p /backup/$client
	mkdir /backup/$client/.ssh
	touch /backup/$client/.ssh/authorized_keys
    fi
    chown -R $client /backup/$client
    chmod -R 700 /backup/$client
done

echo "Starting sftp server"

exec /usr/sbin/sshd -D -e
