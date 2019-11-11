# Run all applications in one container.
FROM alpine:3.10.3
MAINTAINER Zhang Huangbin <zhb@iredmail.org>
EXPOSE 80 443 25 465 587 143 993 110 995

# Install required binary packages and python modules.
RUN apk add --no-cache \
        wget postfix postfix-pcre postfix-mysql dovecot dovecot-lmtpd dovecot-pop3d dovecot-pigeonhole-plugin dovecot-mysql clamav py-sqlalchemy py-setuptools py-dnspython py-mysqldb py-psycopg2 py2-pip && \
        pip install web.py==0.40

# iRedAPD
RUN groupadd iredapd && \
        useradd -u 2002 -g iredapd -s /sbin/nologin iredapd && \
        wget -c http://172.16.100.1/~zhb/misc/iRedAPD-3.2.tar.bz2 && \
        tar xjf iRedAPD-3.2.tar.bz2 -C /opt && \
        ln -s /opt/iRedAPD-3.2 /opt/iredapd && \
        chown -R iredapd:iredapd /opt/iRedAPD-3.2 && \
        chmod -R 0500 /opt/iRedAPD-3.2

COPY ./iredapd/settings.py /opt/iRedAPD-3.2/

# Amavisd + SpamAssassin + ClamAV
COPY ./amavisd/conf/amavisd.conf /etc/amavisd.conf
COPY ./clamav/conf/. /etc/clamav

# Postfix
COPY ./postfix/conf/. /etc/postfix/

CMD ["/bin/sh"]
