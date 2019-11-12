All files under `config/` are populated from ansible code of iRedMail Easy.

## TODO

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
