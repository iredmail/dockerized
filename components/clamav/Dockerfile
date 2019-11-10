FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 3310

RUN apk add --no-cache clamav

COPY ./clamd.conf /etc/clamav/clamd.conf
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
