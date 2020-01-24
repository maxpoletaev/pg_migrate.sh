# pg_migrate

Schema migration management script for PostgreSQL. `pg_migrate.sh` is dead
simple (~50 lines) and written in bash so it works everywhere and does not
require any extra dependencies but `psql`.

Before running you need to set a couple environment variables:

 * `POSTGRES_HOST` (default: 127.0.0.1)
 * `POSTGRES_PORT` (default: 5432)
 * `POSTGRES_USER` (default: postgres)
 * `POSTGRES_PASSWORD`
 * `POSTGRES_DB`

Migration files are located in the [`migrations`](/migrations/) directory.
Each migration is a plain SQL file which is sequentially executed by the
script. The filename must follow the following template: `0001_name.sql`.
Migrations are not wrapped in transactions by default, you should take care of
it by using `BEGIN` and `COMMIT` statements if needed.

There is no way to automatically rollback a migration when it is already applied
(if you’ve just came from Django or Rails world). The only way is to write a
new migration which would revert the changes made in the previous one.
