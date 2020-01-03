#!/bin/sh

install -d -o root -g root -m 0755 /var/log/php-fpm
install -d -o nginx -g nginx -m 0755 /run/php-fpm
