#!/bin/bash

# Скрипт для запуска Docker-in-Docker контейнера

set -e

echo "=== Запуск Docker-in-Docker контейнера ==="

# Переход в директорию со скриптом
cd "$(dirname "$0")"

# Проверка наличия docker-compose
if command -v docker-compose &> /dev/null; then
    echo "Используется docker-compose..."
    docker-compose up -d --build
    
    echo ""
    echo "✓ Контейнер запущен успешно!"
    echo ""
    echo "Подключение к контейнеру:"
    echo "  ssh art@localhost -p 2222"
    echo "  Пароль: 123"
    echo ""
    echo "Или через docker exec:"
    echo "  docker exec -it dind-container bash"
    echo ""
    echo "Проверка статуса:"
    echo "  docker-compose ps"
    echo ""
    echo "Остановка:"
    echo "  docker-compose down"
    
elif command -v docker &> /dev/null; then
    echo "Используется docker run..."
    
    # Сборка образа
    echo "Сборка Docker образа..."
    docker build -t docker-in-docker .
    
    # Остановка старого контейнера если существует
    if docker ps -a | grep -q dind-container; then
        echo "Остановка существующего контейнера..."
        docker stop dind-container 2>/dev/null || true
        docker rm dind-container 2>/dev/null || true
    fi
    
    # Запуск контейнера
    echo "Запуск контейнера..."
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
    
    echo ""
    echo "✓ Контейнер запущен успешно!"
    echo ""
    echo "Подключение к контейнеру:"
    echo "  ssh art@localhost -p 2222"
    echo "  Пароль: 123"
    echo ""
    echo "Или через docker exec:"
    echo "  docker exec -it dind-container bash"
    echo ""
    echo "Проверка статуса:"
    echo "  docker ps | grep dind-container"
    echo ""
    echo "Остановка:"
    echo "  docker stop dind-container && docker rm dind-container"
else
    echo "Ошибка: Docker не установлен!"
    exit 1
fi

# Ожидание запуска контейнера
echo ""
echo "Ожидание запуска служб в контейнере..."
sleep 5

# Проверка работы
echo ""
echo "Проверка работы Docker в контейнере..."
if docker exec dind-container docker --version; then
    echo ""
    echo "✓ Docker внутри контейнера работает!"
else
    echo ""
    echo "✗ Ошибка: Docker внутри контейнера не запустился"
    echo "Проверьте логи: docker logs dind-container"
    exit 1
fi
