# TODO
# - connect to Dovecot SASL auth server
# - connect to Amavisd-new
# - connect to iRedAPD

FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 25 465 587

RUN apk add --no-cache postfix postfix-pcre postfix-mysql

COPY ./conf/* /etc/postfix/

CMD ["postfix", "start"]
