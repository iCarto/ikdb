-- https://momjian.us/main/blogs/pgblog/2019.html#February_6_2019

-- Pretty prints table permissions. Instead of:

-- SELECT relacl FROM pg_class WHERE relname = 'test';
--                         relacl
-- --------------------------------------------------------
--  {postgres=arwdDxt/postgres,bob=r/postgres,=r/postgres}

-- get
-- grantor  | grantee  |                         array_agg
-- ----------+----------+-----------------------------------------------------------
--  postgres | -        | {SELECT}
--  postgres | postgres | {SELECT,UPDATE,DELETE,INSERT,REFERENCES,TRIGGER,TRUNCATE}
--  postgres | bob      | {SELECT}

SELECT nsp.nspname as schema, relname as tablename, a.grantor::regrole, a.grantee::regrole, array_agg(privilege_type)
FROM pg_class join pg_namespace nsp on nsp.oid = pg_class.relnamespace,  aclexplode(relacl) AS a

GROUP BY 1, 2, 3, 4 
ORDER BY schema, tablename, grantor, grantee
;
-- Ideas
-- Include WHERE clause to filter tables or schemas
-- dash (-) represents public
-- use CASE a.grantee::regrole WHEN '-' THEN 'PUBLIC' ELSE a.grantee::regrole or similar
-- By using the pg_proc table instead of pg_class, you can display verbose function permissions. This method can be used for any system table that has a column of type aclitem[].
