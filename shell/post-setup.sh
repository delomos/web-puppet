#!/bin/bash

mysql -uroot < "/vagrant/shell/enable_remote_mysql_access.sql"
sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
sudo service mysql restart
