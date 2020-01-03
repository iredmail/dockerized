# TODO

- Roundcube:
    - [ ] Create custom config files:
        - `config_password.inc.php`
        - `config_managesieve.inc.php`

- Create required SQL database, users, tables
    - [x] roundcubemail
    - [ ] iredapd
    - [ ] iredadmin
    - [ ] sogo
    - [x] amavisd
    - [x] `vmail`
- Update SQL server address, port, passwords in config files:
    - [x] Dovecot
    - [x] Postfix
    - [ ] iRedAPD
    - [ ] Roundcube
    - [ ] iRedAdmin
    - [ ] Amavisd

- mlmmj:
    - [ ] Reset correct uid/gid for `mlmmj` user and group.
    - [ ] Setup mlmmjadmin
- [ ] Run logrotate and generate modular config files.
- [ ] Add cron jobs for applications.
- [ ] ClamAV:
    - [ ] Run `freshclam` via cron job or supervisor?
    - [x] Run `freshclam` immediately if no db exists. This will speed up container launch.
    - [ ] Connect to clamav via inet port, not local socket.
- Volumes:
    - [ ] Postfix queue directory (`/var/spool/postfix`)
    - [ ] Backup directory.
    - [x] Mailboxes directory.
    - [x] `/opt/iredmail/custom`
    - [x] SpamAssassin rules directory

- Add `custom.sh` for each component?
- Use random passwords for all SQL users (for all-in-one container)?
- Move to Alpine-3.11 and use Python-3.
