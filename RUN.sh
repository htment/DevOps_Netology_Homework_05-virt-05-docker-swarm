#!/bin/bash

echo "запускаем проект"
echo "запускаем terrafom ...  и создаем ВМ"
/usr/local/bin/terraform apply -auto-approve
echo "обрабатываем адреса"
bash extetnal_ip.sh
