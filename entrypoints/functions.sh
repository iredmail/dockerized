#!/bin/sh
# Some useful utility functions used by entrypoint scripts.

LOG_FLAG="[iRedMail]"

LOG() {
    echo -e "\e[32m${LOG_FLAG}\e[0m $@"
}

LOG_ERROR() {
    echo -e "\e[31m${LOG_FLAG} ERROR:\e[0m $@" >&2
}

LOG_WARNING() {
    echo -e "\e[33m${LOG_FLAG} WARNING:\e[0m $@"
}

# Commands.
CMD_SED="sed -i'.bak' -e"

run_entrypoint() {
    # Usage: run_entrypoint <path-to-entrypoint-script> [arguments]
    _script="$1"
    shift 1
    _opts="$@"

    LOG "[Entrypoint] Run: ${_script} ${_opts}"
    . ${_script} ${_opts}
}
