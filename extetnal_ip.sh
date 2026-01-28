#!/bin/bash

# Просто выполняем команду terraform output и выводим результат с именами нод
IP_LIST=$(terraform output -json nodes_external_ip | jq -r '.[]' 2>/dev/null)

INDEX=0

# Очищаем файл ip_env если он существует
> ip_env

echo "Ждем готовности SSH серверов..."
sleep 10  # Ждем 10 секунд пока поднимется SSH

for IP in $IP_LIST; do
    echo "export IP_SWARM_NODE_$INDEX=$IP" >> ip_env
    
    echo "Добавляем $IP в known_hosts..."
    
    # Удаляем старую запись если есть
    ssh-keygen -R $IP 2>/dev/null
    
    # Пробуем несколько раз подключиться
    MAX_RETRIES=5
    RETRY_COUNT=0
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        echo "Попытка $((RETRY_COUNT+1)) из $MAX_RETRIES..."
        KEYS=$(ssh-keyscan -H $IP 2>/dev/null)
        
        if [ -n "$KEYS" ]; then
            echo "$KEYS" >> ~/.ssh/known_hosts
            echo "Успешно добавлен $IP"
            break
        else
            echo "SSH сервер $IP не отвечает, ждем..."
            sleep 5
            ((RETRY_COUNT++))
        fi
    done
    
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
        echo "ВНИМАНИЕ: Не удалось добавить $IP в known_hosts"
    fi
    
    ((INDEX++))
done

echo "Всего нод: $INDEX"

# Загружаем переменные из файла
source ip_env

# Переменная INDEX уже содержит количество нод, так что не нужно уменьшать
# Используем цикл для перебора всех нод
for ((NumNode=0; NumNode<INDEX; NumNode++)); do
    # Создаем имя переменной динамически
    var_name="IP_SWARM_NODE_$NumNode"
    # Используем индирекцию для получения значения
    echo "IP_SWARM_NODE_$NumNode = ${!var_name}"
done