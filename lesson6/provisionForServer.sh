#!/bin/bash



if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then

  cp /vagrant/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
  cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant ~/.ssh/authorized_keys
fi
