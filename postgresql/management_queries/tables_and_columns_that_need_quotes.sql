WITH table_naming_issues AS (
    SELECT
        schemaname AS schemaname
        , tablename AS tablename
        , NULL AS columnname
        , 'TABLE' AS object_type
        , CASE WHEN tablename ~ '[A-Z]' THEN
            'Uppercase letters'
        WHEN tablename ~ '^[0-9]' THEN
            'Starts with number'
        WHEN tablename ~ '[^a-z0-9_]' THEN
            'Special characters'
        WHEN lower(tablename) <> tablename THEN
            'Mixed case'
        END AS naming_issue
    FROM
        pg_tables
    WHERE
        schemaname NOT IN ('pg_catalog'
            , 'information_schema')
        AND (tablename ~ '[A-Z]'
            OR tablename ~ '^[0-9]'
            OR tablename ~ '[^a-z0-9_]'
            OR lower(tablename) <> tablename)
)
, column_naming_issues AS (
    SELECT
        table_schema AS schemaname
        , table_name AS tablename
        , column_name AS columnname
        , 'COLUMN' AS object_type
        , CASE WHEN column_name ~ '[A-Z]' THEN
            'Uppercase letters'
        WHEN column_name ~ '^[0-9]' THEN
            'Starts with number'
        WHEN column_name ~ '[^a-z0-9_]' THEN
            'Special characters'
        WHEN lower(column_name) <> column_name THEN
            'Mixed case'
        END AS naming_issue
    FROM (
        SELECT
            table_schema
            , table_name
            , column_name
        FROM
            information_schema.columns
        WHERE
            table_schema NOT IN ('pg_catalog'
                , 'information_schema')) col_check
    WHERE
        col_check.column_name ~ '[A-Z]'
        OR col_check.column_name ~ '^[0-9]'
        OR col_check.column_name ~ '[^a-z0-9_]'
        OR lower(col_check.column_name) <> col_check.column_name)
-- Combine table and column issues
SELECT
    *
FROM
    table_naming_issues
UNION ALL
SELECT
    *
FROM
    column_naming_issues
ORDER BY
    schemaname
    , tablename
    , object_type
