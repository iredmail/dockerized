All files under `Dockerfiles/`, `config/`, `entrypoints/`, `files/` are
generated with ansible code of iRedMail Easy.

## Usage

Create config file used to store your custom settings:

```
touch env.custom
```

Check default settings in file `env.defaults`, if there's any setting you want
to change, please write the parameter in file `env.custom` with proper value.

For example, MySQL root password is set to `secret` in env file `env.defaults`:

```
MYSQL_ROOT_PASSWORD=secret
```

You can change it by writing same parameter name with proper value in
`env.custom` like below:

```
MYSQL_ROOT_PASSWORD=my-secret-password
```

Start the containers:

```
docker-compose up
```
