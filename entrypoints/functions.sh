#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>
# Purpose: Some utility functions used by entrypoint scripts.

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

TIP_FILE='/root/iRedMail/iRedMail.tips'

# System accounts.
SYS_USER_ROOT="root"
SYS_GROUP_ROOT="root"
SYS_USER_SYSLOG="syslog"
SYS_GROUP_SYSLOG="adm"
SYS_USER_NGINX="www-data"
SYS_GROUP_NGINX="www-data"
SYS_USER_VMAIL="vmail"
SYS_GROUP_VMAIL="vmail"
SYS_USER_MYSQL="mysql"
SYS_GROUP_MYSQL="mysql"
SYS_USER_POSTFIX="postfix"
SYS_GROUP_POSTFIX="postfix"
SYS_USER_DOVECOT="dovecot"
SYS_GROUP_DOVECOT="dovecot"
SYS_USER_AMAVISD="amavis"
SYS_GROUP_AMAVISD="amavis"
SYS_USER_CLAMAV="clamav"
SYS_GROUP_CLAMAV="clamav"
SYS_USER_IREDAPD="iredapd"
SYS_GROUP_IREDAPD="iredapd"
SYS_USER_IREDADMIN="iredadmin"
SYS_GROUP_IREDADMIN="iredadmin"
SYS_USER_MLMMJ="mlmmj"
SYS_GROUP_MLMMJ="mlmmj"
SYS_USER_BIND="bind"
SYS_GROUP_BIND="bind"
SYS_USER_MEMCACHED="memcache"
SYS_GROUP_MEMCACHED="memcache"
SYS_USER_NETDATA="netdata"
SYS_GROUP_NETDATA="netdata"
SYS_USER_SOGO="sogo"
SYS_GROUP_SOGO="sogo"

# Commands.
CMD_SED="sed -i -e"
CMD_PERL="perl -pi -e"

# Command used to genrate a random string.
# Usage: password="$(${RANDOM_PASSWORD})"
RANDOM_PASSWORD='eval </dev/urandom tr -dc A-Za-z0-9 | (head -c $1 &>/dev/null || head -c 30)'

#
# System accounts.
#
# Nginx
SYS_USER_NGINX="www-data"
SYS_GROUP_NGINX="www-data"

#
# Nginx
#
NGINX_CONF_DIR_SITES_CONF_DIR="/etc/nginx/sites-conf.d"
NGINX_CONF_DIR_TEMPLATES="/etc/nginx/templates"

LOG_FLAG="[iRedMail]"
LOG() {
    echo -e "\e[32m${LOG_FLAG}\e[0m $@"
}

LOGN() {
    echo -ne "\e[32m${LOG_FLAG}\e[0m $@"
}

LOG_ERROR() {
    echo -e "\e[31m${LOG_FLAG} ERROR:\e[0m $@" >&2
}

LOG_WARNING() {
    echo -e "\e[33m${LOG_FLAG} WARNING:\e[0m $@"
}

check_fqdn_hostname() {
    _host="${1}"

    echo ${_host} | grep '.\..*' &>/dev/null
    if [ X"$?" != X'0' ]; then
        LOG_ERROR "HOSTNAME is not a fully qualified domain name (FQDN)."
        LOG_ERROR "Please fix it in 'iredmail-docker.conf' first."
        exit 255
    fi
}

require_non_empty_var() {
    # Usage: require_non_empty_var <VAR_NAME> <VAR_VALUE>
    _var="$1"
    _value="$2"

    if [[ X"${_value}" == X'' ]]; then
        LOG_ERROR "Variable ${_var} can not be empty, please set it in 'iredmail-docker.conf'."
        exit 255
    fi
}

run_entrypoint() {
    # Usage: run_entrypoint <path-to-entrypoint-script> [arguments]
    _script="$1"
    shift 1
    _opts="$@"

    LOG "[Entrypoint] ${_script} ${_opts}"
    . ${_script} ${_opts}
}

touch_files() {
    # Usage: touch_files <user> <group> <mode> <file> [<file> <file> ...]
    _user="${1}"
    _group="${2}"
    _mode="${3}"
    shift 3
    _files="$@"

    for _f in ${_files}; do
        touch ${_f}
        chown ${_user}:${_group} ${_f}
        chmod ${_mode} ${_f}
    done
}

create_sql_user() {
    # Usage: create_user <user> <password>
    _user="$1"
    _pw="$2"
    _dot_my_cnf="/root/.my.cnf-${_user}"

    cmd_mysql="mysql -u root"

    ${cmd_mysql} mysql -e "SELECT User FROM user WHERE User='${_user}' LIMIT 1" | grep 'User' &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} -e "CREATE USER '${_user}'@'%';"
    fi

    # Reset password.
    #${cmd_mysql} mysql -e "UPDATE user SET Password=password('${_pw}'),authentication_string=password('${_pw}') WHERE User='${_user}';"
    ${cmd_mysql} mysql -e "ALTER USER '${_user}'@'%' IDENTIFIED BY '${_pw}';"

    cat > ${_dot_my_cnf} <<EOF
