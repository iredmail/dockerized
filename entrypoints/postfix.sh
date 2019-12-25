#!/bin/sh

. /docker/entrypoints/functions.sh

USERDB_CONF_DIR="/etc/postfix/mysql"
MAIN_CF="/etc/postfix/main.cf"
MASTER_CF="/etc/postfix/master.cf"

if [[ X"${USE_IREDAPD}" == X'NO' ]]; then
    LOG "Disable iRedAPD."
    ${CMD_SED} 's#check_policy_service inet:127.0.0.1:7777##' ${MAIN_CF}
fi

if [[ X"${USE_IREDAPD}" == X'NO' ]] || [[ X"${POSTFIX_ENABLE_SRS}" == X'NO' ]]; then
    LOG "Disable SRS."
    ${CMD_SED} 's#tcp:127.0.0.1:7778##g' ${MAIN_CF}
    ${CMD_SED} 's#tcp:127.0.0.1:7779##g' ${MAIN_CF}
fi

if [[ X"${USE_ANTISPAM}" == X'NO' ]]; then
    LOG "Disable antispam."
    ${CMD_SED} 's#smtp-amavis:[127.0.0.1]:10024##g' ${MAIN_CF}
    ${CMD_SED} 's#    -o content_filter=smtp-amavis:[127.0.0.1]:10026##g' ${MASTER_CF}
fi

# Update parameters.
${CMD_SED} "s#PH_HOSTNAME#${HOSTNAME}#g" ${MAIN_CF}

${CMD_SED} "s#PH_SQL_SERVER_ADDRESS#${SQL_SERVER_ADDRESS}#g" ${USERDB_CONF_DIR}/*.cf
${CMD_SED} "s#PH_SQL_SERVER_PORT#${SQL_SERVER_PORT}#g" ${USERDB_CONF_DIR}/*.cf
${CMD_SED} "s#PH_VMAIL_DB_PASSWORD#${VMAIL_DB_PASSWORD}#g" ${USERDB_CONF_DIR}/*.cf
