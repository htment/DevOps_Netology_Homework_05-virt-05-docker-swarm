# Docker-in-Docker Setup

Эта конфигурация позволяет запускать Docker внутри Docker контейнера.

## Способ 1: Использование docker-compose (Рекомендуется)

### Запуск контейнера:
```bash
cd DevOps_Homework/05-virt-05-docker-swarm/test_docker
docker-compose up -d --build
```

### Подключение к контейнеру:
```bash
# По SSH
ssh art@localhost -p 2222
# Пароль: 123

# Или напрямую через docker exec
docker exec -it dind-container bash
```

### Проверка работы Docker внутри контейнера:
```bash
docker ps
docker run hello-world
```

### Остановка контейнера:
```bash
docker-compose down
```

### Полная очистка (включая volumes):
```bash
docker-compose down -v
```

## Способ 2: Запуск через docker run

### Сборка образа:
```bash
docker build -t docker-in-docker .
```

### Запуск контейнера:
```bash
docker run -d \
  --name dind-container \
  --privileged \
  -p 2222:22 \
  -p 2375:2375 \
  -p 2376:2376 \
  -v dind-data:/var/lib/docker \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -e DOCKER_TLS_CERTDIR= \
  docker-in-docker
```

### Подключение:
```bash
ssh art@localhost -p 2222
# Пароль: 123
```

### Остановка и удаление:
```bash
docker stop dind-container
docker rm dind-container
docker volume rm dind-data
```

## Важные замечания

1. **Privileged режим**: Контейнер запускается с флагом `--privileged`, что необходимо для работы Docker-in-Docker
2. **Порты**: 
   - 2222 - SSH доступ
   - 2375/2376 - Docker API (если нужен удаленный доступ)
3. **Volumes**: Данные Docker сохраняются в named volume `docker-data`
4. **Пользователь**: 
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

## Использование с Ansible

Обновленный hosts файл для подключения через SSH:

```ini
[docker_hosts]
dind-container ansible_host=localhost ansible_port=2222 ansible_user=art ansible_password=123 ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Запуск playbook:
```bash
ansible-playbook -i hosts plabook.yml
```
