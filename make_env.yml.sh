source ip_env

cat > .env.yml << EOF
# .env.yml
---
swarm_manager_ip: "$IP_SWARM_NODE_0"
docker_version: "20.10"
# другие переменные
EOF