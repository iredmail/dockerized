__WARNING__: THIS IS A BETA EDITION, DO NOT TRY IT IN PRODUCTION.

Report issues to [iRedMail GitHub repo](https://github.com/iredmail/iRedMail/issues).

A quick taste with Docker Hub image:

```
docker pull iredmail/mariadb:beta

mkdir /opt/iredmail         # Create a directory under any directory you prefer.
                            # `/opt/iredmail/` is just an example, not forced.
cd /opt/iredmail
touch iredmail-docker.conf
echo HOSTNAME=mail.mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> iredmail-docker.conf
echo ROUNDCUBE_DES_KEY=$(openssl rand -base64 24) >> iredmail-docker.conf

mkdir -p data/{backup,clamav,custom,imapsieve_copy,mailboxes,mlmmj,mlmmj-archive,mysql,sa_rules,ssl}
docker run \
    --rm \
    --env-file iredmail-docker.conf \
    --hostname mail.example.com \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 587:587 \
    -v data/backup:/var/vmail/backup \
    -v data/mailboxes:/var/vmail/vmail1 \
    -v data/mlmmj:/var/vmail/mlmmj \
    -v data/mlmmj-archive:/var/vmail/mlmmj-archive \
    -v data/imapsieve_copy:/var/vmail/imapsieve_copy \
    -v data/custom:/opt/iredmail/custom \
    -v data/ssl:/opt/iredmail/ssl \
    -v data/mysql:/var/lib/mysql \
    -v data/clamav:/var/lib/clamav \
    -v data/sa_rules:/var/lib/spamassassin \
    iredmail/mariadb:beta
```

On first run, it will generate a self-signed ssl cert (if no cert exists under
`data/ssl/`). This may take a long time, please be patient.

Each time you run the container, few tasks will be ran:

- Update SpamAssassin rules.
- Update ClamAV virus signature database.

## Overview

- Only one config file `iredmail-docker.conf` on Docker host.
- All data is stored under `data/` on Docker host (in our example, it's
  `/opt/iredmail/data/`). Directory structure:

```
iredmail-docker.conf    # The (only one) config file.
data/
    |- backup/          # Backup copies.
    |- clamav/          # ClamAV signature database.
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
    |- ssl/             # SSL cert file and private key.
    |- ...
```

## Requirements

Docker has some issue on Windows/macOS platform, please run Linux system as
Docker host.

## Preparations

### Create required directory and config file `/etc/iredmail-docker.conf` on Docker host

```
mkdir -p /opt/iredmail      # Create it or use any existing directory you prefer
touch iredmail-docker.conf
```

There're few __REQUIRED__ parameters you __MUST__ set in `iredmail-docker.conf`:

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

- `iredmail-docker.conf` will be read by Docker as an environment file,
  any single quote or double quote will be treated as part of the value.
- It will be imported as bash shell script too.

There're many OPTIONAL settings defined in file
`/docker/entrypoints/default_settings.conf` inside docker container,
you'd like to change any of them, please write the same parameter name with
your custom value in `iredmail-docker.conf` to override it.

## Run the all-in-one container if you have GitHub repo access

To build and run iRedMail with an all-in-one container:

```shell
cd /path/to/a/directory/you/prefer
docker build -t iredmail:latest -f Dockerfiles/Dockerfile .
touch iredmail-docker.conf
echo HOSTNAME=mail.mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> iredmail-docker.conf

mkdir -p data/{backup,clamav,custom,imapsieve_copy,mailboxes,mlmmj,mlmmj-archive,mysql,sa_rules,ssl}
docker run \
    --rm \
    --env-file iredmail-docker.conf \
    --hostname mail.example.com \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 587:587 \
    -v data/backup:/var/vmail/backup \
    -v data/mailboxes:/var/vmail/vmail1 \
    -v data/mlmmj:/var/vmail/mlmmj \
    -v data/mlmmj-archive:/var/vmail/mlmmj-archive \
    -v data/imapsieve_copy:/var/vmail/imapsieve_copy \
    -v data/custom:/opt/iredmail/custom \
    -v data/ssl:/opt/iredmail/ssl \
    -v data/mysql:/var/lib/mysql \
    -v data/clamav:/var/lib/clamav \
    -v data/sa_rules:/var/lib/spamassassin \
    iredmail:latest
```

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
