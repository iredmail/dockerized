#!/bin/sh
# Some useful utility functions used by entrypoint scripts.

LOG_FLAG="[iRedMail]"

LOG() {
    echo "${LOG_FLAG} $@"
}

run_entrypoint() {
    # Usage: run_entrypoint <path-to-entrypoint-script> [arguments]
    _script="$1"
    shift 1
    _opts="$@"

    LOG "Run entrypoint script: ${_script} ${_opts}"
    . ${_script} ${_opts}
}
