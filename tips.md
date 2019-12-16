__DRAFT DOCUMENT__

## MariaDB first-run and pre-start scripts

- `/docker/mariadb/first_run`: all files in this directory will be executed when MariaDB container is first ran.
- `/docker/mariadb/pre_start`: all first in this directory will be executed EVERY TIME the container runs.

Only files with `.sh`, `.sql`, `.mysql`, `.sql.gz` extension are supported.
