#!/bin/bash
set -e
# Define variables
export MSSQL_PID=Developer
export MSSQL_SA_PASSWORD=Passw0rd1
export MSSQL_TCP_PORT=1433
export DATABASE_NAME=BoroMainDB
export MSSQL_TLS_CERT_VERIFY_MODE=0
# Start SQL Server
/opt/mssql/bin/sqlservr &
# Wait for SQL Server to start
echo "Waiting for SQL Server to start..."
sleep 100
# Run SQL scripts
echo "Creating database schema and inserting data..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD -i /scripts/dbinit.sql -b &
# Keep SQL Server running in the foreground
echo "SQL Server is running..."
while : ; do
    sleep 1
done
