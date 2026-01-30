#!/bin/bash

# Загружаем переменные из файла
source ip_env

# Очищаем файл hosts перед началом записи
> hosts

# Записываем заголовок группы [all]
echo "[all]" >> hosts

# Добавляем все ноды в группу [all]
for ((NumNode=0; NumNode<INDEX; NumNode++)); do
    # Создаем имя переменной динамически
    var_name="IP_SWARM_NODE_$NumNode"
    # Используем индирекцию для получения значения
    ip_address="${!var_name}"
    echo "$ip_address" >> hosts
    echo "IP_SWARM_NODE_$NumNode = $ip_address"
done

echo "[swarm_manager]" >> hosts
echo "$IP_SWARM_NODE_0" >> hosts


# Добавляем переменные для всех хостов
echo "" >> hosts
echo "[all:vars]" >> hosts
echo "ansible_ssh_private_key_file=~/.ssh/id_ed25519" >> hosts
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> hosts
# дополнительные настройки:
echo "ansible_user=art" >> hosts
# echo "ansible_python_interpreter=/usr/bin/python3" >> hosts

echo "Файл hosts успешно создан!"