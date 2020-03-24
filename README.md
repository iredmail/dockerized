All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of iRedMail Easy.

## Requirements

* Docker has some issue on Windows/macOS platform, please use Linux system
  as Docker host.

## Preparations

Create config file used to store your custom settings:

```
touch iredmail.conf
```

There're few REQUIRED parameters you should set in `iredmail.conf`:

```
# [REQUIRED] Server hostname and first mail domain
HOSTNAME=
FIRST_MAIL_DOMAIN=
FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=

# SQL user passwords.
VMAIL_DB_PASSWORD=
VMAIL_DB_ADMIN_PASSWORD=
AMAVISD_DB_PASSWORD=
ROUNDCUBE_DB_PASSWORD=
IREDAPD_DB_PASSWORD=

# Roundcube DES key, used to encrypt session data.
ROUNDCUBE_DES_KEY=
```

There're many OPTIONAL settings defined in file `default_settings.conf`, if
you'd like to change any of them, please write the same parameter name with
proper value in `iredmail.conf` to override it.

## Run the all-in-one container

To build and run iRedMail with an all-in-one container:

```
./build_all_in_one.sh
./run_all_in_one.sh
```

Notes:

- On first run, it needs to update SpamAssassin rules and ClamAV virus
  signature database, so it may take some time to finish, please be patient.

## Or, run with `docker-compose`

Note: It's not fully working, we're focusing on the all-in-one container right
now, will fix it later.

```
docker-compose build
docker-compose up
```
