#!/bin/sh

# Start all required services.
#   - mariadb
#   - dovecot
#   - iredapd (if enabled)
#   - postfix
#   - nginx
#   - php-fpm
#   - mlmmjadmin

. /entrypoints/functions.sh

run_entrypoint /entrypoints/mariadb.sh --background
run_entrypoint /entrypoints/dovecot.sh --background
