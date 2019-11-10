# Run all applications in one container.
FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

RUN apk add --no-cache postfix postfix-pcre postfix-mysql dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql clamav

# ClamAV
COPY ./clamav/conf/. /etc/clamav

# Postfix
COPY ./postfix/conf/. /etc/postfix/

CMD ["/bin/sh"]
