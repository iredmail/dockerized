#!/bin/bash
# Purpose: Install all packages for a ALL-IN-ONE docker image.
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Required binary packages.
PKGS_BASE="ca-certificates logrotate mailx rsyslog rsyslog-openrc supervisor"
PKGS_MYSQL="mariadb mariadb-client"
PKGS_NGINX="nginx"
PKGS_PHP_FPM="php7 php7-bz2 php7-curl php7-dom php7-fileinfo php7-fpm php7-session php7-gd php7-gettext php7-iconv php7-imap php7-intl php7-json php7-mbstring php7-openssl php7-xml php7-zip"
PKGS_POSTFIX="postfix postfix-pcre postfix-mysql"
PKGS_DOVECOT="dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql"
PKGS_AMAVISD="amavisd-new perl-dbd-mysql unarj gzip bzip2 unrar cpio lzo lha lrzip lz4 p7zip"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav clamav-libunrar"
PKGS_IREDAPD="python3 py3-pip py3-sqlalchemy py3-dnspython py3-mysqlclient py3-more-itertools"
PKGS_IREDADMIN="python3 py3-pip py3-more-itertools py3-requests py3-jinja2 py3-netifaces py3-simplejson uwsgi uwsgi-python3 uwsgi-syslog"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="python3 py3-pip py3-requests py3-more-itertools uwsgi-python3 uwsgi-syslog"
PKGS_FAIL2BAN="fail2ban"
PKGS_ROUNDCUBE="php7-mysqli php7-pdo_mysql php7-dom php7-ctype php7-ldap php7-json php7-gd php7-mcrypt php7-curl php7-intl php7-xml php7-mbstring php7-session php7-zip mariadb-client aspell php7-pspell"

# Required Python modules.
PIP_MODULES="web.py==0.61"

# Required directories.
WEB_APP_ROOTDIR="/opt/www"

# Install packages.
apk add --no-cache --progress \
    ${PKGS_BASE} \
    ${PKGS_MYSQL} \
    ${PKGS_NGINX} \
    ${PKGS_PHP_FPM} \
    ${PKGS_POSTFIX} \
    ${PKGS_DOVECOT} \
    ${PKGS_AMAVISD} \
    ${PKGS_SPAMASSASSIN} \
    ${PKGS_CLAMAV} \
    ${PKGS_IREDAPD} \
    ${PKGS_IREDADMIN} \
    ${PKGS_MLMMJ} \
    ${PKGS_MLMMJADMIN} \
    ${PKGS_FAIL2BAN} \
    ${PKGS_ROUNDCUBE}

# Install Python modules.
/usr/bin/pip3 install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

# Create required directories.
mkdir -p ${WEB_APP_ROOTDIR}

# Install iRedAPD.
wget -c https://github.com/iredmail/iRedAPD/archive/4.6.tar.gz && \
tar xzf 4.6.tar.gz -C /opt && \
rm -f 4.6.tar.gz && \
ln -s /opt/iRedAPD-4.6 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-4.6 && \
chmod -R 0500 /opt/iRedAPD-4.6 && \

# Install mlmmjadmin.
wget -c https://github.com/iredmail/mlmmjadmin/archive/3.0.4.tar.gz && \
tar zxf 3.0.4.tar.gz -C /opt && \
rm -f 3.0.4.tar.gz && \
ln -s /opt/mlmmjadmin-3.0.4 /opt/mlmmjadmin && \
cd /opt/mlmmjadmin-3.0.4 && patch -p1 < /mlmmjadmin-2.1.patch && rm -f /mlmmjadmin-2.1.patch && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-3.0.4 && \
chmod -R 0500 /opt/mlmmjadmin-3.0.4

# Install Roundcube.
wget -c https://github.com/roundcube/roundcubemail/releases/download/1.4.9/roundcubemail-1.4.9-complete.tar.gz && \
tar zxf roundcubemail-1.4.9-complete.tar.gz -C /opt/www && \
rm -f roundcubemail-1.4.9-complete.tar.gz && \
ln -s /opt/www/roundcubemail-1.4.9 /opt/www/roundcubemail && \
chown -R root:root /opt/www/roundcubemail-1.4.9 && \
chmod -R 0755 /opt/www/roundcubemail-1.4.9 && \
cd /opt/www/roundcubemail-1.4.9 && \
chown -R nginx:nginx temp logs && \
chmod 0000 CHANGELOG INSTALL LICENSE README* UPGRADING installer SQL

# Install iRedAdmin (open source edition).
wget -c https://github.com/iredmail/iRedAdmin/archive/1.2.tar.gz && \
tar xzf 1.2.tar.gz -C /opt/www && \
rm -f 1.2.tar.gz && \
ln -s /opt/www/iRedAdmin-1.2 /opt/www/iredadmin && \
chown -R iredadmin:iredadmin /opt/www/iRedAdmin-1.2 && \
chmod -R 0555 /opt/www/iRedAdmin-1.2

