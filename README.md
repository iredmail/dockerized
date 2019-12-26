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
```

There're many OPTIONAL settings defined in file `default_settings.conf`, if
you'd like to change any of them, please write the same parameter name with
proper value in `iredmail.conf` to override it.

## Run the all-in-one container

To run iRedMail with an all-in-one container:

```
docker build -t iredmail:latest -f Dockerfiles/Dockerfile .
./run.sh
```

## Or, run with `docker-compose`

```
docker-compose build
docker-compose up
```
