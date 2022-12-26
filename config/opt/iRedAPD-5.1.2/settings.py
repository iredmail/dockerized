#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

############################################################
# DO NOT TOUCH BELOW LINE.
#
# Import default settings.
# You can always override default settings by placing custom settings in this
# file.
from libs.default_settings import *
############################################################

# Listen address and port.
listen_address = '0.0.0.0'
# Port for normal Postfix policy requests.
listen_port = 7777

# Ports for SRS (Sender Rewriting Scheme).
# - `srs_forward_port` is used in Postfix parameter `sender_canonical_maps`.
# - `recipient_canonical_maps` is used in Postfix parameter `recipient_canonical_maps`.
srs_forward_port = 7778
srs_reverse_port = 7779

# Run as a low privileged user.
run_as_user = 'iredapd'

# Path to pid file.
pid_file = '/run/iredapd.pid'

# Log level: info, debug.
log_level = 'info'

# Backend: ldap, mysql, pgsql.
backend = 'mysql'

# Enabled plugins.
plugins = ['reject_null_sender', 'reject_sender_login_mismatch', 'greylisting', 'throttle', 'amavisd_wblist', 'sql_alias_access_policy', 'sql_ml_access_policy']

# SRS (Sender Rewriting Scheme)
#
# Rewrite address will be 'xxx@<srs_domain>', so please make sure `srs_domain`
# is a resolvable mail domain name and pointed to your server.
srs_domain = 'PH_HOSTNAME'

# The secret key(s) used to generate cryptographic hash.
# The first secret key is used for generating AND verifying hash in SRS
# address. If you have old keys, you can append them also for verification only.
srs_secrets = ['PH_IREDAPD_SRS_SECRET']

# For LDAP backend.
#
# LDAP server setting.
# Uri must starts with ldap:// or ldaps:// (TLS/SSL).
#
# Tip: You can get binddn, bindpw from /etc/postfix/ldap/*.cf.
#
ldap_uri = ''
ldap_basedn = ''
ldap_binddn = ''
ldap_bindpw = ''
ldap_enable_tls = False

# For SQL (MySQL/MariaDB/PostgreSQL) backends, used to query mail accounts.
vmail_db_server = 'PH_SQL_SERVER_ADDRESS'
vmail_db_port = PH_SQL_SERVER_PORT
vmail_db_name = 'vmail'
vmail_db_user = 'vmail'
vmail_db_password = 'PH_VMAIL_DB_PASSWORD'

# For Amavisd policy lookup and white/blacklists.
amavisd_db_server = 'PH_SQL_SERVER_ADDRESS'
amavisd_db_port = PH_SQL_SERVER_PORT
amavisd_db_name = 'amavisd'
amavisd_db_user = 'amavisd'
amavisd_db_password = 'PH_AMAVISD_DB_PASSWORD'

# iRedAPD database, used for greylisting, throttle.
iredapd_db_server = 'PH_SQL_SERVER_ADDRESS'
iredapd_db_port = PH_SQL_SERVER_PORT
iredapd_db_name = 'iredapd'
iredapd_db_user = 'iredapd'
iredapd_db_password = 'PH_IREDAPD_DB_PASSWORD'

############################################################
# DO NOT TOUCH BELOW LINE.
from custom_settings import *
############################################################


SQL_DB_DRIVER = 'pymysql'

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Please do NOT touch this file. If you need to modify some settings, add
# them to /opt/iredmail/custom/iredapd/settings.py.
