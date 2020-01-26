#!/bin/bash

# PostgreSQL schema migration manager
# https://github.com/zenwalker/pg_migrate.sh

set -e

MIGRATIONS_DIR="migrations"
MIGRATIONS_TABLE="schema_version"

POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_HOST=${POSTGRES_HOST:-127.0.0.1}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
PG_PASSWORD="$POSTGRES_PASSWORD"

alias psql="psql -qtAX -v ON_ERROR_STOP=1 -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -d $POSTGRES_DB"
shopt -s expand_aliases

# Make sure schema_version table exists
migrations_table_exists=`psql -c "SELECT to_regclass('$MIGRATIONS_TABLE')"`
if  [[ ! $migrations_table_exists ]]; then
    echo "Creating $MIGRATIONS_TABLE table"
    psql -c "CREATE TABLE $MIGRATIONS_TABLE (version INT PRIMARY KEY, applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW())"
fi

# Get the current version of schema
current_version=`psql -c "SELECT COALESCE(MAX(version), 0) FROM $MIGRATIONS_TABLE"`
echo "Current schema version: $current_version"

# Get migration files
cd "$MIGRATIONS_DIR"
migration_files=`ls *.sql | sort -V`

# Apply migration files
something_applied=false
for file in $migration_files; do
    version=`echo $file | sed "s/^0*//" | sed "s/_.*//"`

    if (( $version > $current_version )); then
        current_version=$version
        something_applied=true
        echo "Applying $file"

        psql < $file
        psql -c "INSERT INTO $MIGRATIONS_TABLE (version) VALUES ($version);"
    fi
done

if ! $something_applied; then
    echo "No migrations to apply"
fi
