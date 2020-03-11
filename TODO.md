# TODO

- [ ] iRedAdmin
    - [ ] Install + configure
    - [ ] Update SQL server address, port, passwords in config files:
    - [ ] Add cron jobs

- [ ] Generate modular logrotate config files.
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

- [ ] SOGo is missing due to upstream doesn't offer binary packages for Alpine.
