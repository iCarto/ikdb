# Bucardo

En este artículo describiremos brevemente que es Bucardo y nociones básicas de uso e instalación en una configuración _multi-source_. Bucardo es una herramienta con muchas opciones así que nos limitaremos a una configuración básica.

[Bucardo](https://bucardo.org/Bucardo/) es una solución de replicación asíncrona basada en PostgreSQL para arquitecturas tanto multi-source como multi-target. Está basado en triggers con un demonio en Perl que escucha los eventos `NOTIFY`. Requiere de una base de datos PostgreSQL donde se realiza toda la configuración de replicación, que puede estar en un servidor distinto al de las bases de datos a replicar. En cada uno de las bases de datos "replicadas" se creará un esquema bucardo donde gestiona información sobre los cambios que deben sincronizarse. El demonio sólo es necesario en el servidor central.

Las últimas versiones pueden sincronizar entre distintas bases de datos, pero la de configuración (y el source) debe ser PostgreSQL. No hay mucha documentación de su uso en bases de datos que no sean PostgreSQL.

En iCarto llevamos usándola bastante tiempo en configuraciones multi-source sin problemas, y es una de las soluciones más recomendadas en la comunidad PostgreSQL. A pesar de que hay bastante artículos, la documentación oficial (sobre todo de la versión 5) no es nada buena.

La configuración se puede hacer a través de la CLI o manipulando directamente la base de datos de configuración. Nuestra recomendación es usar la CLI a no ser que tengas claro lo que haces.

-   [Página del proyecto](https://bucardo.org/Bucardo/)
-   [GitHub](https://github.com/bucardo/bucardo)
-   Como la documentación puede estar "rota" lo mejor es acudir directamente a los [ficheros Markdown en el repositorio](https://github.com/bucardo/bucardo_org/tree/master/Bucardo), aunque están mezclando documentos de la última versión y versiones previas.

Por decirlo de alguna forma Bucardo tiene tres componentes principales:

-   Los binarios en sí: CLI y daemons
-   La base de datos de configuración.
-   Las bases de datos replicadas. Donde habrá un esquema Bucardo, y se instalarán triggers en las tablas a replicar.

Cuando se produce un cambio los daemons son notificados y lanza el proceso de "replicación" en general de forma inmediata. Por lo que la replicación se produce prácticamente en tiempo real. En versiones anterior de Bucardo era recomendable tener tareas periódicas que ejecutaran un `kick` para forzar la sincronización, y limpiar las tablas donde se registran los cambios cada cierto tiempo. En la versión 5 esto no es necesario, aunque si es habitual que alguna de las replicas se caiga nuestra recomendación es mantener las tareas periódicas.

Si el demonio está parado `bucardo stop`, los triggers siguen almacenando cambios en unas tablas de registro `bucardo.delta_myschema_mytable`. Cuando se arranca el demonio `bucardo start` se lanza la sincronización de nuevo entre las bases de datos.

# Conceptos

-   `db` son las bases de datos implicadas en la replicación. Cada una tendrá un esquema bucardo, donde están definidos los triggers y otras tablas que se usan para la gestión de la replicación. Se almacenan en la tabla `bucardo.db`. Esta configuración sirve para indicar como bucardo puede conectar a esas bases de datos, host, puerto, ...
-   `dbgroup` . Un grupo de bases de datos que participan en un proceso de replicación y su "rol", `target` o `source`. Se puede crear de forma explicita o dejar que bucardo cree uno automático al crear un `sync`
-   `relation`, antes llamado `goat` son tablas o secuencias de una base de datos implicadas en un proceso de replicación. Se almacenan en la tabla `bucardo.goat`
-   `relgroup` (antes llamado `herd`), se almacenan en la tabla `bucardo.herd`. Es un grupo de tablas o secuencias que participan en la replicación con el mismo comportamiento. Un `herd` se puede crear de forma manual, o de forma automática cuando se usa `add table` o `add sync`
-   `sync`, es la definición del proceso de replicación en sí. Aquí se indica el tipo de estrategia de resolución de conflictos, ... Las bases de datos, su rol, y las relaciones que participan de ese `sync` pueden indicarse mediante el `dbgroup` y/o `relgroup`, o directamente indicar las tablas y bases de datos y dejar que `add sync` cree los grupos automáticamente.

## Tablas principales del esquema `bucardo` de la base de datos `bucardo`

En estas tablas es donde se guarda la configuración principal:

-   `db`: Datos de las bases de datos que se sincronizan. Usuario de conexión, nombre interno que usa bucardo para esa bd, ...
-   `dbgroup`: Almacena los nombres de los `dbgroup` que mencionamos en los "Conceptos"
-   `dbmap`: Relaciona las `db` con los `dbgroup`
-   `goat`: Almacena los datos de los objetos (`relation`) a replicar y la forma de replicación si es específica
-   `herd`: Almacena los nombres de los `relgroup` que mencionamos en los "Conceptos"
-   `herdmap`: Relaciona los `relgroup` con los `relation`
-   `sync`: Almacena los datos de los `sync` que mencionamos en los "Conceptos"
-   `bucardo_config`: Configuración general de bucardo

# Instalar o actualizar el software

El paquete de los repositorios incluido el PPA de PostgreSQL está desactualizado así que es mejor instalar desde las fuentes.

Otros requisitos son `dbix-safe`, que si está actualizado en los repositorios así que lo podemos instalar por paquete y el lenguaje `plperl` correspondiente a la versión de PostgreSQL que tengamos instalada.

```shell
# si estaba instalado de antes
bucardo stop
apt-get remove --purge bucardo

# dependencias básicas
apt-get install postgresql-plperl-${PG_VERSION} libdbix-safe-perl

wget https://github.com/bucardo/bucardo/archive/5.6.0.tar.gz
tar zxf 5.6.0.tar.gz
cd bucardo-5.6.0/

perl Makefile.PL
make
make install

bucardo --version # bucardo version 5.6.0
```

# Actualizar la base de datos de configuración

Si estamos actualizando tras instalar el software debemos actualizar la configuración. Esto sólo es válido para actualizaciones de minor. No es posible actualizar de la versión 4.x a la 5.x de este modo (hay que recrear toda la instalación)

```shell
bucardo stop
bucardo upgrade
bucardo validate all
bucardo start
```

# Limitantes del ejemplo

Consideraciones (para este ejemplo):

-   Configuración source-source de dos bases de datos.
-   Bucardo corre en el mismo servidor que una de las bases de datos a replicar
-   Las bases de datos a replicar tienen el mismo nombre pero en distintos servidores
-   Las bases de datos a replicar están creadas previamente, son accesibles y las tablas a replicar tienen el mismo esquema y los mismos datos
-   Todas las tablas a replicar tienen PK o UNIQUE
-   No es estrictamente necesario, pero si recomendable tener los mismos roles en ambos clusters
-   Las secuencias de las tablas a replicar generan valores distintos para cada base de datos
-   Si tenemos triggers, son iguales en ambas tablas. [Bucardo desactiva los triggers](https://www.endpoint.com/blog/2014/12/22/bucardo-replication-trigger-enabling) antes de replicar los datos, por lo que si son distintos el de la tabla destino no entrará en funcionamiento.
-   Por simplificar dejamos que Bucardo cree automáticamente los grupos
-   La forma en que Bucardo se conecta a las bases de datos es muy particular de cada instalación y depende de varios factores, como el usuario con el que se corre el demonio. el usuario que se use para conectar a las bases de datos, las configuraciones de variables de entorno como `PGPASSWORD` o `.pgpass`, el `/etc/bucardorc`, el `pg_hba.conf`, ... en este ejemplo asumimos una forma de trabajo muy sencilla que "simplemente funciona".

# Instalar la base de datos de configuración

El proceso de crear la configuración de replicación sería similar al siguiente:

```shell
# Bucardo almacena un fichero en el directorio indicado por `--piddir` o
# `bucardo set piddir=ruta`. Por defecto se usa `/var/run/bucardo` que en la mayoría
# de distribuciones no es persistente, por lo que se debe crear un servicio que haga
# que Bucardo arranque con el servidor y se asegure que la ruta existe y tenga
# los permisos adecuados. Por simplificar aquí lo creamos en $HOME
mkdir -p /var/log/bucardo
mkdir -p "${HOME}/.run/bucardo"

# En la instalación inicial combiene ser explícitos sobre los parámetros
# Nos conectaremos a la bd postgres con el usuario postgres
# y el comando install creará la bd bucardo y al usuario bucardo
# pg_hba debe estar configurado para aceptar este tipo de conexión
bucardo install -h localhost -p 5432 --no-bucardorc -d postgres -U postgres --piddir "${HOME}/.run/bucardo"

# El fichero `.pgpass` contendrá una entrada con la contraseña aleatoria con
# la que se ha creado el usuario bucardo. A efectos del ejemplo resulta
# conveniente modificarla para que no contenga "caracteres extraños"

psql -h localhost -p 5432 -U postgres -c "ALTER ROLE bucardo WITH PASSWORD 'el_password'"

echo "dbport = 5432
dbhost = localhost
dbname = bucardo
dbuser = bucardo
dbpass = el_password" > /etc/bucardorc  # y ajustar permisos. Cuidado con tener líneas en blanco en este fichero

bucardo show all  # debería funciona y darnos una lista de configuración

# Modificar la configuración general con bucardo set name=value
bucardo set default_email_from=root
bucardo set default_email_to=root
bucardo set reason_file=/var/log/bucardo/bucardo.restart.reason.txt
bucardo set piddir=${HOME}/.run/bucardo

bucardo help add db  # Ayuda de como añadir una base de datos a replicar

# Configurar la replicación

B_DB_1=name1
B_DB_2=name2
DB_NAME=actual_name
B_SYNC=actual_name_sync
DB_HOST_1=localhost
DB_HOST_2=other_host
BUCARDO_PW=el_password

# Usar la misma clave que la del usuario bucardo en cluster 1
# Editar .pgass para poder conectar automáticamente como bucardo al cluster 2
createuser -h "${DB_HOST_2}" -U postgres --superuser --replication -P bucardo

bucardo add db "${B_DB_1}" dbname="${DB_NAME}" host="${DB_HOST_1}" pass="${BUCARDO_PW}"
bucardo add db "${B_DB_2}" dbname="${DB_NAME}" host="${DB_HOST_2}" pass="${BUCARDO_PW}"

# Al añadir el parámetro `pass` almacenará en claro en la tabla `bucardo.db` la
# contraseña. Se debe modificar `pg_hba.conf` para que sólo bucardo y postgres
# tengan acceso a la base de datos `bucardo`

bucardo add sync "${B_SYNC}" dbs="${B_DB_1}":source,"${B_DB_2}":source tables=LISTA_DE_TABLAS_SEPARADA_POR_COMAS conflict_strategy=bucardo_latest

# Si tenemos una "lista de tablas" generada a partir de otra bd de bucardo con
# psql -XtA -h localhost -p 5432 -U postgres -d bucardo -c "SELECT string_agg(schemaname || '.' || tablename, ' ') FROM bucardo.goat ;" > ~/bucarco-bck/bucardo.table.sql.txt
# en lugar del comando anterior usamos:
# bucardo add table db="${B_DB_1}" $(cat bucardo.table.sql.txt)
# bucardo add sync "${B_SYNC}" dbs="${B_DB_1}":source,"${B_DB_2}":source tables=$(sed 's/ /,/g' bucardo.table.sql.txt) conflict_strategy=bucardo_latest

bucardo validate "${B_SYNC}"

bucardo start
tail -50 /var/log/bucardo/log.bucardo
bucardo status
bucardo status "${B_SYNC}"

# sólo para asegurarnos que nada se rompe al hacer kick
bucardo kick "${B_SYNC}"
tail -50 /var/log/bucardo/log.bucardo
```

# Referencias:

-   [Presentación sobre Bucardo 5](https://bucardo.org/slides/b5_multi_master/)
-   [Ejemplo de configuración de multi-active en Bucardo 4](https://beastiebytes.com/postgresql-master-master-replication-with-bucardo.html). Incluye un método sencillo para generar secuencias distintas.
-   [Using Bucardo 5.3 to Migrate a Live PostgreSQL Database](https://www.compose.com/articles/using-bucardo-5-3-to-migrate-a-live-postgresql-database/)
-   [Bootstrapping Bucardo Master/Master Replication](https://justatheory.com/2013/02/bootstrap-bucardo-mulitmaster/). Un buen artítulo de David Wheeler
-   [Un Gist con un ejemplo de instalación](https://gist.github.com/Leen15/da42bd23b363867e14a378d824f2064e)
-   [Bucardo replication workarounds for extremely large Postgres updates](https://www.endpoint.com/blog/2016/05/31/bucardo-replication-workarounds-for)
-   [Conflict handling with Bucardo and multiple data sources](https://www.endpoint.com/blog/2014/07/24/postgresql-conflict-handling-with)
-   [Bucardo replication to other tables with customname](https://www.endpoint.com/blog/2011/09/05/bucardo-postgresql-replication-to-other)
-   [Postgres session_replication role - Bucardo and Slony’s powerful ally](https://www.endpoint.com/blog/2015/01/28/postgres-sessionreplication-role)
-   [Version 5 of Bucardo database replication system](https://www.endpoint.com/blog/2014/06/23/bucardo-5-multimaster-postgres-released)
-   [Bucardo Replication Update is Slow?](https://saifulmuhajir.web.id/postgresql-bucardo-replication-update-is-slow/)
-   [Dockerfile para la instalación de Bucardo](https://github.com/pelgrim/bucardo_docker_image). Es útil para al menos tener una alternativa para la automatización de la instalación que suele ser problemática.
