All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of iRedMail Easy.

## Single image

## docker-compose

Draft design:

- MariaDB
    - Database `/var/lib/mysql` must be on volume
- Postfix + Dovecot + mlmmj + mlmmjadmin
    - Postfix queue `/var/spool/postfix/` should be on volume
    - mailboxes `/var/vmail/vmail1` must be on volume
    - mailing lists data `/var/vmail/{mlmmj,mlmmj-archive}` must be on volume
- Amavisd + SpamAssassin + ClamAV
    - ClamAV database `/var/lib/clamav` must be on volume.
- iRedAPD
- Roundcube + Nginx + php-fpm
- iRedAdmin(-Pro) + Nginx
- SOGo Groupware + Nginx (use debian/ubuntu instead of alpine as base image)

## TODO

- Get mariadb container running first.
- Read custom SQL passwords from somewhere while running Docker container, and
  update passwords in all related config files.
- Add `entrypoint.sh` to start required services/daemons.

- Create required SQL database, users, tables
    - amavisd
    - iredapd
    - roundcubemail
    - sogo
    - iredadmin

- Update SQL database automatically while running new version of container:
    - Roundcube: run `bin/updatedb.sh`

- [x] Reflect the directory tree of config files, then just run `COPY ./. /` in Dockerfile to copy all files.
- [x] Install required python modules with pip: web.py
