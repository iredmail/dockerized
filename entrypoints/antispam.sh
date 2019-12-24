#!/bin/sh

. /docker/entrypoints/functions.sh

DKIM_DIR="/opt/iredmail/custom/amavisd/dkim"
DKIM_KEY="${DKIM_DIR}/${FIRST_MAIL_DOMAIN}.pem"

# Generate DKIM key for first mail domain.
[[ -d ${DKIM_DIR} ]] || install -d -o amavis -g amavis -m 0770 ${DKIM_DIR}
[[ -f ${DKIM_KEY} ]] || /usr/sbin/amavisd genrsa ${DKIM_KEY} 1024
chown amavis:amavis ${DKIM_KEY}
chmod 0400 ${DKIM_KEY}

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" /etc/amavisd.conf
