__WARNING__
__WARNING__: THIS IS A ALPHA EDITION, DO NOT TRY IT IN PRODUCTION.__
__WARNING__

All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of [iRedMail Easy platform](https://www.iredmail.org/easy.html).

## Requirements

Docker has some issue on Windows/macOS platform, please use Linux system as
Docker host.

## Preparations

### Create config file `iredmail.conf`

Create config file `iredmail.conf` used to store your custom settings:

```
touch iredmail.conf
```

There're few REQUIRED parameters you should set in `iredmail.conf`:

```
# [REQUIRED] Server hostname and first mail domain
HOSTNAME=
FIRST_MAIL_DOMAIN=
FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=

# SQL user passwords.
VMAIL_DB_PASSWORD=
VMAIL_DB_ADMIN_PASSWORD=
AMAVISD_DB_PASSWORD=
ROUNDCUBE_DB_PASSWORD=
IREDAPD_DB_PASSWORD=

# Roundcube DES key, used to encrypt session data.
ROUNDCUBE_DES_KEY=
```

There're many OPTIONAL settings defined in file `default_settings.conf`, if
you'd like to change any of them, please write the same parameter name with
proper value in `iredmail.conf` to override it.

### Create required directories

iRedMail (Docker Edition) stores all data under `/opt/iredmail`, applications
use its own sub-directory under `/opt/iredmail`. For example:

```
/opt/iredmail/
        |- backup/          # Store daily backup copies. e.g. SQL databases.
        |- custom/          # Store custom configurations.
            |- amavisd/
            |- dovecot/
            |- iredapd/
            |- mlmmjadmin/
            |- mysql/
            |- postfix/
            |- roundcube/
        |- imapsieve_copy/  # temporary directory used by Dovecot plugin `imapsieve`.
        |- mailboxes/       # All users' mailboxes.
        |- mlmmj/           # mlmmj mailing lists.
        |- mlmmj-archive/   # Archive of mlmmj mailing lists.
        |- mysql/           # MySQL databases.
        |- sa_rules/        # SpamAssassin rules.
        |- clamav/          # ClamAV signature database.
        |- ssl/             # SSL cert file and private key.
```

## Run the all-in-one container if you have access to GitHub repo

To build and run iRedMail with an all-in-one container:

```
./build_all_in_one.sh
./run_all_in_one.sh
```

Notes:

- On first run, it needs to update SpamAssassin rules and ClamAV virus
  signature database, so it may take some time to finish, please be patient.

## Run the all-in-one container if you use Docker Hub

__WARNING__: This is not fully working right now due to missing
`default_settings.conf` and a shell script to help run container easily.

```
docker pull iredmail/mariadb:beta
touch iredmail.conf     # Add content in this file by following the above `Preparations` section.
```
