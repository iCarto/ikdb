-- https://joelonsql.com/2015/05/16/finding-missing-foreign-keys/

-- Using a naming convention tries to find tables that probably should have a 
-- foreign kiss and don't have it

-- USAGE:
-- Change the condition to match your naming conventions
-- psql -f find_probably_missing_fks.sql

SELECT
    pg_catalog.pg_namespace.nspname,
    pg_catalog.pg_class.relname,
    pg_catalog.pg_attribute.attname
FROM pg_catalog.pg_namespace
INNER JOIN pg_catalog.pg_class ON (pg_catalog.pg_class.relnamespace = pg_catalog.pg_namespace.oid)
INNER JOIN pg_catalog.pg_attribute ON (pg_catalog.pg_attribute.attrelid = pg_catalog.pg_class.oid)
WHERE pg_catalog.pg_class.relkind = 'r'
AND pg_catalog.pg_attribute.attnum > 0
AND NOT pg_catalog.pg_attribute.attisdropped
AND pg_catalog.pg_namespace.nspname NOT IN ('pg_toast','information_schema','pg_catalog', 'sqitch', 'bucardo')

-- CHANGE this line to match your naming conventions
AND (pg_catalog.pg_attribute.attname LIKE 'id_%' OR pg_catalog.pg_attribute.attname = 'gid')

AND EXISTS (
    -- The column is PRIMARY KEY in some table
    SELECT 1 FROM pg_catalog.pg_constraint
    WHERE pg_catalog.pg_constraint.contype = 'p'
    AND pg_catalog.pg_get_constraintdef(pg_catalog.pg_constraint.oid) = format('PRIMARY KEY (%s)',pg_catalog.pg_attribute.attname)
)
AND NOT EXISTS (
    -- There is no FOREIGN KEY on this column
    SELECT 1 FROM pg_catalog.pg_constraint
    WHERE pg_catalog.pg_constraint.contype = 'f'
    AND pg_catalog.pg_constraint.conrelid = pg_catalog.pg_class.oid
    AND pg_catalog.pg_get_constraintdef(pg_catalog.pg_constraint.oid) LIKE (format('FOREIGN KEY (%s)',pg_catalog.pg_attribute.attname) || '%')
)
AND NOT EXISTS (
    -- This column is not the PRIMARY KEY of it's own table,
    -- since if it was, we wouldn't require a FOREIGN KEY on it
    SELECT 1 FROM pg_catalog.pg_constraint
    WHERE pg_catalog.pg_constraint.contype = 'p'
    AND pg_catalog.pg_constraint.conrelid = pg_catalog.pg_class.oid
    AND pg_catalog.pg_get_constraintdef(pg_catalog.pg_constraint.oid) = format('PRIMARY KEY (%s)',pg_catalog.pg_attribute.attname)
)
ORDER BY
pg_catalog.pg_namespace.nspname,
pg_catalog.pg_class.relname,
pg_catalog.pg_attribute.attnum
;

