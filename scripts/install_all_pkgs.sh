#!/bin/sh
# Purpose: Install all packages for a ALL-IN-ONE docker image.
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Required binary packages.
PKGS_BASE="ca-certificates logrotate rsyslog rsyslog-openrc supervisor"
PKGS_MYSQL="mariadb mariadb-client pwgen"
PKGS_NGINX="nginx"
PKGS_PHP_FPM="php7 php7-bz2 php7-curl php7-dom php7-fileinfo php7-fpm php7-session php7-gd php7-gettext php7-iconv php7-imap php7-intl php7-json php7-mbstring php7-openssl php7-xml php7-zip"
PKGS_POSTFIX="postfix postfix-pcre postfix-mysql"
PKGS_DOVECOT="dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql"
PKGS_AMAVISD="amavisd-new perl-dbd-mysql unarj gzip bzip2 unrar cpio lzo lha lrzip lz4 p7zip"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav"
PKGS_IREDAPD="python2 py-pip"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="uwsgi uwsgi-python uwsgi-syslog"
PKGS_ROUNDCUBE="php7-mysqli php7-pdo_mysql php7-dom php7-ldap php7-json php7-gd php7-mcrypt php7-curl php7-intl php7-xml php7-mbstring php7-session php7-zip mariadb-client aspell php7-pspell"

# Required Python modules.
PIP_MODULES="PyMySQL==0.9.3 web.py==0.40 sqlalchemy==1.3.15 dnspython==1.16.0 requests==2.23.0"

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
    ${PKGS_MLMMJ} \
    ${PKGS_MLMMJADMIN} \
    ${PKGS_ROUNDCUBE}

# Install Python modules.
/usr/bin/pip2 install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

# Create required directories.
mkdir -p ${WEB_APP_ROOTDIR}

# Install iRedAPD.
wget -c https://github.com/iredmail/iRedAPD/archive/3.5.tar.gz && \
tar xzf 3.5.tar.gz -C /opt && \
rm -f 3.5.tar.gz && \
ln -s /opt/iRedAPD-3.5 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-3.5 && \
chmod -R 0500 /opt/iRedAPD-3.5 && \

# Install mlmmjadmin.
wget -c https://github.com/iredmail/mlmmjadmin/archive/2.1.tar.gz && \
tar zxf 2.1.tar.gz -C /opt && \
rm -f 2.1.tar.gz && \
ln -s /opt/mlmmjadmin-2.1 /opt/mlmmjadmin && \
cd /opt/mlmmjadmin-2.1 && patch -p1 < /mlmmjadmin-2.1.patch && rm -f /mlmmjadmin-2.1.patch && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-2.1 && \
chmod -R 0500 /opt/mlmmjadmin-2.1

# Install Roundcube.
wget -c https://github.com/roundcube/roundcubemail/releases/download/1.4.3/roundcubemail-1.4.3-complete.tar.gz && \
tar zxf roundcubemail-1.4.3-complete.tar.gz -C /opt/www && \
rm -f roundcubemail-1.4.3-complete.tar.gz && \
ln -s /opt/www/roundcubemail-1.4.3 /opt/www/roundcubemail && \
chown -R root:root /opt/www/roundcubemail-1.4.3 && \
chmod -R 0755 /opt/www/roundcubemail-1.4.3 && \
cd /opt/www/roundcubemail-1.4.3 && \
chown -R nginx:nginx temp logs && \
chmod 0000 CHANGELOG INSTALL LICENSE README* UPGRADING installer SQL
