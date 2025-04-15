#!/bin/bash



if [ ! -f "/home/vagrant/.ssh/id_rsa.pub" ]; then

  sudo -u vagrant ssh-keygen -t rsa -b 2048 -f "/home/vagrant/.ssh/id_rsa" -N ""
  cp /home/vagrant/.ssh/id_rsa.pub /vagrant/id_rsa.pub
  echo "68.68.68.10 server" | sudo tee -a /etc/hosts > /dev/null
  echo "Test"
  chmod 600 /home/vagrant/.ssh/authorized_keys

fi
