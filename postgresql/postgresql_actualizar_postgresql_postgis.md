# Como actualizar la versión de PostgreSQL/PostGIS (y el Sistema Operativo)

Actualizar una versión reciente de PostgreSQL o PostGIS no es "complicado" ni requiere apenas _downtime_ en bases de datos pequeñas. Hay una enorme cantidad de artículos que documentan como actualizar PostgreSQL, PostGIS o ambos.

El objetivo de este artículo es:

-   Presentar algunas consideraciones a tener en cuenta, _a priori_, que pueden complicar el proceso, especialmente si se quiere actualizar la versión del sistema operativo.
-   Presentar algunos artículos de interés que hablan de como llevar a cabo este proceso
-   Presentar algunas consideraciones a tener en cuenta _a posteriori_

## Consideraciones previas

Antes de cualquier actualización mayor de PostgreSQL/PostGIS o el sistema operativo debe realizarse cierta planificación:

-   Leer las _release notes_ de [PostgreSQL](https://www.postgresql.org/docs/release/) y de [PostGIS]](http://postgis.net/docs/release_notes.html). Especialmente las secciones que hablan de _incompatibilities_, _breaking changes_ y _migration_. Generalmente no hay problemas graves, pero en ocasiones puede ser necesario modificar el código de nuestra aplicación o llevar a cabo pasos adicionales como regenerar los índices. Las webs de [Why upgrade PostgreSQL]((https://why-upgrade.depesz.com) y la de [Bucardo](https://bucardo.org/postgres_all_versions.html) nos dan otra forma de ver los cambios.

-   Estudiar la [compatibilidad entre la versión de PostGIS, gdal y PostgreSQL](http://trac.osgeo.org/postgis/wiki/UsersWikiPostgreSQLPostGIS).

-   Revisar si se ha modificado a mano `spatial_ref_sys`. Extraer las diferencias, y revisar que cambios son necesarios realizar tras la actualización. El script de `postgis_restore.pl`, intenta gestionar las modificaciones en `spatial_ref_sys`, pero depende de que versiones de PostGIS estemos empleando y de como hagamos el dump. Así que es obligatorio revisarlo a mano, cuando no tengamos el proceso muy trabajado.

-   Actualizar el sistema operativo cuando PostgreSQL [está instalado](<(https://www.commandprompt.com/blog/upgrading-ubuntu-lts-and-postgresql/)>) puede ser [problemático](https://www.paulox.net/2020/04/24/upgrading-postgresql-from-version-11-to-12-on-ubuntu-20-04-focal-fossa/), sobre todo con [versiones antiguas](https://askubuntu.com/questions/873091/postgresql-fails-to-reinstall-after-upgrading-ubuntu-12-04-to-14-04). Es [recomendable usar](https://www.postgresql.org/download/linux/ubuntu/) el propio [repositorio de PostgreSQL](https://wiki.postgresql.org/wiki/Apt) en lugar del de la distribución para tener un mayor control de las versiones a instalar.

-   Si hay que actualizar PostgreSQL y el sistema operativo a la vez nuestra aproximación suele ser. a) Actualizar primero el PostgreSQL a una versión disponible en ambas versiones del sistema operativo que se quiera usar. b) Comprobar que todo funciona. c) Desinstalar los binarios de la versión antigua `apt-get remove postgresql-{PG_OLD_VERSION}`. d) Actualizar el sistema operativo. e) Tras un tiempo prudencial eliminar los archivos del clúster antiguo que quedan en disco. En caso de usar Ubuntu para revisar las versiones se puede usar: [Ubuntu Updates](https://www.ubuntuupdates.org/). [Ubuntu Updates PPA de PostgreSQL](https://www.ubuntuupdates.org/ppa/postgresql). [Página de paquetes de Ubuntu](https://packages.ubuntu.com/). En caso de usar los paquetes de Ubuntu esto no suele ser posible. En caso de usar el PPA de PostgreSQL no suele dar problemas.

-   Si usamos el PPA de PostgreSQL es interesante configurar [la prioridad de este repositorio](https://wiki.postgresql.org/wiki/Apt/FAQ#I_want_only_specific_packages_from_this_repository) para evitar sorpresas.

-   Revisar el Changelog de otros paquetes relevantes. Por ejemplo [Bucardo](https://github.com/bucardo/bucardo/blob/master/Changes)

-   Si se usa `pg_dump` o `pg_upgrade` para actualizar debe usarse la versión más reciente de los binarios. Una forma de asegurarse de ello es usar las rutas absolutas a los ejecutables. Al menos en Ubuntu, después de instalar una nueva versión, puede suceder que algunos binarios como `pg_dump` estén apuntando a la versión antigua en lugar de a la nueva. Si tenemos scripts que no usen las rutas absolutas, podemos fijar la versión a través de [pg_wrapper](http://manpages.ubuntu.com/manpages/trusty/man1/pg_wrapper.1.html), o fijar la variable de entorno `PGCLUSTER`

```shell
$ pg_dump --version
pg_dump (PostgreSQL) 9.1.24

export PGCLUSTER=9.3/main
pg_dump --version
pg_dump (PostgreSQL) 9.3.17
```

-   Preparar los ficheros de configuración especialmente `postgresql.conf`. Los valores por defecto pueden cambiar, y hay parámetros que pueden aparecer o desaparecer. Comparar las configuraciones, prepararlas y probarlas antes de la actualización en si reduce los problemas. La web [postgresqlCO.NF](https://postgresqlco.nf/en/doc/param/) tiene un listado de parámetros de configuración e indica en que versión aparecen o desaparecen.

Otras consideraciones habituales a tener cuenta serían:

-   Revisar el espacio en disco disponible y el espacio en disco [usado por la base de datos](https://wiki.postgresql.org/wiki/Disk_Usage).
-   Hacer una copia de seguridad

## Como actualizar PostgreSQL

En resumen hay tres formas de actualizar PostgreSQL:

-   Un _dump lógico_ seguido de un restore con herramientas como `pg_dumpall`, `pg_dump`, `pg_restore` y `psql`
-   Mediante algún mecanismo de replicación, como _logical replication_, _pglogical_, _Slony_, _Bucardo_, ...
-   Mediante `pg_upgrade`

La "mejor" opción dependerá de:

-   La versión actual y la versión a la que se quiere actualizar.
-   El _downtime_ aceptable
-   El tamaño de la base de datos y el espacio disponible en disco
-   Extensiones y aplicaciones relacionadas que se estén usando (PostGIS, ...)
-   La infraestructura existente. Número de clusters a actualizar, velocidad de la red, ...

### Artículos de ayuda

-   [Documentación Oficial](https://www.postgresql.org/docs/current/upgrading.html)
-   [Upgrading Your Database to PostgreSQL Version 10 - What You Should Know](https://severalnines.com/blog/upgrading-your-database-to-postgresql-version-10)
-   [A primer on PostgreSQL upgrade methods](https://www.cybertec-postgresql.com/en/a-primer-on-postgresql-upgrade-methods/)
-   [Upgrading PostgreSQL major versions using logical replication](https://www.cybertec-postgresql.com/en/upgrading-postgres-major-versions-using-logical-replication/)
-   [PostgreSQL Upgrade Using pg_dumpall](https://www.percona.com/blog/2019/03/18/postgresql-upgrade-using-pg_dumpall/)
-   [PostgreSQL Upgrade Using pg_dump/pg_restore](https://www.percona.com/blog/2019/03/27/postgresql-upgrade-using-pg_dump-pg_restore/)
-   [Replication Between PostgreSQL Versions Using Logical Replication](https://www.percona.com/blog/2019/04/04/replication-between-postgresql-versions-using-logical-replication/)
-   [Continuous Replication From a Legacy PostgreSQL Version to a Newer Version Using Slony](https://www.percona.com/blog/2019/04/09/continuous-replication-from-legacy-postgresql-version-using-slony/)
-   [Fast Upgrade of Legacy PostgreSQL with Minimum Downtime Using pg_upgrade](https://www.percona.com/blog/2019/04/12/fast-upgrade-of-legacy-postgresql-with-minimum-downtime-using-pg_upgrade/)

### Como actualizar PostGIS

La documentación oficial de PostGIS describe como [realizar una actualización](http://postgis.net/docs/postgis_installation.html#upgrading), _soft_ cuando actualizamos el _minor_ o _hard_ cuando actualizamos el _major_. En versiones menores a PostgreSQL 9.1 y PostGIS 1.5, puede ser un poco más complicado que lo descrito pero obviando ese caso se puede simplificar a hacer un dump y un restore con un script que viene en la distribución de PostGIS:

```shell
pg_dump -h localhost -p 5432 -U postgres -Fc -b -v -f "/somepath/olddb.backup" olddb
perl utils/postgis_restore.pl "/somepath/olddb.backup" | psql -h localhost -p 5432 -U postgres newdb 2> errors.txt
```

Pero habrá que tener cuidado si hemos modificado previamente la tabla `spatial_ref_sys`.

El anterior es un proceso sencillo y seguro pero hay artículos describiendo otra forma de hacerlo, que pueden resultar útiles en caso de situaciones particulares:

-   Un [artículo de Paul Ramsey](http://blog.cleverelephant.ca/2016/08/postgis-upgrade.html) comentando la problemática general
-   Artículos sobre el uso de `pg_upgrade`[1](https://www.bostongis.com/blog/index.php?/archives/268-Using-pg_upgrade-to-upgrade-PostGIS-without-installing-an-older-version-of-PostGIS.html), [2](https://www.zimmi.cz/posts/2017/upgrading-postgresql-95-to-postgresql-96-with-postgis/), [3](https://www.zimmi.cz/posts/2018/centos-postgis-upgrade-hell-yet-again/), [4](https://gist.github.com/Komzpa/994d5aaf340067ccec0e)
-   [Otro artículo sobre el uso de pg_upgrade](https://www.bostongis.com/blog/index.php?/archives/273-Using-pg_upgrade-to-upgrade-PostgreSQL-9.3-PostGIS-2.1-to-PostgreSQL-11-2.5-on-Yum.html)
-   Un [hilo de discusión](https://lists.osgeo.org/pipermail/postgis-devel/2017-September/026364.html) sobre los pros y contras de que la librería compartida incluya el número de versión en el nombre.
-   [Como actualizar a versiones en desarrollo](https://www.bostongis.com/blog/index.php?/archives/190-How-to-Use-PostGIS-Extensions-to-upgrade-to-non-released-PostGIS-versions.html)
-   [Algunos consejos si se está en la 1.5](https://www.bostongis.com/blog/index.php?/archives/187-How-to-upgrade-your-database-to-PostGIS-2.0-let-me-count-the-ways.html)

## Consideraciones posteriores

-   Tras actualizar hay una serie de operaciones que se pueden realizar como [cargar en memoria algunos datos](https://www.postgresql.org/docs/11/pgprewarm.html). Y especialmente "analizar" el nuevo clúster. [Si se usa pg_upgrade](https://www.postgresql.org/docs/11/pgprewarm.html) ya genera los scripts adecuados. En algunos casos [este script puede no ser lo óptimo](https://www.endpoint.com/blog/2016/12/07/postgres-statistics-and-pain-of-analyze). En caso de tener que hacerlo a mano:

```shell
# En >=9.4
vacuumdb --all --analyze-in-stages

# En <9.4.
vacuumdb --all --analyze-only

# Dado que estaremos creando nuevas bases de datos no tendremos tuplas muertas
# y no será necesario un `vacuumdb --all --full --analyze`

# Si fuera necesario reindexar. Si las bd no son muy grandes se puede hacer por sistema
reindexdb --all
```

-   Cambiar los puertos, y la configuración para que sólo arranque el nuevo clúster por defecto.

-   Eliminar el clúster viejo cuando la instalación haya sido probada. Esto implica [eliminar los binarios](https://stackoverflow.com/questions/2748607/how-to-thoroughly-purge-and-reinstall-postgresql-on-ubuntu) y [borrar de disco](https://serverfault.com/questions/394257/i-think-i-have-multiple-postgresql-servers-installed-how-do-i-identify-and-dele) logs, datos, configuraciones, ...

```shell
apt-get purge postgresql-${OLD_PG_VERSION}
rm -rf /var/lib/postgresq/${OLD_PG_VERSION}
rm -rf /etc/postgresql/${OLD_PG_VERSION}
rm /var/log/postgresql/postgresql-${OLD_PG_VERSION}-main.log*
```

## Recomendaciones y guía de trabajo

En iCarto, dado que la mayoría de nuestros clusters usan PostGIS, encontramos que la opción más directa y segura cuando actualizamos el servidor es usar un dump y restaurar mediante el script proporcionado por PostGIS.

En el fichero `postgresql_actualizar_postgresql_postgis.sh` proporcionamos un ejemplo de secuencia de actualización. Está hecho para usarse como guía, no como script a ejecutar.
