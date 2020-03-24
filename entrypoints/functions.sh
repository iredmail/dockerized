#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>
# Purpose: Some utility functions used by entrypoint scripts.

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

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

# Commands.
CMD_SED="sed -i -e"

require_non_empty_var() {
    # Usage: require_non_empty_var <VAR_NAME> <VAR_VALUE>
    _var="$1"
    _value="$2"

    if [[ X"${_value}" == X'' ]]; then
        LOG_ERROR "Variable ${_var} can not be empty, please set it in file 'iredmail.conf'."
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

create_sql_user() {
    # Usage: create_user <user> <password>
    _user="$1"
    _pw="$2"

    cmd_mysql="mysql -u root"

    ${cmd_mysql} mysql -e "SELECT User FROM user WHERE User='${_user}' LIMIT 1" | grep 'User' &>/dev/null
    if [[ X"$?" != X'0' ]]; then
        ${cmd_mysql} -e "CREATE USER '${_user}'@'%';"
    fi

    # Reset password.
    #${cmd_mysql} mysql -e "UPDATE user SET Password=password('${_pw}'),authentication_string=password('${_pw}') WHERE User='${_user}';"
    ${cmd_mysql} mysql -e "ALTER USER '${_user}'@'%' IDENTIFIED BY '${_pw}';"

}

#
# Roundcube
#
create_rc_custom_conf() {
    # Usage: create_rc_custom_conf <conf-file-name>
    _conf_dir="/opt/iredmail/custom/roundcube"
    _conf="${_conf_dir}/${1}"

    [ -d ${_conf_dir} ] || mkdir -p ${_conf_dir}

    if [ ! -f ${_conf} ]; then
        touch ${_conf}
        echo '<?php' >> ${_conf}
    fi

    chown nginx:nginx ${_conf}
    chmod 0400 ${_conf}
}
