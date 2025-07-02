# Базовый образ debian:11
FROM debian:11

# Установка nginx
RUN apt-get update
RUN apt-get install -y nginx

# Создание папки 
RUN mkdir -p /opt/www

# В папке файл index.html
WORKDIR /opt/www
COPY ./index.html .
COPY dog2.png .

# Создать конфиг nginx 
RUN mkdir -p /etc/nginx/conf.d
COPY ./nginx.conf /etc/nginx/nginx.conf

# открыть порт для nignx
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]