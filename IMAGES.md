# Docker images and volumes

Draft design:

- MariaDB (official mariadb image)
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

