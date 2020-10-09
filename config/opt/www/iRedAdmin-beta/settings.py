# encoding: utf-8
#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#
#
# Please add your custom settings in file /opt/iredmail/custom/iredadmin/settings.py.
# If you need to modify any settings in this file, please define your custom
# settings in /opt/iredmail/custom/iredadmin/settings.py
# to override settings in this file.
#

############################################################
# DO NOT TOUCH BELOW LINE.
#
from libs.default_settings import *

############################################################
# General settings.
#
# Site webmaster's mail address.
webmaster = "postmaster@PH_FIRST_MAIL_DOMAIN"

# Default language.
default_language = 'en_US'

# Database backend: mysql.
backend = 'mysql'

# Directory used to store mailboxes. Defaults to /var/vmail/vmail1.
# Note: This directory must be owned by 'vmail:vmail' with permission 0700.
storage_base_directory = "/var/vmail/vmail1"

# Default mta transport.
# There're 3 transports available in iRedMail:
#
#   1. dovecot: default LDA transport. Supported by all iRedMail releases.
#   2. lmtp:unix:private/dovecot-lmtp: LMTP (socket listener). Supported by
#                                      iRedMail-0.8.6 and later releases.
#   3. lmtp:inet:127.0.0.1:24: LMTP (TCP listener). Supported by iRedMail-0.8.6
#                              and later releases.
#
# Note: You can set per-domain or per-user transport in account profile page.
default_mta_transport = "dovecot"

# Min/Max admin password length.
#   - min_passwd_length: 0 means unlimited, but at least 1 character
#                        is required.
#   - max_passwd_length: 0 means unlimited.
# User password length is controlled in domain profile.
min_passwd_length = 8
max_passwd_length = 0

#####################################################################
# Database used to store iRedAdmin data. e.g. sessions, log.
#
iredadmin_db_host = "PH_SQL_SERVER_ADDRESS"
iredadmin_db_port = 3306
iredadmin_db_name = "iredadmin"
iredadmin_db_user = "iredadmin"
iredadmin_db_password = "PH_IREDADMIN_DB_PASSWORD"

############################################
# Database used to store mail accounts.
#
vmail_db_host = "PH_SQL_SERVER_ADDRESS"
vmail_db_port = 3306
vmail_db_name = "vmail"
vmail_db_user = "vmailadmin"
vmail_db_password = "PH_VMAIL_DB_ADMIN_PASSWORD"

##############################################################################
# Settings used for Amavisd-new integration. Provides spam/virus quaranting,
# releasing, etc.
#
# Log basic info of in/out emails into SQL (@storage_sql_dsn): True, False.
# It's @storage_sql_dsn setting in amavisd. You can find this setting
# in amavisd-new config files:
#   - On RHEL/CentOS:   /etc/amavisd.conf or /etc/amavisd/amavisd.conf
#   - On Debian/Ubuntu: /etc/amavis/conf.d/50-user.conf
#   - On FreeBSD:       /usr/local/etc/amavisd.conf
amavisd_enable_logging = True
amavisd_db_host = "PH_SQL_SERVER_ADDRESS"
amavisd_db_port = 3306
amavisd_db_name = "amavisd"
amavisd_db_user = "amavisd"
amavisd_db_password = "PH_AMAVISD_DB_PASSWORD"

# #### Quarantining ####
# Release quarantined SPAM/Virus mails: True, False.
# iRedAdmin-Pro will connect to @amavisd_db_host to release quarantined mails.
# How to enable quarantining in Amavisd-new:
# http://www.iredmail.org/docs/quarantining.html
amavisd_enable_quarantine = True
# Port of Amavisd protocol 'AM.PDP-INET'. Default is 9998.
# If Amavisd is not running on database server specified in amavisd_db_host,
# please set the server address in parameter `AMAVISD_QUARANTINE_HOST`.
# Default is "PH_SQL_SERVER_ADDRESS". Sample setting:
#AMAVISD_QUARANTINE_HOST = '192.168.1.1'
amavisd_quarantine_port = 9998

# Enable per-recipient spam policy, white/blacklist.
amavisd_enable_policy_lookup = True
##############################################################################
# Settings used for iRedAPD integration. Provides throttling and more.
#
iredapd_enabled = True
iredapd_db_host = "PH_SQL_SERVER_ADDRESS"
iredapd_db_port = 3306
iredapd_db_name = "iredapd"
iredapd_db_user = "iredapd"
iredapd_db_password = "PH_IREDAPD_DB_PASSWORD"

############################################################################
# Fail2ban integration, used by iRedAdmin-Pro.
#
# Currently only querying banned IP from fail2ban SQL database is supported.
fail2ban_enabled = True
fail2ban_db_host = "PH_SQL_SERVER_ADDRESS"
fail2ban_db_port = 3306
fail2ban_db_name = "fail2ban"
fail2ban_db_user = "fail2ban"
fail2ban_db_password = "PH_FAIL2BAN_DB_PASSWORD"

##############################################################################
# Place your custom settings below, you can override all settings in this file
# and libs/default_settings.py here.
#
DEFAULT_PASSWORD_SCHEME = "SSHA512"
mlmmjadmin_api_auth_token = "PH_MLMMJADMIN_API_TOKEN"

ENABLE_RESTFUL_API = True

AMAVISD_SHOW_NON_LOCAL_DOMAINS = True

# Load extra config file.
from custom_settings import *

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#
#
# Please add your custom settings in file /opt/iredmail/custom/iredadmin/settings.py.
# If you need to modify any settings in this file, please define your custom
# settings in /opt/iredmail/custom/iredadmin/settings.py
# to override settings in this file.
#
