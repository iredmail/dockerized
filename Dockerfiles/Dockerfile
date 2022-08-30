#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

# Run all applications in one container.
FROM ubuntu:jammy
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995 4190

ARG ENTRYPOINTS_DIR=/docker/entrypoints
ARG SCRIPTS_DIR=/docker/scripts
ARG MARIADB_PRE_START_SCRIPTS_DIR=/docker/mariadb/pre_start

RUN mkdir -p \
        ${ENTRYPOINTS_DIR} \
        ${SCRIPTS_DIR} \
        ${MARIADB_PRE_START_SCRIPTS_DIR}

#
# Add system accounts and install packages.
#
COPY ./scripts/*.sh ${SCRIPTS_DIR}/

RUN /bin/sh ${SCRIPTS_DIR}/add_user_vmail.sh && \
    /bin/sh ${SCRIPTS_DIR}/add_user_mlmmj.sh && \
    /bin/sh ${SCRIPTS_DIR}/add_user_iredapd.sh && \
    /bin/sh ${SCRIPTS_DIR}/add_user_iredadmin.sh && \
    /bin/sh ${SCRIPTS_DIR}/install_all_pkgs.sh && \
    rm -rf ${SCRIPTS_DIR}

# MariaDB pre-start scripts.
COPY ./scripts/mariadb/pre_start/. ${MARIADB_PRE_START_SCRIPTS_DIR}/

#
# Copy config files
#
COPY ./config/. /

#
# entrypoint scripts
#
COPY ./entrypoints/. ${ENTRYPOINTS_DIR}/
COPY ./settings.conf ${ENTRYPOINTS_DIR}/

# Main entrypoint script.
COPY ./entrypoints/all_in_one.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
