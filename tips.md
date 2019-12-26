__DRAFT DOCUMENT__

## MariaDB

- MySQL root password will be reset to a randomly generated strong password
  each time you start the container. If you prefer to hard-code the password,
  please set below parameters in `iredmail.conf`:

```
MYSQL_USE_RANDOM_ROOT_PASSWORD=NO
MYSQL_ROOT_PASSWORD=your-preferred-strong-password
```
