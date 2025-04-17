#!/bin/bash

ROLE=$1

if [[ "$ROLE" == "server" ]]; then
  
  echo "...APACHE INSTALL..."
  
  sudo apt update -y
  sudo apt install apache2 -y
  
  echo "...OPENSSL INSTALL..."
  
  sudo apt install openssl -y
  
  echo "...OPENSSL_KEY_CREATE..."
  
  sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/kartoger.local.key \
    -out /etc/ssl/certs/kartoger.local.crt \
    -subj "/C=KZ/ST=Almaty/L=Talgar/O=KartogerOrg/CN=kartoger.local"
    
    
    sudo cp /etc/ssl/certs/kartoger.local.crt /usr/local/share/ca-certificates/
    sudo update-ca-certificates
    sudo cp /usr/local/share/ca-certificates/kartoger.local.crt /vagrant
  
  echo "127.0.0.1 kartoger.local www.kartoger.local" | sudo tee -a /etc/hosts
  echo "...CONF APACHE..."
  
  sudo tee /etc/apache2/sites-available/kartoger.local.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName kartoger.local
    ServerAlias www.kartoger.local
    Redirect / https://kartoger.local/
    
</VirtualHost>

<VirtualHost *:443>
    ServerName kartoger.local
    DocumentRoot /opt/apache/www

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/kartoger.local.crt
    SSLCertificateKeyFile /etc/ssl/private/kartoger.local.key
    <Directory /opt/apache/www>
            Options Indexes FollowSymLinks
            AllowOverride None
            Require all granted
    </Directory>
</VirtualHost>
EOF

  echo "...CREATE INDEX.HTML..."
  sudo mkdir -p /opt/apache/www
  sudo tee /opt/apache/www/index.html > /dev/null <<EOF
  <!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>kartoger.local</title>
</head>
<body>
    <h1>Проверка HTTPS </h1>

</body>
</html>
EOF
  sudo chown -R www-data:www-data /opt/apache/www
  sudo chmod -R 755 /opt/apache/www
  sudo a2enmod ssl
  sudo a2ensite kartoger.local.conf
  sudo a2dissite 000-default.conf
  sudo systemctl reload apache2
  
  
elif [[ "$ROLE" == "client" ]]; then
  echo "192.168.56.10 kartoger.local www.kartoger.local" | sudo tee -a /etc/hosts
  if [ -f /vagrant/kartoger.local.crt ]; then
    sudo cp /vagrant/kartoger.local.crt /usr/local/share/ca-certificates/
    sudo update-ca-certificates
  fi
fi
