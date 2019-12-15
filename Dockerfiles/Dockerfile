# Run all applications in one container.
FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

COPY ./scripts/install_all_pkgs.sh /
RUN /bin/sh /install_all_pkgs.sh && rm -f /install_all_pkgs.sh

COPY ./config/. /

# Main entrypoint script.
COPY ./entrypoints/all_in_one/entrypoint.sh /entrypoint.sh

# Copy entrypoint scripts for all applications.
RUN mkdir /entrypoints
COPY ./entrypoints/functions.sh /entrypoints/functions.sh
COPY ./entrypoints/mariadb.sh /entrypoints/mariadb.sh

CMD ["/bin/sh", "/entrypoint.sh"]
