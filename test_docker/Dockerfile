FROM docker:26-dind

COPY ./nginx-compose.yml .
# Обновление и установка дополнительных пакетов
RUN apk update && apk upgrade && apk add --no-cache \
    bash \
    openssh \
    mc \
    sudo \
    shadow \
    python3 \
    py3-pip \
    openssh-server-pam \
    docker \
    docker-cli \
    bash \
    curl \
    wget \
    net-tools \
    iproute2 \
    iptables
    
# Настройка пользователя art
RUN adduser -D -s /bin/bash art \
    && echo "art:123" | chpasswd \
    && addgroup art docker \
    && addgroup art wheel \
    && echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel

# Генерация SSH ключей и настройка
RUN ssh-keygen -A

# Настройка SSH директорий и разрешений
RUN mkdir -p /home/art/.ssh \
    && mkdir -p /root/.ssh \
    && chown art:art /home/art/.ssh \
    && chmod 700 /home/art/.ssh \
    && chmod 700 /root/.ssh \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "PubkeyAcceptedAlgorithms *" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

COPY ./readmi_for_swarm.txt .
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 2375 2376

COPY ./readmi_for_swarm.txt .
ENTRYPOINT ["/entrypoint.sh"]
CMD []