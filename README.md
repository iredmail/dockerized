__WARNING__: THIS IS A BETA EDITION, DO NOT TRY IT IN PRODUCTION.

Report issues to [iRedMail GitHub repo](https://github.com/iredmail/iRedMail/issues).

A quick taste with Docker Hub image:

```
docker pull iredmail/mariadb:beta
touch /etc/iredmail-docker.conf
echo HOSTNAME=mail.mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> /etc/iredmail-docker.conf
echo ROUNDCUBE_DES_KEY=$(openssl rand -base64 24) >> /etc/iredmail-docker.conf

mkdir /opt/iredmail
docker run \
    --rm \
    --env-file /etc/iredmail-docker.conf \
    --hostname mail.example.com \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 587:587 \
    -v /opt/iredmail/custom:/opt/iredmail/custom \
    -v /opt/iredmail/ssl:/opt/iredmail/ssl \
    -v /opt/iredmail/backup:/var/vmail/backup \
    -v /opt/iredmail/mailboxes:/var/vmail/vmail1 \
    -v /opt/iredmail/mysql:/var/lib/mysql \
    -v /opt/iredmail/clamav:/var/lib/clamav \
    -v /opt/iredmail/mlmmj:/var/vmail/mlmmj \
    -v /opt/iredmail/mlmmj-archive:/var/vmail/mlmmj-archive \
    -v /opt/iredmail/imapsieve_copy:/var/vmail/imapsieve_copy \
    -v /opt/iredmail/sa_rules:/var/lib/spamassassin \
    iredmail/mariadb:beta
```

## Overview

- Only one config file `/etc/iredmail-docker.conf` on Docker host.
- All data is stored under `/opt/iredmail` on Docker host.

Directory structure:

```
/opt/iredmail/
        |- backup/          # Backup copies.
        |- custom/          # Store custom configurations.
            |- amavisd/
            |- dovecot/
            |- iredapd/
            |- mlmmjadmin/
            |- mysql/
            |- nginx/
                |- conf-enabled/
                |- sites-enabled/
            |- postfix/
            |- roundcube/
        |- imapsieve_copy/  # Used by Dovecot plugin `imapsieve`.
        |- mailboxes/       # All users' mailboxes.
        |- mlmmj/           # mlmmj mailing lists.
        |- mlmmj-archive/   # Archive of mlmmj mailing lists.
        |- mysql/           # MySQL databases.
        |- sa_rules/        # SpamAssassin rules.
        |- clamav/          # ClamAV signature database.
        |- ssl/             # SSL cert file and private key.
```

## Requirements

Docker has some issue on Windows/macOS platform, please run Linux system as
Docker host.

## Preparations

### Create required directory and config file `/etc/iredmail-docker.conf` on Docker host

```
mkdir -p /opt/iredmail
touch /etc/iredmail-docker.conf
```

There're few __REQUIRED__ parameters you __MUST__ set in `/etc/iredmail-docker.conf`:

```
# Server hostname. Must be a FQDN. For example, mail.mydomain.com
HOSTNAME=

# First mail domain name. For example, mydomain.com.
FIRST_MAIL_DOMAIN=

# (Plain) password of mail user `postmaster@<FIRST_MAIL_DOMAIN>`.
FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=

# The secret string used to encrypt/decrypt Roundcube session data.
# Required if you need to run Roundcube webmail.
# You can generate random string with command `openssl rand -base64 24` as the
# des key.
# Every time this key changed, all Roundcube session data becomes invalid and
# users will be forced to re-login.
ROUNDCUBE_DES_KEY=
```

Notes:

- `/etc/iredmail-docker.conf` will be read by Docker as an environment file,
  any single quote or double quote will be treated as part of the value.
- It will be imported as bash shell script too.

There're many OPTIONAL settings defined in file
`/docker/entrypoints/default_settings.conf` inside docker container,
you'd like to change any of them, please write the same parameter name with
your custom value in `/etc/iredmail-docker.conf` to override it.

## Run the all-in-one container if you have GitHub repo access

To build and run iRedMail with an all-in-one container:

```shell
bash build_all_in_all.sh
touch /etc/iredmail-docker.conf
echo HOSTNAME=mail.mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> /etc/iredmail-docker.conf
mkdir /opt/iredmail
./run_all_in_one.sh
```

On first run, it will generate a self-signed ssl cert (if no cert exists under
`/opt/iredmail/ssl/`). This may take a long time, please be patient.

Each time you run the container, few tasks will be ran:

- Update SpamAssassin rules.
- Update ClamAV virus signature database.

# Installed softwares

- Postfix: SMTP server.
- Dovecot: POP3/IMAP/LMTP/Sieve server, also offers SASL AUTH service for Postfix.
- mlmmj: mailing list manager.
- mlmmjadmin: RESTful API server used to manage (mlmmj) mailing lists.
- Amavisd-new + ClamAV + SpamAssassin: anti-spam and anti-virus, DKIM signing and verification, etc.
- iRedAPD: Postfix policy server. Developed by iRedMail team.
- Fail2ban: scans log files and bans bad clients.
- Roundcube: webmail.

# Exposed network ports

- 80: HTTP
- 443: HTTPS
- 25: SMTP
- 465: SMTPS (SMTP over SSL)
- 587: SUBMISSION (SMTP over TLS)
- 143: IMAP over TLS
- 993: IMAP over SSL
- 110: POP3 over TLS
- 995: POP3 over SSL
- 4190: Managesieve service
