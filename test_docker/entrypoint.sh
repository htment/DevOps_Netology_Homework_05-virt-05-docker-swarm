#!/bin/sh
# Отключаем IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

# Ключ уже в переменной HOST_SSH_PUBKEY из .env
echo "$HOST_SSH_PUBKEY" > /home/art/.ssh/authorized_keys
chown art:art /home/art/.ssh/authorized_keys
chmod 600 /home/art/.ssh/authorized_keys

echo "$HOST_SSH_PUBKEY" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Запускаем Docker 
dockerd --host tcp://0.0.0.0:2375 --host unix:///var/run/docker.sock &
sleep 5

# Запускаем SSH
exec /usr/sbin/sshd -D
