FROM docker:26-dind

# Обновление и установка дополнительных пакетов
RUN apk update && apk upgrade && apk add --no-cache \
    bash \
    openssh \
    sudo \
    shadow \
    python3 \
    py3-pip

# Настройка пользователя art
RUN adduser -D -s /bin/bash art \
    && echo "art:123" | chpasswd \
    && addgroup art docker \
    && addgroup art wheel \
    && echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel

# Генерация SSH ключей и настройка
RUN ssh-keygen -A

# Настройка SSH
RUN mkdir -p /home/art/.ssh \
    && chown art:art /home/art/.ssh \
    && chmod 700 /home/art/.ssh \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/' /etc/ssh/sshd_config

# Создание скрипта запуска
RUN echo '#!/bin/bash' > /entrypoint.sh \
    && echo 'dockerd-entrypoint.sh &' >> /entrypoint.sh \
    && echo 'sleep 5' >> /entrypoint.sh \
    && echo '/usr/sbin/sshd -D' >> /entrypoint.sh \
    && chmod +x /entrypoint.sh

EXPOSE 22 2375 2376

CMD ["/entrypoint.sh"]
