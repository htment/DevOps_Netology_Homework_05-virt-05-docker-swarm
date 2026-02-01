#!/bin/bash

echo "запускаем проект"
echo "запускаем terrafom ...  и создаем ВМ"
/usr/local/bin/terraform apply -auto-approve
echo "обрабатываем адреса........."
echo Создаем "конфигаруционыe файлы ......."
bash external_ip.sh
bash external_hosts.sh
bash make_env.yml.sh
#export HOST_SSH_PUBKEY="$(cat ~/.ssh/id_rsa.pub)"


#ssh-keygen -f "/home/art/.ssh/known_hosts" -R "172.22.0.100"
#ssh-keygen -f "/home/art/.ssh/known_hosts" -R "172.22.0.101"
#ssh-keygen -f "/home/art/.ssh/known_hosts" -R "172.22.0.102"



ansible-playbook playbook.yml -i hosts 
ansible-playbook playbook_swarm.yml -i hosts