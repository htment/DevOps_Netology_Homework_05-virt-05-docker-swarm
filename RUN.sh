#!/bin/bash

echo "запускаем проект"
echo "запускаем terrafom ...  и создаем ВМ"
/usr/local/bin/terraform apply -auto-approve
bash extetnal_ip.sh
