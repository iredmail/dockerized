__WARNING__: THIS IS A BETA EDITION, DO NOT TRY IT IN PRODUCTION.

Report issues to [iRedMail GitHub repo](https://github.com/iredmail/iRedMail/issues).

# Quick start

Create a docker environment file `iredmail-docker.conf` used to store custom
settings:

```
touch iredmail-docker.conf
```

Few parameters are required in `iredmail-docker.conf`:

```
# SQL server and password used to store SOGo data.
# SQL server should point to the iRedMail container:
# https://hub.docker.com/r/iredmail/mariadb
SOGO_DB_SERVER=
SOGO_DB_PASSWORD=my-password

# Dovecot master user. Used to update sieve rules.
DOVECOT_MASTER_USER=master@not-exist.com
DOVECOT_MASTER_PASSWORD=my-secret-password
```

Optional parameters:

```
# SQL server port, database name, user name. Defaults to `3306`, `sogo`, `sogo`.
SOGO_DB_PORT=3306
SOGO_DB_NAME=sogo
SOGO_DB_USER=sogo

# Prefork SOGo child processes. Defaults to 10.
SOGO_PREFORK=10

# Memcached cache size, in MB. Defaults to 64 (MB).
MEMCACHED_CACHE_SIZE=64

# Ubuntu apt mirror site. Defaults to `http://archive.ubuntu.com/ubuntu/`.
# You can set it to use nearest mirror.
#UBUNTU_MIRROR_SITE=http://archive.ubuntu.com/ubuntu/
```

Run:

```
docker run \
    --rm \
    --name iredmail-sogo \
    --env-file iredmail-docker.conf \
    --hostname sogo.mydomain.com \
    -p 20000:20000 \
    iredmail/sogo:nightly
```
