#!/usr/bin/env bash

# Detect SQL table
mysql -h PH_SQL_SERVER_ADDRESS \
      -P 3306 \
      -u sogo \
      -p'PH_SOGO_DB_PASSWORD' \
      sogo \
      -e "SELECT 'test-value' FROM users LIMIT 1" | grep 'test-value'

if [ X"$?" != X'0' ]; then
    mysql -h PH_SQL_SERVER_ADDRESS \
          -P 3306 \
          -u sogo \
          -p'PH_SOGO_DB_PASSWORD' \
          sogo \
          -e "CREATE VIEW sogo.users (
    c_uid,
    c_name,
    c_password,
    c_cn,
    mail,
    domain)
AS SELECT username, username, password, name, username, domain
     FROM vmail.mailbox
    WHERE enablesogo=1 AND active=1;"
fi
