#!/bin/bash
mysql -uroot -p${MYSQL_ROOT_PASSWORD} <<EOF
CREATE DATABASE IF NOT EXISTS user_service_db;
CREATE DATABASE IF NOT EXISTS product_service_db;
CREATE DATABASE IF NOT EXISTS order_service_db;

CREATE USER 'springstudent'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';

GRANT ALL PRIVILEGES ON user_service_db.* TO 'springstudent'@'%';
GRANT ALL PRIVILEGES ON product_service_db.* TO 'springstudent'@'%';
GRANT ALL PRIVILEGES ON order_service_db.* TO 'springstudent'@'%';

FLUSH PRIVILEGES;
EOF
