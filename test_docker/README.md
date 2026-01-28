# Docker-in-Docker и Docker Swarm Setup

Этот проект содержит конфигурации для запуска Docker-in-Docker и Docker Swarm кластера.

## Файлы проекта

- `Dockerfile` - Образ с Docker-in-Docker и SSH доступом
- `docker-compose.yml` - Запуск одиночного DIND контейнера
- `compose.yml` - Запуск Docker Swarm кластера (3 ноды)
- `run.sh` - Скрипт автоматического запуска
- `hosts` - Ansible inventory файл
- `plabook.yml` - Ansible playbook для установки Docker
- `entrypoint.sh` - Скрипт запуска контейнера
- `TEST_RESULTS.md` - Результаты тестирования

## Способ 1: Запуск одиночного контейнера (docker-compose)

### Автоматический запуск:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
chmod +x run.sh
./run.sh
```

### Ручной запуск:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
docker compose -f docker-compose.yml up -d --build
```

### Подключение к контейнеру:
```bash
# По SSH
ssh art@localhost -p 2223
# Пароль: 123

# Или напрямую через docker exec
docker exec -it dind-container bash
```

### Проверка работы Docker внутри контейнера:
```bash
docker exec dind-container docker --version
docker exec dind-container docker run hello-world
```

### Остановка контейнера:
```bash
docker compose -f docker-compose.yml down
```

## Способ 2: Запуск Docker Swarm кластера

### Запуск кластера из 3 нод:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
docker compose -f compose.yml up -d --build
```

### Подключение к нодам:
```bash
# Manager нода
ssh art@localhost -p 2220

# Worker ноды
ssh art@localhost -p 2221  # swarm-node2
ssh art@localhost -p 2222  # swarm-node3
# Пароль: 123
```

### Настройка Swarm:
```bash
# На manager ноде (порт 2220)
docker swarm init --advertise-addr 172.22.0.100

# Получить токен для worker нод
docker swarm join-token worker

# На worker нодах выполнить команду с токеном
docker swarm join --token <TOKEN> 172.22.0.100:2377
```

### Остановка кластера:
```bash
docker compose -f compose.yml down
```

## Способ 3: Запуск через docker run

### Сборка образа:
```bash
docker build -t docker-in-docker .
```

### Запуск контейнера:
```bash
docker run -d \
  --name dind-container \
  --privileged \
  -p 2223:22 \
  -p 2375:2375 \
  -p 2376:2376 \
  -v docker-data:/var/lib/docker \
  -e DOCKER_TLS_CERTDIR= \
  docker-in-docker
```

### Подключение:
```bash
ssh art@localhost -p 2223
# Пароль: 123
```

### Остановка и удаление:
```bash
docker stop dind-container
docker rm dind-container
docker volume rm docker-data
```

## Важные замечания

1. **Privileged режим**: Контейнер запускается с флагом `--privileged`, что необходимо для работы Docker-in-Docker
2. **Порты одиночного контейнера**: 
   - 2223 - SSH доступ
   - 2375/2376 - Docker API (если нужен удаленный доступ)
3. **Порты Swarm кластера**:
   - 2220-2222 - SSH доступ к нодам
   - 12377 - Swarm manager порт
   - 17946-17948 - Overlay network
   - 14789-14791/udp - VXLAN ports
4. **Volumes**: Данные Docker сохраняются в named volume `docker-data`
5. **Пользователь**: 
   - Имя: art
   - Пароль: 123
   - Имеет sudo права и входит в группу docker

## Проверка работы

После подключения к контейнеру выполните:

```bash
# Проверка версии Docker
docker --version

# Запуск тестового контейнера
docker run hello-world

# Просмотр запущенных контейнеров
docker ps -a

# Запуск nginx для теста
docker run -d -p 8080:80 nginx

# Проверка
curl localhost:8080
```

## Структура сети Docker Swarm

Кластер использует кастомную сеть `swarm-network` с подсетью `172.22.0.0/24`:
- swarm-node1 (Manager): 172.22.0.100
- swarm-node2 (Worker): 172.22.0.101  
- swarm-node3 (Worker): 172.22.0.102

## Использование с Ansible

**Важно**: Текущий playbook предназначен для Ubuntu систем, но контейнеры используют Alpine Linux.

Для использования с Ubuntu хостами:

```ini
[docker_hosts]
dind-container ansible_host=localhost ansible_port=2223 ansible_user=art ansible_password=123 ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Запуск playbook:
```bash
ansible-playbook -i hosts plabook.yml
```

## Тестирование

Результаты тестирования доступны в файле `TEST_RESULTS.md`. Основные тесты:

```bash
# Проверка DIND
docker exec dind-container docker run --rm hello-world

# Проверка Swarm (после инициализации)
docker exec swarm-node1 docker node ls
```

## Устранение неполадок

1. **Проблемы с портами**: Убедитесь, что порты 2220-2223 свободны
2. **Проблемы с правами**: Контейнер должен запускаться в privileged режиме
3. **Проблемы с Ansible**: Playbook предназначен для Ubuntu, не для Alpine
4. **Очистка при ошибках**:
   ```bash
   docker compose -f docker-compose.yml down -v
   docker compose -f compose.yml down -v
   ```
