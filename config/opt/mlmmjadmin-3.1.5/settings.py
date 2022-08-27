############################################################
# DO NOT TOUCH THIS LINE.
from libs.default_settings import *
############################################################

# Listen address and port
listen_address = '0.0.0.0'
listen_port = 7790

# Run as a non-privileged user/group.
run_as_user = 'mlmmj'
run_as_group = 'mlmmj'

# Pid file
pid_file = '/run/mlmmjadmin/mlmmjadmin.pid'

# Log level: info, debug.
log_level = 'info'

# Specify the backend used to query/update meta data stored in SQL/LDAP.
#
# - `backend_api` is used when accessing RESTful API.
# - `backend_cli` is used when you're managing mailing list account with
#                 command line tool like `tools/maillist_admin.py`.
#
# Different backends may require different parameters in settings.py, please
# read the comment lines in `backends/bk_*.py`.
#
# Available backends:
#
#   - bk_iredmail_ldap: for iRedMail with LDAP backends (OpenLDAP, OpenBSD ldapd)
#   - bk_iredmail_sql: for iRedMail with SQL backends (MySQL, MariaDB, PostgreSQL)
#   - bk_none: pure mlmmj, no SQL/LDAP database.
#
# WARNING: For iRedMail users, if you don't have iRedAdmin-Pro, please enable
# proper backend below so that mlmmjadmin will store mailing list accounts in
# SQL/LDAP database.
backend_api = 'bk_none'
backend_cli = 'bk_iredmail_sql'

# A list of API AUTH tokens (secret strings) used for authentication.
# It's strong recommended to use a long string as auth token, program will log
# first 8 characters to help you identity the client.
api_auth_tokens = ['PH_MLMMJADMIN_API_TOKEN']

MLMMJ_SPOOL_DIR = '/var/vmail/mlmmj'
MLMMJ_ARCHIVE_DIR = '/var/vmail/mlmmj-archive'
MLMMJ_SKEL_DIR = '/usr/share/mlmmj/text.skel'
# Send to Amavisd for DKIM signing
MLMMJ_DEFAULT_PROFILE_SETTINGS.update({'smtp_port': 10027})

iredmail_sql_db_type = 'mysql'
iredmail_sql_db_server = 'PH_SQL_SERVER_ADDRESS'
iredmail_sql_db_port = PH_SQL_SERVER_PORT
iredmail_sql_db_name = 'vmail'
iredmail_sql_db_user = 'vmailadmin'
iredmail_sql_db_password = 'PH_VMAIL_DB_ADMIN_PASSWORD'

############################################################
# DO NOT TOUCH BELOW LINE.
from custom_settings import *
############################################################

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Please do NOT touch this file. If you need to modify some settings, add
# them to /opt/iredmail/custom/mlmmjadmin/settings.py.
