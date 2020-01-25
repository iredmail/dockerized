# TODO

- rsyslog:
    - [ ] Add config file for builtin daemons (cron, etc)

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
- Move to Alpine-3.11 and use Python-3.

# TODO - Modularize Branch
In addition to the above. The aim of this branch is;
1. Separate out reusable components with docker official images
2. Reduce build times by starting from base containers
3. Have one process running per container PID=1
4. Try as much as possible to scripts already available in IredMail Core so we can have parity between the two
5. Allow users to select components to start
6. Use external services where applicable, e.g. Database, Storage
7. `docker-compose up` should always start the project successfully once env variables have been set
8. Allow customization of components e.g. plugins for Roundcube
9. Test that Migration works by having the ability to switch between versions using environment variables
10. Include loadbalancer container with automatic ssl to proxy web services