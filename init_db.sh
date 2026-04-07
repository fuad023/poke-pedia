#!/bin/bash

source .env

sqlcmd() {
  docker exec -i sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -No "$@"
}

echo "Waiting for SQL Server to be ready..."
until sqlcmd -Q "SELECT 1" &>/dev/null; do
  sleep 2
done

echo "Creating database..."
sqlcmd -Q "IF EXISTS (SELECT name FROM sys.databases WHERE name = '$DB_DATABASE') DROP DATABASE $DB_DATABASE;"
sqlcmd -Q "CREATE DATABASE $DB_DATABASE;"

echo "Running init scripts..."

# schema
for f in database/schema/*.sql; do
  echo "Executing $f"
  docker cp "$f" sqlserver:/tmp/init_script.sql > /dev/null
  sqlcmd -d "$DB_DATABASE" -i "/tmp/init_script.sql"
done

# seed
# for f in database/seed/*.sql; do
#   echo "Executing $f"
#   docker cp "$f" sqlserver:/tmp/init_script.sql > /dev/null
#   sqlcmd -d "$DB_DATABASE" -i "/tmp/init_script.sql"
# done

echo "Done."
