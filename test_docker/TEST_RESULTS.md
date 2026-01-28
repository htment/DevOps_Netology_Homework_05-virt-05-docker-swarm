# Результаты тестирования Docker-in-Docker

## ✅ Статус: РАБОТАЕТ

### Проверка выполнена
```bash
docker exec dind-container docker run --rm hello-world
```

### Результат:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
```

## Информация о контейнере

- **Имя**: dind-container
- **Образ**: test_docker-docker-in-docker
- **Статус**: Up and running
- **Порты**: 
  - SSH: 2223 (локальный) → 22 (контейнер)
  - Docker API: 2375, 2376

## Команды для работы

### Запуск контейнера:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
docker compose -f docker-compose.yml up -d
```

### Подключение к контейнеру:
```bash
# Через SSH
ssh art@localhost -p 2223
# Пароль: 123

# Через docker exec
docker exec -it dind-container bash
```

### Запуск контейнеров внутри:
```bash
# Hello World
docker exec dind-container docker run --rm hello-world

# Nginx
docker exec dind-container docker run -d -p 8080:80 nginx

# Ubuntu interactive
docker exec -it dind-container docker run -it --rm ubuntu bash
```

### Проверка статуса:
```bash
# Статус главного контейнера
docker ps | grep dind-container

# Docker внутри контейнера
docker exec dind-container docker --version
docker exec dind-container docker ps -a
```

### Остановка:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
docker compose -f docker-compose.yml down
```

## Исправленные проблемы

1. ✅ Конфликт пакетов OpenSSH - заменен на пакет `openssh`
2. ✅ Конфликт портов - изменен SSH порт с 2222 на 2223
3. ✅ Проблема с cgroup read-only - убрано монтирование /sys/fs/cgroup

## Технические детали

- Базовый образ: `docker:26-dind`
- Режим: `privileged: true`
- Volume для данных: `docker-data`
- Пользователь: art (пароль: 123)
- Группы пользователя: docker, wheel (sudo)
