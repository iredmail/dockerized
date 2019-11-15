All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of iRedMail Easy.

## Single image

## Volumes

Main data volumes:

- `/opt/iredmail/`
- `/var/vmail/`

```
/opt/iredmail/
        |- ssl/             # SSL cert
            |- cert.pem
            |- combined.pem
            |- key.pem
        |- custom/          # Store all custom application settings
            |- postfix/     # custom Postfix settings
            |- dovecot/     # custom Dovecot settings
            |- ...

/var/vmail/
        |- backup/
            |- mysql/
            |- sogo/
        |- sieve/
            |- dovecot.sieve
        |- imapsieve_copy/
            |- spam/
            |- ham/
            |- processing/
        |- mlmmj/
        |- mlmmj-archive/
```

## docker-compose

Draft design:

- MariaDB
    - Volume: database `/var/lib/mysql`
    - Volume: database backup `/var/vmail/backup/mysql/`

- Postfix + mlmmj + mlmmjadmin
    - Volume: mailing lists data `/var/vmail/{mlmmj,mlmmj-archive}`
    - Volume: Postfix queue `/var/spool/postfix/`
    - Volume: mailboxes `/var/vmail/vmail1`

    Postfix + mlmmj + mlmmjadmin better in same container.

    - mlmmj doesn't offer LMTP service, Postfix has to pipe message to
      local mlmmj commands.

    - mlmmjadmin read/writes config files under `/var/vmail/mlmmj/` to
      manage mailing list settings.

- Dovecot
    - Volume: `/var/vmail/vmail1`

- Amavisd + SpamAssassin + ClamAV
    - Volume: ClamAV database `/var/lib/clamav`
    - Volume: SpamAssassin db
- iRedAPD
- Roundcube + Nginx + php-fpm
- iRedAdmin(-Pro) + Nginx
- SOGo Groupware + Nginx (use debian/ubuntu instead of alpine as base image)

## TODO

- Get mariadb container running first.
- Generate self-signed ssl cert while launching container which needs a cert
  and the cert files don't exist yet.
- Replace FQDN in files while launching container:
    - command used to generate SSL cert (nginx, dovecot, postfix)
- Reset correct uid/gid for `mlmmj` user and group.
- Add a global variable to set admin's email address
    - `/etc/postfix/aliases`
    - ssl cert
- Read custom SQL passwords from somewhere while running Docker container, and
  update passwords in all related config files.
- Add `entrypoint.sh` to start required services/daemons.

- Create required SQL database, users, tables
    - `vmail`
    - amavisd
    - iredapd
    - roundcubemail
    - sogo
    - iredadmin

- Update SQL database automatically while running new version of container:
    - Roundcube: run `bin/updatedb.sh`

- [x] Reflect the directory tree of config files, then just run `COPY ./. /` in Dockerfile to copy all files.
- [x] Install required python modules with pip: web.py
