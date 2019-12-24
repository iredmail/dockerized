# TODO

## Phase 1

- [x] FQDN hostname
    - [x] Update Postfix parameter `myhostname`, `mydomain`, `myorigin`.
    - [x] Update Amavisd config file
    - [x] Update iRedAPD config file
    - [x] Update Dovecot config file
- [ ] Specify first mail domain name.
    - [ ] Add mail domain name in SQL db.
    - [ ] Add first domain admin `postmaster@` in SQL db.
    - [ ] Add alias for all required system accounts in `/etc/postfix/aliases`.
- [ ] Amavisd:
    - [ ] Create SQL database and tables
    - [ ] Generate DKIM key for first mail domain.
- [ ] Setup mlmmjadmin
- [ ] Setup clamav
    - [ ] Add cron job to run `freshclam`

- Add volumes:
    - `/opt/iredmail/custom`
        - Create or mount `/opt/iredmail/custom/<component>/` in entrypoint.
    - mysql bin log
    - Postfix queue directory (`/var/spool/postfix`)
- Connect to clamav via inet port, not local socket.
- Postfix:
    - Copy/Link `/etc/{localtime,hosts,resolv.conf}` to `/var/spool/postfix/etc`.
    - How to get Postfix log
- Generate self-signed ssl cert while launching container which needs a cert
  and the cert files don't exist yet.
- Reset correct uid/gid for `mlmmj` user and group.
- Add a global variable to set admin's email address
    - `/etc/postfix/aliases`
    - ssl cert
- Read custom SQL passwords from somewhere while running Docker container, and
  update passwords in all related config files.
- Add `entrypoint.sh` to start required services/daemons.

- Create required SQL database, users, tables
    - [x] `vmail`
    - amavisd
    - iredapd
    - roundcubemail
    - sogo
    - iredadmin

- Update SQL database automatically while running new version of container:
    - Roundcube: run `bin/updatedb.sh`

- MariaDB:
    - [x] Get mariadb container running first.
    - [x] Create SQL database `vmail` and tables.
- [x] Add env settings like `USE_ANTISPAM=[YES|NO]` to enable/disable optional components.
- [x] Reflect the directory tree of config files, then just run `COPY ./. /` in Dockerfile to copy all files.
- [x] Install required python modules with pip: web.py
- supervisor:
    - [x] Create symbol link for modular config files based on the `USE_<PROGRAM>=YES` setting.

## Phase 2

- How to run corn jobs
- MariaDB:
    - How to backup SQL databases everyday
