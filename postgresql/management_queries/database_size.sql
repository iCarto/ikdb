-- This is the total size of the db in disk.
-- The sum of the `total_table_size` from `show_tables_and_toast_size.sql` is the same
-- value than db_size.
SELECT
    datname AS db_name
    , pg_size_pretty(pg_database_size(datname)) AS db_size
FROM
    pg_database
ORDER BY
    pg_database_size(datname) DESC;

