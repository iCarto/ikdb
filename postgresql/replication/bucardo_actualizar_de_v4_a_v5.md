# Actualizar de Bucardo 4.x a la versión 5.x

De la versión 4 a la 5 hay cambios substancias que hacen que el proceso de actualización no sea limpio. Deben instalarse los nuevos binarios y recrear por completo toda la estructura. En este artículo presentamos algunos consejos de como hacerlo.

Asumimos que un _downtime_ es aceptable, para simplificar las ideas básicas de como proceder con la actualización.

Como siempre empezaremos por hacer un backup de todas las bases de datos implicadas. Especialmente de la base de datos de configuraciones y los esquemas `bucardo` de las bases de datos replicadas.

El proceso resumido consiste en:

1. Guardar la configuración general y de replicación de bucardo
2. Desinstalar los binarios y borrar las configuraciones de "disco"
3. Eliminar triggers, tablas, usuarios, ... de bucardo de las bases de datos
4. Instalar los binarios actualizados
5. Hacer toda la configuración necesaria

# Guardar configuración

Revisamos y salvamos la configuración de replicación actual. Esto es un ejemplo para casos donde no haya estrategias a medida:

```shell
# Configuración general de bucardo
bucardo_ctl show all  # select * from bucardo.bucardo_config order by setting;

# Configuración de replicación
bucardo_ctl list db  # select * from bucardo.db;

bucardo_ctl list dbgroup  # select * from bucardo.dbgroup;

bucardo_ctl list sync  # select * from bucardo.sync;

bucardo_ctl list herd  # SELECT * FROM bucardo.herdmap h JOIN bucardo.goat g ON h.goat = g.id;

bucardo_ctl list table  # select * from bucardo.goat;
```

Si se tiene un sólo `sync` y todas las tablas configuradas participan de ese `sync` probablemente lo más sencillo sea permitir que cuando se configure de nuevo Bucardo cree los valores por defecto de `db_group` y `herd`. Por lo que sólo hay que guardar, los valores de `db`, `table` y configuración:

```shell
bucardo_ctrl show all > ~/bucarco-bck/bucardo.config.txt
bucardo_ctl list db > ~/bucarco-bck/bucardo.db.txt
psql -XtA -h localhost -p 5432 -U postgres -d bucardo -c "SELECT string_agg(schemaname || '.' || tablename, ' ') FROM bucardo.goat ;" > ~/bucarco-bck/bucardo.table.sql.txt
```

# Desinstalar binarios y configuraciones de disco

Hacemos un `kick` y comprobamos que se ha realizado para asegurarnos de que no quedan cambios pendientes. Paramos bucardo y prohibimos las escrituras en la bases de datos replicadas.

Desinstalamos los binarios de bucardo y configuraciones asociadas en disco. Aquí se proporcionan algunas de las rutas de ejemplo

```shell
sudo apt-get remove --purge bucardo
mv /etc/bucardorc ~/bucarco-bck/
mv /var/log/bucardo ~/bucarco-bck/log_bucardo
rm -rf /var/run/bucardo
# Borrar entradas del usuario `bucardo` de todos los .pgpass implicados
```

En este punto podemos eliminar también [los scripts de cron](https://thebuild.com/blog/2011/09/27/cleaning-up-after-your-bucardo-goats/), scripts de inicio u otras configuraciones que tengamos asociadas a la replicación con bucardo.

# Eliminar lo relacionado con bucardo de las bases de datos

Para empezar una configuración limpia debemos eliminar:

-   El usuario bucardo (o que estemos usando en la replicación)
-   La base de datos de configuración de bucardo
-   Los esquemas bucardo de las bases de datos replicados
-   Los triggers de las tablas replicadas

```shell
dropdb -h localhost -p 5432 -U postgres bucardo

# Para cada db replicada
# Al borrar el esquema bucardo en cascada se eliminan los triggers de las tablas
# esta es la forma menos tediosa de hacerlo.
psql -h my_host -p 5432 -U postgres -d my_db -c "DROP SCHEMA bucardo CASCADE;"

# Para cada cluster
dropuser -h my_host -p 5432 -U postgres bucardo
```

Si en el cluster de bucardo además de la base de datos "en producción" tenemos bases de datos antiguas, o si no resulta práctica borrar todo directamente tenemos algunas opciones:

-   Renombrar la base de datos de configuración
-   Renombrar el usuario `bucardo`
-   Reasignar la propiedad de los objetos con con `REASSIGN OWNED BY bucardo TO postgres;`

Generalmente esta es una alternativa válida

```shell
dropdb --if-exists -h localhost -p 5432 -U postgres old_bucardo
psql -h localhost -p 5432 -U postgres -d postgres -c "ALTER DATABASE bucardo RENAME TO old_bucardo"

# Para cada cluster
psql -h my_host -p 5432 -U postgres -d postgres -c "
    DROP ROLE IF EXISTS old_bucardo;
    ALTER ROLE bucardo RENAME TO old_bucardo;
"

# Para cada db replicada
psql -h my_host -p 5432 -U postgres -d my_db -c "DROP SCHEMA bucardo CASCADE;"
```

# Instalar binarios actualizados y configurar de nuevo la replicación

En el documento genérico sobre bucardo, `bucardo.md` se explica como instalar y configurar Bucardo v5. Podemos seguir ese documento.

Tras el `bucardo install`, realizar configuración general y añadir las bases de datos con `bucardo add db` en lugar de añadir las tablas a mano podemos partir del fichero que guardamos anteriormente `bucardo.table.sql.txt`:

```shell
B_DB_1=name1
B_DB_2=name2
DB_NAME=actual_name
B_SYNC=actual_name_sync
DB_HOST_1=localhost
DB_HOST_2=other_host

bucardo add table db="${B_DB_1}" $(cat bucardo.table.sql.txt)
bucardo add sync "${B_SYNC}" dbs="${B_DB_1}":source,"${B_DB_2}":source tables=$(sed 's/ /,/g' bucardo.table.sql.txt) conflict_strategy=bucardo_latest
bucardo validate "${B_SYNC}"
tail /var/log/bucardo/error.log
```
