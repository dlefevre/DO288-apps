#!/bin/bash

cat > /tmp/users.sql <<ENDQL
CREATE TABLE IF NOT EXISTS users (
    user_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    email varchar(100) NOT NULL,
    PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
insert into users(name, email) values ('user1','user1@example.com');
insert into users(name, email) values ('user2','user2@example.com');
insert into users(name, email) values ('user3','user3@example.com');
ENDSQL

while [[ $HOOK_RETRIES -ne 0 ]]; do
    echo "Checking DB..."
    if mysqlshow -h$MYSQL_SERVICE_HOST -P3306 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE &>/dev/null; then
        echo Database is up
        break
    fi
    echo Database is down
    sleep $HOOK_SLEEP
    (( HOOK_RETRIES-- ))
done

if [[ $HOOK_RETRIES -eq 0 ]]; then
    echo "Too many retries..."
    exit 1
fi

mysql h$MYSQL_SERVICE_HOST -P3306 -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < /tmp/users.sql

