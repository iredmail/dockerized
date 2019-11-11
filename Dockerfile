# Run all applications in one container.
FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

# Install required binary packages and python modules.
RUN apk add --no-cache --progress \
        wget postfix postfix-pcre postfix-mysql dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql clamav py-sqlalchemy py-setuptools py-dnspython py-mysqldb py-psycopg2 py2-pip mlmmj altermime py-requests uwsgi uwsgi-python uwsgi-syslog && \
    pip install web.py==0.40 && \
    addgroup iredapd && \
        adduser -D -H -u 2002 -G iredapd -s /sbin/nologin iredapd && \
        wget -c https://dl.iredmail.org/yum/misc/iRedAPD-3.2.tar.bz2 && \
        tar xjf iRedAPD-3.2.tar.bz2 -C /opt && \
        rm -f iRedAPD-3.2.tar.bz2 && \
        ln -s /opt/iRedAPD-3.2 /opt/iredapd && \
        chown -R iredapd:iredapd /opt/iRedAPD-3.2 && \
        chmod -R 0500 /opt/iRedAPD-3.2 && \
    wget -c https://github.com/iredmail/mlmmjadmin/archive/2.1.tar.gz && \
        tar zxf 2.1.tar.gz -C /opt && \
        rm -f 2.1.tar.gz && \
        ln -s /opt/mlmmjadmin-2.1 /opt/mlmmjadmin && \
        chown -R mlmmj:mlmmj /opt/mlmmjadmin-2.1 && \
        chmod -R 0500 /opt/mlmmjadmin-2.1

COPY ./config/. /

CMD ["/bin/sh"]
