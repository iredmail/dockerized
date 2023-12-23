#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

echo "1 3 * * * certbot renew --webroot -w /var/www/html --post-hook 'ln -sf /etc/letsencrypt/live/${HOSTNAME}/privkey.pem /opt/iredmail/ssl/key.pem; /usr/sbin/service postfix restart; /usr/sbin/service nginx restart; /usr/sbin/service dovecot restart'" > /etc/cron.d/letsencrypt

chmod 0644 /etc/cron.d/letsencrypt

set_cron_file_permission
