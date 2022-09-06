-- Shows the size of the tables and their toast related table
-- https://hakibenita.com/sql-medium-text-performance
-- https://stackoverflow.com/questions/21738408/
-- https://stackoverflow.com/questions/41991380/
WITH objects AS (
    SELECT
        c1.oid AS oid_rel
        , c2.oid AS oid_toast
        , c2.relname AS toast_relname
        , c1.relnamespace::regnamespace AS schemaname
        , c1.relname AS tablename
        , c1.reltuples AS row_estimate
    FROM
        pg_catalog.pg_class c1
        LEFT JOIN pg_catalog.pg_class c2 ON c1.reltoastrelid = c2.oid
    WHERE
        c1.relkind = 'r'
        AND c1.relnamespace::regnamespace::text NOT IN ('pg_catalog'
            , 'information_schema')
            -- filter for tables or toast bigger than 1MB
            -- AND (pg_relation_size(c1.oid) > 1024 * 1024
            --    OR pg_relation_size(c2.oid) > 1024 * 1024)
)
, sizes AS (
    SELECT
        schemaname
        , tablename
        , pg_total_relation_size(oid_rel) AS total_table_bytes
        , pg_relation_size(oid_rel) AS table_bytes
        , pg_indexes_size(oid_rel) AS index_bytes
        , toast_relname
        , pg_relation_size(oid_toast) AS toast_bytes
        , pg_total_relation_size(oid_toast) AS total_toast_bytes
        , row_estimate
FROM
    objects
)
SELECT
    schemaname
    , tablename
    , pg_size_pretty(total_table_bytes) AS total_table_size
    , pg_size_pretty(table_bytes) AS table_size
    , pg_size_pretty(index_bytes) AS index_size
    , toast_relname -- if null no TOAST for this table
    , pg_size_pretty(toast_bytes) AS toast_size
    , pg_size_pretty(total_toast_bytes) AS total_toast_size
    , row_estimate
    , total_table_bytes - index_bytes - COALESCE(total_toast_bytes , 0) = table_bytes AS must_be_true -- a kind of explanation of column meanings
FROM
    sizes
ORDER BY
    1
    , 2;

