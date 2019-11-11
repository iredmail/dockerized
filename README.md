All files under `config/` are populated from ansible code of iRedMail Easy.

## TODO

- Create required SQL database, users, tables
    - amavisd
    - iredapd
    - roundcubemail
    - sogo
    - iredadmin

- [x] Reflect the directory tree of config files, then just run `COPY ./. /` in Dockerfile to copy all files.
- [x] Install required python modules with pip: web.py