[client]
host=${SQL_SERVER_ADDRESS}
port=${SQL_SERVER_PORT}
user="${_user}"
password="${_pw}"
EOF

    chown root ${_dot_my_cnf}
    chmod 0400 ${_dot_my_cnf}
}

create_log_dir() {
    _dir="${1}"
    [[ -d ${_dir} ]] || mkdir -p ${_dir}
    chown ${SYS_USER_SYSLOG}:${SYS_GROUP_SYSLOG} ${_dir}
}

create_log_file() {
    _file="${1}"
    [[ -f ${_file} ]] || touch ${_file}
    chown ${SYS_USER_SYSLOG}:${SYS_GROUP_SYSLOG} ${_file}
}

set_cron_file_permission() {
    chmod 0600 /var/spool/cron/crontabs/* &>/dev/null
}

#
# Roundcube
#
update_rc_setting() {
    _var="$1"
    _value="$2"

    # Value type: str, bool.
    #   - `bool`: no single quotes around the value.
    # Defaults to `str` if not present.
    _type="$3"

    _conf="/opt/www/roundcubemail/config/config.inc.php"

    if [ X"${_type}" == X'bool' ]; then
        ${CMD_SED} "s#^\(.config..${_var}.. =\).*#\1 ${_value};#g" ${_conf}
    else
        ${CMD_SED} "s#^\(.config..${_var}.. =\).*#\1 '${_value}';#g" ${_conf}
    fi
}

create_rc_custom_conf() {
    # Usage: create_rc_custom_conf <conf-file-name>
    _conf_dir="/opt/iredmail/custom/roundcube"
    _conf="${_conf_dir}/${1}"

    [ -d ${_conf_dir} ] || mkdir -p ${_conf_dir}

    if [ ! -f ${_conf} ]; then
        touch ${_conf}
        echo '<?php' >> ${_conf}
    fi

    chown www-data:www-data ${_conf}
    chmod 0440 ${_conf}
}

create_rc_symlink_subdir() {
    # Link all sub-directories under given directory to another one.
    _src_dir="${1}"
    _dest_dir="${2}"

    cd ${_src_dir}

    _dirs="$(ls -l | grep '^d' | awk '{print $NF}')"
    for dir in ${_dirs}; do
        ln -sf ${_src_dir}/${dir} ${_dest_dir}/${dir}
    done
}

#
# Nginx
#
gen_symlink_of_nginx_tmpl() {
    # Usage: gen_symlink_of_tmpl <site> <src-file-name-without-ext> <dest-file-name-without-ext>
    _site="${1}"
    _conf_dir="${NGINX_CONF_DIR_SITES_CONF_DIR}/${_site}"
    _src="${NGINX_CONF_DIR_TEMPLATES}/${2}.tmpl"
    _dest="${_conf_dir}/${3}.conf"

    if [[ ! -d ${_conf_dir} ]]; then
        mkdir -p ${_conf_dir}
        chown ${SYS_USER_NGINX}:${SYS_GROUP_NGINX} ${_conf_dir}
        chmod 0644 ${_conf_dir}
    fi

    ln -sf ${_src} ${_dest}
}

#
# Fail2ban
#
enable_fail2ban_jail() {
    _conf="${1}"
    _src="/etc/fail2ban/jail-available/${_conf}"
    _dest="/etc/fail2ban/jail.d/${_conf}"

    if [[ -f ${_src} ]]; then
        ln -sf ${_src} ${_dest}
    fi
}

#
# iRedAdmin, iRedAPD, mlmmjadmin
#
update_py_conf() {
    # Usage: <config_file> <param> <value> <value_type>
    _conf="$1"
    _var="$2"
    _value="$3"

    # Value type: str, bool, int, list
    #   - `bool`, `int`: no single quotes around the value.
    # Defaults to `str` if not present.
    _type="$4"

    if [ X"${_type}" == X'bool' -o X"${_type}" == X'int' ]; then
        ${CMD_SED} "s#^\(${_var} =\).*#\1 ${_value}#g" ${_conf}
    elif [ X"${_type}" == X'list' ]; then
        ${CMD_SED} "s#^\(${_var} =\).*#\1 ['${_value}']#g" ${_conf}
    else
        ${CMD_SED} "s#^\(${_var} =\).*#\1 '${_value}'#g" ${_conf}
    fi
}

update_iredadmin_setting() {
    # Usage: <param> <value> <value_type>
    update_py_conf /opt/www/iredadmin/settings.py $1 $2 $3
}

update_iredapd_setting() {
    # Usage: <param> <value> <value_type>
    update_py_conf /opt/iredapd/settings.py $1 $2 $3
}

update_mlmmjadmin_setting() {
    # Usage: <param> <value> <value_type>
    update_py_conf /opt/mlmmjadmin/settings.py $1 $2 $3
}
