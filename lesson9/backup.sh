#!/bin/bash

/usr/bin/mysqldump --defaults-extra-file=/home/vagrant/.my.cnf --databases pets > /opt/mysql_backups/pets_$(date +%F_%H-%M).sql

/usr/bin/rsync -avz /opt/mysql_backups/ vagrant@192.168.56.11:/opt/store/mysql_backups/

if [ $? -eq 0 ]; then
    echo "Бэкап успешно создан и отправлен."
else
    echo "Ошибка при создании бэкапа" >&2
fi
