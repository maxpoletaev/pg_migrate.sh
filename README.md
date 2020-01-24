# pg_migrate

pg_migrate is a schema migration manager for PostgreSQL (but theoretically can
be easily changed to support any other RDBMS).

The thing is that pg_migrate is dead simple (only ~50 lines of code) and written
in bash so it works everywhere and does not require any dependencies.

Before using you need to set a couple environment variables:

 * `POSTGRES_HOST` (default: 127.0.0.1)
 * `POSTGRES_PORT` (default: 5432)
 * `POSTGRES_USER` (default: postgres)
 * `POSTGRES_PASSWORD`
 * `POSTGRES_DB`

Each migration is a plain SQL file which are sequentially executed by the
script. Migrations are not executed in a transaction by default, you should
take care of them by using `BEGIN` and `COMMIT` statements if needed.

There is no way to rollback a migration (if you’ve just came from Django or
Rails worlds). The only way is to add a new migration which would roll back the
previous one.
