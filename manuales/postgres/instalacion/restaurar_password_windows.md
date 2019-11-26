# Restaurar password del usuarios postgres en Windows

Cuando se instala PostgreSQL en Windows a través de los instaladores habituales se pregunta que clave se quiere usar para el usuario `postgres`. En instalaciones en local que no vayan a estar conectadas hacia el exterior es habitual usar una clave genérica e insegura como `postgres`.

Si se ha usado una clave distinta y no se recuerda cual es hay varias opciones para restaurarla. Probablemente lo más sencillo es modificar [el fichero de configuración `pg_hba.conf`](https://www.postgresql.org/docs/9.1/auth-pg-hba-conf.html)

# Modificar pg_hba.conf

El fichero `pg_hba.conf` es un fichero de configuración de PostgreSQL que especifica distintas opciones de conexión al servidor.

Este fichero tendrá habitualmente, entre otras, un par de líneas como estas:

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
```

Los valores `md5` bajo la columna `METHOD` vienen a indicar que para las conexiones a través de un puerto en localhost se use contraseña. Una opción de restaurar la contraseña es indicar a través de este fichero que no es necesaria introducir la contraseña si no que cualquier usuario pueda conectar de forma automática.

Para ello, **primero localizamos el fichero `pg_hba.conf`**, generalmente estará en el subdirectorio `data` de la instalación de PostgreSQL que por defecto está en una ruta como la siguiente:

```
C:\Program Files\PostgreSQL\VERSION\data
```

Donde `VERSION` será el número de versión de PostgreSQL instalada. Por ejemplo si la versión instalada es la 10:

```
C:\Program Files\PostgreSQL\10\data
```

Si tenemos varias versiones instaladas debemos modificar el de aquel _cluster_ del que hayamos perdido la contraseña.

En segundo lugar, por precaución **hacemos una copia de seguridad del fichero**, para poder volver al estado original si se corrompe. Llega con copiarlo y pegarlo a otra localización. Esta copia podemos eliminarla al final del proceso si todo ha ido bien.

A continuación llevamos a cabo el cambio en sí, que permite el acceso sin contraseña. Eso se hace **editando el fichero para cambiar los `md5` por `trust`** quedando del siguiente modo:

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```

A continuación debemos **reiniciar el servidor de PostgreSQL** (o recargar la configuración `pg_ctl reload`), o en su defecto reiniciar el computador. Tras ello podremos conectar al servidor sin introducir la clave.

En este punto podemos **modificar la clave de PostgreSQL** lanzando la siguiente sentencia al servidor:

```
ALTER USER postgres WITH PASSWORD 'postgres';
```

Donde en lugar de `'postgres'` podemos usar otra clave.

Aunque se trate de un servidor local es recomendable **devolver el fichero `pg_hba.conf` a su estado original**, volviendo a cambiar los `trust` por `md5` y de nuevo reiniciar para comprobar que el _reset_ del password funciona.
