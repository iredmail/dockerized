# Run all applications in one container.
FROM alpine:3.11.0
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

ARG ENTRYPOINTS_DIR=/docker/entrypoints
ARG SCRIPTS_DIR=/docker/scripts
ARG MARIADB_SCRIPTS_DIR=/docker/mariadb

RUN mkdir -p \
        ${ENTRYPOINTS_DIR} \
        ${SCRIPTS_DIR} \
        ${MARIADB_SCRIPTS_DIR}

#
# Add system accounts and install packages.
#
COPY ./scripts/add_user_vmail.sh \
    ./scripts/add_user_iredapd.sh \
    ./scripts/install_all_pkgs.sh \
    ${SCRIPTS_DIR}/

RUN /bin/sh ${SCRIPTS_DIR}/add_user_vmail.sh && \
    /bin/sh ${SCRIPTS_DIR}/add_user_iredapd.sh && \
    /bin/sh ${SCRIPTS_DIR}/install_all_pkgs.sh && \
    rm -rf ${SCRIPTS_DIR}

# MariaDB first-run and pre-start scripts.
COPY ./scripts/mariadb/. ${MARIADB_SCRIPTS_DIR}/

#
# Copy config files
#
COPY ./config/. /

# Set proper owner/group and permissions.
RUN chown -R vmail:vmail /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve && \
    chmod 0550 /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve/*

#
# entrypoint scripts
#
# Main entrypoint script.
COPY ./entrypoints/all_in_one/entrypoint.sh /entrypoint.sh

# Copy entrypoint scripts for all applications.
COPY ./entrypoints/. ${ENTRYPOINTS_DIR}/

CMD ["/bin/sh", "/entrypoint.sh"]
