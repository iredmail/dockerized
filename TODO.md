# TODO

- Update SQL server address, port, passwords in config files:
    - [ ] iRedAdmin

- [ ] Setup mlmmjadmin
- [ ] Add cron jobs for applications.
    - [x] dovecot
    - [x] roundcube
    - [x] iredapd
    - [ ] iredadmin
    - [ ] mlmmj
    - [ ] sogo
    - [ ] backup scripts
- [ ] Run logrotate and generate modular config files.
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
- Generate `README` file under `/opt/iredmail/custom/<component>/`
- Create required SQL database, users, tables
    - [ ] iredadmin
    - [ ] sogo
