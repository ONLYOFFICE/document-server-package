SET PGPASSWORD=postgres&

SET "psql=C:\PROGRA~1\PostgreSQL\10\bin\psql.exe"

%psql% -U postgres -c "CREATE USER onlyoffice  WITH PASSWORD 'onlyoffice';"

%psql% -U postgres -c "CREATE DATABASE onlyoffice;"

%psql% -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE onlyoffice  TO onlyoffice;"