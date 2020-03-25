__WARNING__: THIS IS A ALPHA EDITION, DO NOT TRY IT IN PRODUCTION.

All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of [iRedMail Easy platform](https://www.iredmail.org/easy.html).

A quick taste:

> WARNING: STILL WORK IN PROGRESS.

```
bash build_all_in_all.sh
touch /etc/iredmail-docker.conf
echo HOSTNAME=mail.mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> /etc/iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> /etc/iredmail-docker.conf
echo ROUNDCUBE_DES_KEY=$(openssl rand -base64 24) >> /etc/iredmail-docker.conf
mkdir /opt/iredmail
./run_all_in_one.sh
```

## Overview

- Only one config file on Docker host: `/etc/iredmail-docker.conf`.
- All data is stored under `/opt/iredmail`.

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

Docker has some issue on Windows/macOS platform, please use Linux system as
Docker host.

## Preparations

### Create required directory and config file `/etc/iredmail-docker.conf` on Docker host

- Data is stored under `/opt/iredmail` On Docker host.
- All settings are stored in config file `/etc/iredmail-docker.conf`.

```
mkdir -p /opt/iredmail
touch /etc/iredmail-docker.conf
```

There're few REQUIRED parameters you should set in `/etc/iredmail-docker.conf`:

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

- This file will be read by Docker as an environment file, any single quote
  or double quote will be treated as part of the value.
- It will be imported as bash shell script too.

There're many OPTIONAL settings defined in file `/docker/entrypoints/default_settings.conf`,
you'd like to change any of them, please write the same parameter name with
proper value in `/etc/iredmail-docker.conf` to override it.

## Run the all-in-one container

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

Notes:

- On first run, it needs to update SpamAssassin rules and ClamAV virus
  signature database, so it may take some time to finish, please be patient.

# Exposed network ports

80 443 25 465 587 143 993 110 995 4190
