-- https://blog.hagander.net/tracking-foreign-keys-throughout-a-schema-242/
-- What are all the tables and columns referencing the primary key of the given
-- table directly or indirectly

-- USAGE:
-- psql -v var_table=<schema>.<table> -f track_fks_for_table_pk.sql

WITH RECURSIVE what (tbl) AS (
   VALUES (:'var_table')
),
t (oid, key, constrid) AS (
 SELECT tbl::regclass::oid, conkey, NULL::oid
  FROM what INNER JOIN pg_constraint ON (contype='p' AND conrelid=tbl::regclass)
UNION ALL
 SELECT conrelid, conkey, c.oid
 FROM pg_constraint c
 INNER JOIN t ON (c.confrelid=t.oid AND c.confkey=t.key)
 WHERE contype='f'
)
SELECT nspname, relname, key, ARRAY(
    SELECT attname FROM pg_attribute a WHERE a.attrelid=t.oid AND attnum=ANY(key)
  )
FROM t
INNER JOIN pg_class cl ON cl.oid=t.oid
INNER JOIN pg_namespace n ON n.oid=cl.relnamespace;
