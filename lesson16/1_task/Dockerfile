# Базовый образ alpine:latest
FROM alpine:latest

# Установка nginx
RUN apk update
RUN apk add nginx

# Создание папки 
RUN mkdir -p /opt/www

# В папке файл index.html
WORKDIR /opt/www
COPY ./index.html .
COPY dog.png .

# Создать конфиг nginx 
RUN mkdir -p /etc/nginx/conf.d
COPY ./nginx.conf /etc/nginx/nginx.conf

# открыть порт для nignx
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]