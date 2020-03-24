# TODO

- [ ] How to manage/update `default_settings.conf` if we use Docker Hub?

- [ ] Move Postfix queue directory (`/var/spool/postfix`) to volume.
- [ ] Roundcube
    - [ ] Create symlinks for custom skins/plugins.

- [ ] iRedAdmin
    - [ ] Create system user/group
    - [ ] Install + configure
    - [ ] Create required SQL database, user, tables
    - [ ] Update SQL server address, port, passwords in config files:
    - [ ] Add cron jobs

- [ ] Add switch to use random passwords for all SQL users (for all-in-one container)?
- [ ] Custom settings:
    - [ ] Generate `README` file under `/opt/iredmail/custom/<component>/`
    - [ ] Add `custom.sh` for each component?
