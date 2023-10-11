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
PKGS_DOVECOT="dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-managesieved dovecot-sieve dovecot-mysql dovecot-fts-xapian"
PKGS_AMAVISD="amavisd-new libcrypt-openssl-rsa-perl libmail-dkim-perl altermime arj nomarch cpio liblz4-tool lzop cabextract p7zip-full rpm libmail-spf-perl unrar-free pax libdbd-mysql-perl"
PKGS_SPAMASSASSIN="spamassassin"
PKGS_CLAMAV="clamav-freshclam clamav-daemon"
PKGS_IREDAPD="python3-sqlalchemy python3-dnspython python3-pymysql python3-ldap python3-psycopg2 python3-more-itertools"
PKGS_IREDADMIN="python3-jinja2 python3-netifaces python3-bcrypt python3-dnspython python3-simplejson python3-more-itertools"
PKGS_MLMMJ="mlmmj altermime"
PKGS_MLMMJADMIN="uwsgi uwsgi-plugin-python3 python3-requests python3-pymysql python3-psycopg2 python3-ldap python3-more-itertools"
PKGS_FAIL2BAN="fail2ban bind9-dnsutils iptables"
PKGS_ROUNDCUBE="php-bz2 php-curl php-gd php-imap php-intl php-json php-ldap php-mbstring php-mysql php-pgsql php-pspell php-xml php-zip mcrypt mariadb-client aspell"
PKGS_ALL="wget gpg-agent supervisor mailutils less vim-tiny
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

# Required directories.
export WEB_APP_ROOTDIR="/opt/www"

# Install packages.
echo "Install base packages."
apt-get update && apt-get install -y --no-install-recommends apt-utils rsyslog

echo "Install packages: ${PKGS_ALL}"
apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PKGS_ALL}

########################SOGO INSERTED#########################
echo "Update SOGo nightly Archive."
export SOGo_NIGHTLY="https://packages.inverse.ca/SOGo/nightly/5/ubuntu/ jammy jammy"
echo "deb ${SOGo_NIGHTLY}" >> /etc/apt/sources.list.d/SOGo.list
## Add key 19CDA6A9810273C4: public key "Inverse Support (package signing) <support@inverse.ca>" imported
#apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-key 19CDA6A9810273C4
PKGS_SOGo="sogo sogo-activesync sope4.9-gdl1-mysql memcached" #sogo-eala rms-notify sogo-tool

# Add OpenPGP Key
wget -O- 'http://pgp.mit.edu/pks/lookup?op=get&search=0xCB2D3A2AA0030E2C' | gpg --dearmor | apt-key add -
wget -O- 'https://keys.openpgp.org/vks/v1/by-fingerprint/74FFC6D72B925A34B5D356BDF8A27B36A6E2EAE9' | gpg --dearmor | apt-key add -


# Create temporary file /usr/share/doc/sogo/test.sh to avoid an error in the
# post-install script of SOGo package.
mkdir -p /usr/share/doc/sogo/ \
    && touch /usr/share/doc/sogo/test.sh
echo "Install packages: ${PKGS_SOGo}"
apt-get update && apt-get install -y --no-install-recommends ${PKGS_SOGo}
##############################################################


# Install Python modules.
/usr/bin/pip3 install \
    --no-cache-dir \
     \
    ${PIP_MODULES}

apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*

# Create required directories.
mkdir -p ${WEB_APP_ROOTDIR}

# Install iRedAPD.
wget -c -q https://github.com/iredmail/iRedAPD/archive/5.3.tar.gz && \
tar xzf 5.3.tar.gz -C /opt && \
rm -f 5.3.tar.gz && \
ln -s /opt/iRedAPD-5.3 /opt/iredapd && \
chown -R iredapd:iredapd /opt/iRedAPD-5.3 && \
chmod -R 0500 /opt/iRedAPD-5.3 && \

# Install mlmmjadmin.
wget -c -q https://github.com/iredmail/mlmmjadmin/archive/3.1.7.tar.gz && \
tar zxf 3.1.7.tar.gz -C /opt && \
rm -f 3.1.7.tar.gz && \
ln -s /opt/mlmmjadmin-3.1.7 /opt/mlmmjadmin && \
cd /opt/mlmmjadmin-3.1.7 && \
chown -R mlmmj:mlmmj /opt/mlmmjadmin-3.1.7 && \
chmod -R 0500 /opt/mlmmjadmin-3.1.7

# Install Roundcube.
wget -c -q https://github.com/roundcube/roundcubemail/releases/download/1.6.1/roundcubemail-1.6.1-complete.tar.gz && \
tar zxf roundcubemail-1.6.1-complete.tar.gz -C /opt/www && \
rm -f roundcubemail-1.6.1-complete.tar.gz && \
ln -s /opt/www/roundcubemail-1.6.1 /opt/www/roundcubemail && \
chown -R root:root /opt/www/roundcubemail-1.6.1 && \
chmod -R 0755 /opt/www/roundcubemail-1.6.1 && \
cd /opt/www/roundcubemail-1.6.1 && \
chown -R www-data:www-data temp logs && \
chmod 0000 CHANGELOG.md INSTALL LICENSE README* UPGRADING installer SQL

# Install iRedAdmin (open source edition).
wget -c -q https://github.com/iredmail/iRedAdmin/archive/2.3.tar.gz && \
tar xzf 2.3.tar.gz -C /opt/www && \
rm -f 2.3.tar.gz && \
ln -s /opt/www/iRedAdmin-2.3 /opt/www/iredadmin && \
chown -R iredadmin:iredadmin /opt/www/iRedAdmin-2.3 && \
chmod -R 0555 /opt/www/iRedAdmin-2.3
