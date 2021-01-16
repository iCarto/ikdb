-- Shows the size of the tables and their toast related table bigger than 1MB
-- https://hakibenita.com/sql-medium-text-performance

SELECT          
    c1.relnamespace::regnamespace as schemaname
    , c1.relname as tablename
    , pg_size_pretty(pg_relation_size(c1.oid)) AS size
    , c2.relname AS toast_relname
    , pg_size_pretty(pg_relation_size(c2.oid)) AS toast_size
FROM
    pg_class c1
    JOIN pg_class c2 ON c1.reltoastrelid = c2.oid
WHERE
    c1.relkind = 'r'
    AND c1.relnamespace::regnamespace::text NOT IN ('pg_catalog', 'information_schema')
    AND ( pg_relation_size(c1.oid) > 1024*1024 OR pg_relation_size(c2.oid) > 1024*1024 )


ORDER BY
    1, 2
 ;

