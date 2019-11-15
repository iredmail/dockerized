All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of iRedMail Easy.

## How to override default settings defined in `env.defaults`

Please create file `.env` under top directory and write the parameter you
want to override with new value.

For example, MySQL root password is set to `secret` in env file `env.defaults`:

```
MYSQL_ROOT_PASSWORD=secret
```

You can change it by writing same parameter name with different value `.env`
file like below:

```
MYSQL_ROOT_PASSWORD=my-secret-password
```
