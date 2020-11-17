-- https://dataedo.com/kb/query/postgresql/list-foreign-keys
-- https://stackoverflow.com/questions/1152260/

-- Prints all the fks in the database
-- It excludes sqitch, bucardo and postgresql schemas
-- foreign_table: foreign table schema and name
-- rel: relationship symbol implicating direction. Hardcoded.
-- primary_table: primary (rerefenced) table schema and name
-- fk_columns: list of FK colum names, separated with ","
-- constraint_name: foreign key constraint name

-- USAGE:
-- psql -f find_all_fks.sql

-- Take care. The order of fk_columns, and primary_columns can differ from the original one. More work is need.

-- information_schema.constraint_column_usage is a view so using it is extreamly slow. Uncomment if you need it

select kcu.table_schema || '.' ||kcu.table_name as foreign_table
       , '>-' as rel
       , rel_tco.table_schema || '.' || rel_tco.table_name as primary_table
       , string_agg(kcu.column_name, ', ') as fk_columns
       , kcu.constraint_name
       , rco.update_rule as on_update
       , rco.delete_rule as on_delete
       , string_agg(ccu.column_name, ', ') as primary_columns
from information_schema.table_constraints tco
join information_schema.key_column_usage kcu
          on tco.constraint_schema = kcu.constraint_schema
          and tco.constraint_name = kcu.constraint_name
join information_schema.referential_constraints rco
          on tco.constraint_schema = rco.constraint_schema
          and tco.constraint_name = rco.constraint_name
join information_schema.table_constraints rel_tco
          on rco.unique_constraint_schema = rel_tco.constraint_schema
          and rco.unique_constraint_name = rel_tco.constraint_name
join information_schema.constraint_column_usage AS ccu on ccu.constraint_schema = tco.constraint_schema and ccu.constraint_name = tco.constraint_name
where tco.constraint_type = 'FOREIGN KEY'
      and kcu.table_schema NOT IN ('sqitch', 'bucardo')
group by kcu.table_schema
         , kcu.table_name
         , rel_tco.table_schema
         , rel_tco.table_name
         , kcu.constraint_name
         , rco.update_rule
         , rco.delete_rule
order by kcu.table_schema
         , kcu.table_name
;


-- To regenerate rules something like this can be used
/*

WITH tmp AS ( PREVIOUS_SELECT ) 
    SELECT
        'ALTER table ' || foreign_table || ' DROP CONSTRAINT ' || constraint_name || ', ADD CONSTRAINT ' || constraint_name || ' FOREIGN KEY (' || fk_columns || ') REFERENCES ' || primary_table || '(' || primary_columns || ') ON UPDATE CASCADE ON DELETE NO ACTION;'
    FROM tmp
;
*/
