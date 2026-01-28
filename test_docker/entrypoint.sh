cat > entrypoint.sh << 'EOF'
#!/bin/sh
# Отключаем IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

# Запускаем Docker 
dockerd --host tcp://0.0.0.0:2375 --host unix:///var/run/docker.sock &

# Ждем 5 секунд
sleep 5

# Запускаем SSH
exec /usr/sbin/sshd -D
EOF