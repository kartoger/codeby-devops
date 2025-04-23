#!/bin/bash

# Создает папку myfolder в домашней папке текущего пользователя
mkdir -p /home/$(whoami)/lesson10/myfolder

# Создает 5 файлов в папке:
touch myfolder/file{1,2,3,4,5}

# 1 - имеет две строки: 1) приветствие, 2) текущее время и дата
echo -e "Hello;)\n$(date)" > myfolder/file1

# 2 - пустой файл с правами 777
chmod 777 myfolder/file2

# 3 - одна строка длиной в 20 случайных символов
head /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20 > myfolder/file3

# 4-5 пустые файлы
