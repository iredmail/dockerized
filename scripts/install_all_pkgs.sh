#!/bin/sh
# Purpose: Install all packages for a ALL-IN-ONE docker image.
# Author: Zhang Huangbin <zhb@iredmail.org>

# Required binary packages.
PKGS_BASE="ca-certificates rsyslog supervisor"
PKGS_MYSQL="mariadb mariadb-client pwgen"
PKGS_NGINX="nginx"
PKGS_PHP_FPM="php7 php7-bz2 php7-curl php7-dom php7-fileinfo php7-fpm php7-session php7-gd php7-gettext php7-iconv php7-imap php7-intl php7-json php7-mbstring php7-openssl php7-xml php7-zip"
PKGS_POSTFIX="postfix postfix-pcre postfix-mysql"
PKGS_DOVECOT="dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql"
PKGS_AMAVISD="amavisd-new perl-dbd-mysql unarj gzip bzip2 unrar cpio lzo lha lrzip lz4 p7zip"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav"
PKGS_IREDAPD="py2-sqlalchemy py-setuptools py2-dnspython py2-mysqlclient py2-pip py2-more-itertools py2-six py2-markdown"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="py-requests uwsgi uwsgi-python uwsgi-syslog py2-more-itertools py2-six py2-markdown"
PKGS_ROUNDCUBE="php7-mysqli php7-pdo_mysql php7-dom php7-ldap php7-json php7-gd php7-mcrypt php7-curl php7-intl php7-xml php7-mbstring php7-session php7-zip mariadb-client aspell php7-pspell"

# Required Python modules.
PIP_MODULES="jaraco.functools==2.0 web.py==0.40"

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
pip install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

# Create required directories.
mkdir -p ${WEB_APP_ROOTDIR}

# Install iRedAPD.
wget -c https://github.com/iredmail/iRedAPD/archive/3.4.tar.gz && \
tar xjf 3.4.tar.gz -C /opt && \
rm -f 3.4.tar.gz && \
ln -s /opt/iRedAPD-3.4 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-3.4 && \
chmod -R 0500 /opt/iRedAPD-3.4 && \

# Install mlmmjadmin.
wget -c https://github.com/iredmail/mlmmjadmin/archive/2.1.tar.gz && \
tar zxf 2.1.tar.gz -C /opt && \
rm -f 2.1.tar.gz && \
ln -s /opt/mlmmjadmin-2.1 /opt/mlmmjadmin && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-2.1 && \
chmod -R 0500 /opt/mlmmjadmin-2.1

# Install Roundcube.
wget -c https://github.com/roundcube/roundcubemail/releases/download/1.4.2/roundcubemail-1.4.2-complete.tar.gz && \
tar zxf roundcubemail-1.4.2-complete.tar.gz -C /opt/www && \
rm -f roundcubemail-1.4.2-complete.tar.gz && \
ln -s /opt/www/roundcubemail-1.4.2 /opt/www/roundcubemail && \
chown -R root:root /opt/www/roundcubemail-1.4.2 && \
chmod -R 0755 /opt/www/roundcubemail-1.4.2 && \
cd /opt/www/roundcubemail-1.4.2 && \
chown -R nginx:nginx temp logs && \
chmod 0000 CHANGELOG INSTALL LICENSE README* UPGRADING installer SQL
