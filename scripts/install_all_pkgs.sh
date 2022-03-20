#!/bin/bash
# Purpose: Install all packages for a ALL-IN-ONE docker image.
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

export DEBIAN_FRONTEND='noninteractive'

# Required binary packages.
PKGS_BASE="apt-transport-https bzip2 cron ca-certificates curl dbus dirmngr gzip openssl python3-apt python3-setuptools rsyslog software-properties-common unzip python3-pymysql python3-psycopg2"
PKGS_MYSQL="mariadb-server"
PKGS_NGINX="nginx"
PKGS_PHP_FPM="php-fpm php-cli"
PKGS_POSTFIX="postfix postfix-pcre libsasl2-modules postfix-mysql"
PKGS_DOVECOT="dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-managesieved dovecot-sieve dovecot-mysql"
PKGS_AMAVISD="amavisd-new libcrypt-openssl-rsa-perl libmail-dkim-perl altermime arj nomarch cpio liblz4-tool lzop cabextract p7zip-full rpm libmail-spf-perl unrar-free pax libdbd-mysql-perl"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav-freshclam clamav-daemon"
PKGS_IREDAPD="python3-sqlalchemy python3-dnspython python3-pymysql python3-ldap python3-psycopg2 python3-more-itertools"
PKGS_IREDADMIN="python3-jinja2 python3-netifaces python3-bcrypt python3-dnspython python3-simplejson python3-more-itertools"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="uwsgi uwsgi-plugin-python3 python3-requests python3-pymysql python3-psycopg2 python3-ldap python3-more-itertools"
PKGS_FAIL2BAN="fail2ban bind9-dnsutils iptables"
PKGS_ROUNDCUBE="php-bz2 php-curl php-gd php-imap php-intl php-json php-ldap php-mbstring php-mysql php-pgsql php-pspell php-xml php-zip mcrypt mariadb-client aspell"
PKGS_ALL="wget gpg-agent supervisor mailutils python3-pip less vim-tiny
    ${PKGS_BASE}
    ${PKGS_MYSQL}
    ${PKGS_NGINX}
    ${PKGS_PHP_FPM}
    ${PKGS_POSTFIX}
    ${PKGS_DOVECOT}
    ${PKGS_AMAVISD}
    ${PKGS_SPAMASSASSIN}
    ${PKGS_CLAMAV}
    ${PKGS_IREDAPD}
    ${PKGS_IREDADMIN}
    ${PKGS_MLMMJ}
    ${PKGS_MLMMJADMIN}
    ${PKGS_FAIL2BAN}
    ${PKGS_ROUNDCUBE}"

# Required Python modules.
PIP_MODULES="web.py>=0.62"

# Required directories.
export WEB_APP_ROOTDIR="/opt/www"

# Install packages.
echo "Install base packages."
apt-get update && apt-get install -y apt-utils rsyslog

echo "Install packages: ${PKGS_ALL}"
apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PKGS_ALL}

# Install Python modules.
/usr/bin/pip3 install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

# Create required directories.
mkdir -p ${WEB_APP_ROOTDIR}

# Install iRedAPD.
wget -c -q https://github.com/iredmail/iRedAPD/archive/5.0.4.tar.gz && \
tar xzf 5.0.4.tar.gz -C /opt && \
rm -f 5.0.4.tar.gz && \
ln -s /opt/iRedAPD-5.0.4 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-5.0.4 && \
chmod -R 0500 /opt/iRedAPD-5.0.4 && \

# Install mlmmjadmin.
wget -c -q https://github.com/iredmail/mlmmjadmin/archive/3.1.3.tar.gz && \
tar zxf 3.1.3.tar.gz -C /opt && \
rm -f 3.1.3.tar.gz && \
ln -s /opt/mlmmjadmin-3.1.3 /opt/mlmmjadmin && \
cd /opt/mlmmjadmin-3.1.3 && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-3.1.3 && \
chmod -R 0500 /opt/mlmmjadmin-3.1.3

# Install Roundcube.
wget -c -q https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz && \
tar zxf roundcubemail-1.5.2-complete.tar.gz -C /opt/www && \
rm -f roundcubemail-1.5.2-complete.tar.gz && \
ln -s /opt/www/roundcubemail-1.5.2 /opt/www/roundcubemail && \
chown -R root:root /opt/www/roundcubemail-1.5.2 && \
chmod -R 0755 /opt/www/roundcubemail-1.5.2 && \
cd /opt/www/roundcubemail-1.5.2 && \
chown -R www-data:www-data temp logs && \
chmod 0000 CHANGELOG INSTALL LICENSE README* UPGRADING installer SQL

# Install iRedAdmin (open source edition).
wget -c -q https://github.com/iredmail/iRedAdmin/archive/1.6.tar.gz && \
tar xzf 1.6.tar.gz -C /opt/www && \
rm -f 1.6.tar.gz && \
ln -s /opt/www/iRedAdmin-1.6 /opt/www/iredadmin && \
chown -R iredadmin:iredadmin /opt/www/iRedAdmin-1.6 && \
chmod -R 0555 /opt/www/iRedAdmin-1.6
