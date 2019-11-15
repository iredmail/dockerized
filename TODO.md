# TODO

- Postfix:
    - How to get Postfix log
- MariaDB:
    - How to backup SQL databases everyday
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

- [x] Get mariadb container running first.
- [x] Reflect the directory tree of config files, then just run `COPY ./. /` in Dockerfile to copy all files.
- [x] Install required python modules with pip: web.py
