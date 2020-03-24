# TODO

- [ ] How to manage/update `default_settings.conf` if we use Docker Hub?
- [ ] Add Fail2ban

- [ ] iRedAdmin
    - [ ] Create system user/group
    - [ ] Install + configure
    - [ ] Create required SQL database, user, tables
    - [ ] Update SQL server address, port, passwords in config files:
    - [ ] Add cron jobs

- [ ] Roundcube
    - [ ] Create symlinks for custom skins/plugins.

- [ ] Move `pre_start/iredapd_db.sh` to `entrypoints/iredapd.sh`.
- [ ] Move `pre_start/amavisd_db.sh` to `entrypoints/antispam.sh`.
- [ ] Move Postfix queue directory (`/var/spool/postfix`) to volume.
- [ ] Backup directory.

- Add `custom.sh` for each component?
- Use random passwords for all SQL users (for all-in-one container)?
- Generate `README` file under `/opt/iredmail/custom/<component>/`
