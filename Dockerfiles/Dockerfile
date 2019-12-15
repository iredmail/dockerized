# Run all applications in one container.
FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

ARG ENTRYPOINTS_DIR=/entrypoints
ARG SCRIPTS_DIR=/docker/scripts

RUN mkdir -p ${ENTRYPOINTS_DIR} ${SCRIPTS_DIR}

COPY ./scripts/add_user_vmail.sh \
    ./scripts/add_user_iredapd.sh \
    ./scripts/install_all_pkgs.sh \
    ${SCRIPTS_DIR}/

RUN /bin/sh ${SCRIPTS_DIR}/add_user_vmail.sh && \
    /bin/sh ${SCRIPTS_DIR}/add_user_iredapd.sh && \
    /bin/sh ${SCRIPTS_DIR}/install_all_pkgs.sh && \
    rm -rf ${SCRIPTS_DIR}

#
# Copy config files
#
COPY ./config/. /

COPY --chown=vmail:vmail ./config/usr/local/bin/scan_reported_mails /usr/local/bin/scan_reported_mails

RUN mkdir -p /usr/local/bin/imapsieve
COPY --chown=vmail:vmail ./config/usr/local/bin/imapsieve/. /usr/local/bin/imapsieve/
RUN chown vmail:vmail /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve/* && \
    chmod 0550 /usr/local/bin/scan_reported_mails /usr/local/bin/imapsieve/*

#
# entrypoint scripts
#
# Main entrypoint script.
COPY ./entrypoints/all_in_one/entrypoint.sh /entrypoint.sh

# Copy entrypoint scripts for all applications.
COPY ./entrypoints/functions.sh /entrypoints/functions.sh
COPY ./entrypoints/mariadb.sh /entrypoints/mariadb.sh
COPY ./entrypoints/dovecot.sh /entrypoints/dovecot.sh

CMD ["/bin/sh", "/entrypoint.sh"]
