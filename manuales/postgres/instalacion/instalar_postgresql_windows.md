Instalación gráfica de PostgreSQL en Windows
============================================

Esta es una pequeña guía de como instalar y configurar un PostgreSQL en
Windows. Se recomienda encarecidamente leer la [detallada documentación
de PosgreSQL](http://www.postgresql.org/docs/9.2/static/index.html)
acerca de la administración de este tipo de bases de datos, puesto que
este documento es sólo introductorio.

Se excluye de esta guía, la información referida a cortafuegos o
antivirus, que deben ser configurados de la forma adecuada para permitir
el acceso y correcta instalación del servidor y que dependerá
enormemente de la aplicación concreta instalada en el equipo.

PostgreSQL es un servidor de bases de datos libre y gratuito. La empresa
[enterprisedb](http://www.enterprisedb.com/) provee un instalador
gráfico que incluye el servidor PostgreSQL, el cliente gráfico pgAdmin
III, y el stackbuilder, un gestor de paquetes para descargar e instalar
drivers, plugins y extensiones adicionales para PostgreSQL, inluido
Postgis, la extensión que dota de capacidades espaciales a PostgreSQL.

Para el proyecto gvSIG Fonsagua se requiere instalar la versión 9.1 de
Postgres con Postgis 1.5

Descarga del software
=====================

Si se quiere emplear el instalador proporpocionado por
[enterprisedb](http://www.enterprisedb.com/) debe tenerse en cuenta que
la versión de 64 bits para Windows incluye la versión 2.0 de Postgis en
lugar de la 1.5, por lo que debemos bajar e instalar la de 32 bits
independientemente de nuestro sistema operativo.

-   [Postgresql 9.1.9 - Windows 32
    bits](http://www.enterprisedb.com/postgresql-919-installers-win32?ls=Crossover&type=Crossover)

Proceso de instalación con stackbuilder
=======================================

-   Tras descargar el fichero de instalación lo ejecutaremos como
    administrador, abriéndose una ventana que nos dará la bienvenida al
    proceso. En esta ventana pulsaremos siguiente

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_01.jpg)

-   A continuación escogemos donde se instalará el programa. En el
    ejemplo se instala en *C:PostgreSQL91*

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_02.jpg)

-   En la siguiente ventana escogeremos donde se almacenarán la
    información de las bases de datos que gestionará el servidor. En el
    ejemplo almacenamos los datos en *C:/PostgreSQL/datos*

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_03.jpg)

-   El instalador gráfico creará una nueva cuenta de usuario y un nuevo
    servicio para windows. En esta ventana introducimos el nombre de la
    cuenta, lo habitual es emplear *postgres* y escogemos la clave. Esta
    clave será tanto la del usuario de windows, como la del superusuario
    de conexión a la base de datos.

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_04.jpg)

-   A continuación escogeremos el puerto en el que el servidor ofrecerá
    el servicio. El puerto por defecto es el 5432.

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_05.jpg)

-   En la siguiente pantalla escogemos la configuración regional, esto
    afectará al encoding de la base de datos, idioma de los mensajes,
    configuración de moneda y fechas, etc\... Si nuestra configuración
    por defecto emplea UTF8 como encoding lo recomendable es dejar esta,
    si no debemos forzar el emplear una que emplee UTF8.

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_06.jpg)

-   Antes de comenzar a instalar el programa en el disco duro, nos
    aparece una nueva pantalla de confirmación en la que pulsaremos
    siguiente:

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_07.jpg)

-   Cuando acabe de instalar los ficheros en el disco, nos dará la
    ejecución de ejecutar stackbuilder, la herramienta de actualización
    e instalación de complementos. Marcaremos ejectuar el stackbuilder y
    le damos a terminar.

![image](/images/instalar_postgresql_windows_images/instalar_postgresql_08.jpg)

-   La siguiente pantalla ya corresponde al stackbuilder. En el
    desplegable, seleccionaremos el servidor, si estamos siguiendo esta
    guía y no hemos instalado nada previamente, debería poner
    *PostgreSQL 9.1 en puerto 5432* y pulsamos en siguiente

![image](/images/instalar_postgresql_windows_images/instalar_postgis_01.png)

-   En el árbol de opciones de la siguiente pantalla buscaremos *Spatial
    Extensiones* o *Extensiones espaciales* y seleccionamos *PostGIS 1.5
    for PostgreSQL 9.1*. Pulsamos siguiente y en caso de ser necesario
    escogemos el directorio de descarga y el servidor desde el que lo
    descargaremos.

![image](/images/instalar_postgresql_windows_images/instalar_postgis_02.png)

-   Esperamos a que descargue, y la pantalla de la siguiente imagen nos
    aseguramos de que el la opción de *Skip installation* está
    desmarcada. Luego pulsamos en siguiente.

![image](/images/instalar_postgresql_windows_images/instalar_postgis_03.png)

-   Pulsamos siguiente, en la ventana que nos anuncia que vamos a
    instalar Postgis

![image](/images/instalar_postgresql_windows_images/instalar_postgis_04.png)

-   Y siguiente en la ventana que nos pregunta si queremos usar el modo
    de actualización, lo cual no es necesario en nuestro caso.

![image](/images/instalar_postgresql_windows_images/instalar_postgis_05.png)

-   Introducimos la clave del usuario postgres, y pulsamos siguiente en
    esta pantalla y también en la que salta a continuación.

![image](/images/instalar_postgresql_windows_images/instalar_postgis_06.png)

-   Al finalizar la instalación aparecerá una pantalla en la que nos
    avisa de que la finalización ha terminado de forma exitosa.
    Pulsaremos en terminar.

![image](/images/instalar_postgresql_windows_images/instalar_postgis_07.png)

Configuración del servidor de bases de datos
============================================

Acceso de usuarios a la base de datos
-------------------------------------

La configuración por defecto de PostgreSQL sólo permite conectar a la
base de datos a usuarios que estén en el mismo host
(localhost/127.0.0.1). Para permitir la conexión de usuarios desde el
exterior debemos revisar la configuración especificada en los dos
ficheros de configuración más importantes de PostgreSQL:

-   [postgresql.conf](http://www.postgresql.org.es/node/696) Gestiona la
    configuración general de PostgreSQL.
-   [pg\_hba.conf](http://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html).
    Gestiona a que bases de datos pueden acceder que usuarios y desde
    que ip.

Ambos ficheros se encuentran generalmente en la ruta:

`C:\Program Files\PostgreSQL\9.1\data`

Tenemos varias opciones para editar esos ficheros:

:   -   Directamente con un editor de textos cualquiera como WordPad
    -   *Inicio -\> Todos los programas -\> PostgreSQL -\> Ficheros de
        Configuración -\> Editar pg\_hba.conf*
    -   *pgAdmin -\> Tools -\> Server Configuration*

Para permitir las conexiones a la base de datos de usuarios que no estén
en *localhost* nos aseguramos que en el fichero *postgresql.conf* la
opción
[listen\_adresses](http://www.postgresql.org/docs/9.1/static/runtime-config-connection.html),
tiene el valor \* quedando del modo que se muestra en la siguiente
imagen (generalmente llega con descomentarla quitando el caracter \# del
principio de la línea):

![image](/images/instalar_postgresql_windows_images/configurar_postgresql_01.png)

La mayoría de opciones que afectan a los permisos de conexión a la base
de datos se configuran a través del fichero *pg\_hba.conf*. En la
documentación de Postgresql se da detalla información del [formato del
fichero
pg\_hba](http://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html)
para que lo adecuemos a nuestras necesidades. Por ejemplo para permitir
a todos los usuarios conectar a cualquier base de datos desde cualquier
ip, añadiremos al final del fichero la línea:

`host  all all 0.0.0.0/0   md5`

La *configuración recomendada* sería permitir el acceso a la base de
datos fonsagua desde cualquier ip para los usuarios que estén en el
grupo *fonsagua*. Para ello debemos incluir la siguiente línea en el
fichero:
`host     fonsagua        +fonsagua       0.0.0.0/0               md5`

Si estamos editándolo desde el pgAdmin, haremos click en la primera fila
libre e intoduciremos los datos quedando como en la siguiente imagen

![image](/images/instalar_postgresql_windows_images/configurar_postgresql_02.png)

Tras estos cambios debemos reiniciar el servicio o en caso de duda todo
el servidor. Para reiniciar el servicio en *Inicio -\> Todas las
aplicaciones -\> Postgresql -\> Restart server*

Rendimiento de la base de datos
-------------------------------

El rendimiento de la base de datos se ve enormemente afectado en función
de las opciones de configuración que empleemos. Esta configuración debe
ajustarse al equipo en el que la base de datos esté instalada. La wiki
de postgresql contiene abudante información sobre como [mejorar el
rendimiento del
servidor](http://wiki.postgresql.org/wiki/Performance_Optimization).

Logging de eventos
------------------

La configuración por defecto de postgres es bastante laxa en cuanto al
registro de los eventos (logging) que se producen en la base de datos.
El administrador de la base de datos debe buscar el equilibrio entre el
espacio consumido en disco por los logs de información, y la información
que desee obtener de estos.

Así una configuración agresiva del log que nos permite obtener gran
información del comportamiento del sistema, puede consistir en modificar
los parámetros del fichero postgresql.conf de la siguiente forma:

-   log\_destination = \'stderr\'
-   logging\_collector = on
-   log\_directory=pg\_log
-   log\_filename = postgresql-%Y-%m-%d.log
-   log\_min\_duration\_statement = 0
-   log\_checkpoints = on
-   log\_connections = on
-   log\_disconnections = on
-   log\_duration = off \#dudoso
-   log\_line\_prefix = \'%t \[%p\]: \[%l-1\] db=%d,user=%u \'
-   log\_lock\_waits = on
-   log\_statement = none
-   log\_temp\_files = 0
-   lc\_messages=\'C\'
-   log\_rotation\_age = 1d
-   log\_rotation\_size = 500MB

En caso de tener mucha actividad en nuestra base de datos este tipo de
configuración genera gran cantidad de información, por lo que debemos
borrarlos periodicamente o realizar algún tipo de estrategía de rotación
de logs. La estrategia adecuada dependerá de la configuración de la
máquina.

Además se recomienda que antes de hacer procesos de importación masivos
de datos, por ejemplo cuando se cree una base de datos nueva, se
desactive de forma temporal el log. Para ello, llegaría con poner a
**off** la opción **loggin\_collector** reiniciar el servidor, restaurar
la base de datos deseada, volver a poner a **on**, y reiniciar el
servidor de nuevo.

Crear una base de datos espacial para restaurar un dump de Fonsagua
===================================================================

Un dump de la base de datos de gvSIG Fonsagua contendrá la información
de la cartografía base, lógica y datos que necesita la aplicación para
funcionar (triggers, esquemas de datos, valores de los dominios, \...)

La creación y configuración de la base de datos debe ser adaptada al
contexto de la organización donde se desee usar la aplicación. Una
posible forma de hacerlo es la que se presenta a continuación.

Crear un usuario en la base de datos llamado fonsagua
-----------------------------------------------------

Para configurar una base de datos para fonsagua, debemos primero crear
un usuario una base de datos con soporte espacial.

Podemos hacer esto desde la herramienta pgAdmin (*Inicio -\> Todas las
aplicaciones -\> Postgres -\> pgAdmin*). Nos conectararemos como usuario
postgres a la base de datos *postgres* a través de pgAdmin

![image](/images/instalar_postgresql_windows_images/crear_usuario_01.jpg)

A continuación pinchamos con el botón derecho sobre *Login Roles*, y
escogemos *New Login Role*

![image](/images/instalar_postgresql_windows_images/crear_usuario_02.png)

Escogeremos como nombre del rol **fonsagua**, en la pestaña de
definición introduciremos la clave, en la pestaña de privilegios: \*
Marcaremos *heredar los roles* \* Desmarcaremos *superusuario* \*
Desmarcaremos *crear bases de datos* \* Desmarcaremos *crear roles*

Crear usuarios adicionales
--------------------------

Se recomienda crear usuarios adicionales para cada uno de los miembros
del equipo que vaya a trabajar en el proyecto. Podemos hacerlo por un
procedimiento similar al visto antes, o habriendo una consola SQL desde
pgAdmin como usuario postgres y escribiendo la siguiente sentencia:

`CREATE ROLE EL-NOMBRE-DE-USUARIO-QUE-QUERAMOS IN ROLE fonsagua LOGIN PASSWORD 'LA-CLAVE-QUE-QUERAMOS';`

Crear una base de datos con soporte espacial
--------------------------------------------

Una vez tengamos el usuario creado, estando conectados como usuario
postgres podemos crear una base de datos con soporte espacial, pinchando
en **Bases de datos** con el botón derecho y escogiendo **Nueva base de
datos**.

Como nombre usaremos **fonsagua**, y le asignaremos como propietario
(owner), el usuario que creamos antes, también llamado **fonsagua**. En
la pestaña de definición escogeremos como encoding, **UTF8**, y como
template, **template\_postgis**. El resto de opciones las podemos dejar
en blanco.

Esto creará una nueva base de datos

Asignar privilegios al usuario fonsagua
---------------------------------------

Antes de restaurar el dump debemos modificar el propietario de algunos
de los objetos de la base de datos que acabamos de crear. Para ello,
estando conectado con el usuario **postgres**, conectaremos a la base de
datos **fonsagua** y ejecutaremos las siguientes sentencias. Podemos
abrir la herramienta se SQL, pinchando en *Tools -\> Query Tool*

    ALTER SCHEMA public OWNER TO fonsagua;
    ALTER TABLE public.geometry_columns OWNER TO fonsagua;
    ALTER TABLE public.spatial_ref_sys OWNER TO fonsagua;
    ALTER TABLE public.geography_columns OWNER TO fonsagua;

Resturar el dump de la base de datos
------------------------------------

Hecho esto, podemos hacer la restauración efectiva del dump. Vamos a
proponer dos métodos distintos para ello, el primero y probablemente más
sencillo es mediante el plugin SQL Console de pgAdmin. Si este sistema
falla (a veces lo hace por culpa de permisos) lo intentaremos con el
segundo método propuesto, mediante el cliente de línea de comandos
psql.exe

Recordemos que tenemos una configuración de logging que recoja mucha
información probablemente sea mejor desactivarla temporalmente, antes de
proceder a restaurar el dump.

**Método 1. Plugin SQL Console de pgAdmin**

Cerraremos la sesión que tenemos con el usuario *postgres* e iniciamos
una nueva sesión en la base **fonsagua** con el usuario **fonsagua**.

A continuación abriremos una consola de comandos, desde *Plugins -\> SQL
Console* y teclearemos

`\cd c:` `\i 20130620-fonsagua-bbdd.sql`

Siendo 20130620-fonsagua-bbdd.sql el dump de la base de datos de la
aplicación que habremos copiado a la raíz del disco duro c:. Si el
fichero está en otra ubicación deberemos indicar la ruta entera.

**Método 2. Mediante psql.exe**

1.  Localizamos el directorio donde tenemos instalado postgres o
    pgadmin. Generalmente será algo como C:Program FilesPostgreSQL
2.  Abrimos una consola de windows. *Inicio-\>Todos los programas -\>
    Accesorios -\> Simbolo del sistema*
3.  Nos movemos hasta el directorio donde está instalado Postgres
    (también valdría el de pgAdmin si lo tenemos instalado por
    separado). La consola es capa de autocompletar nombres de modo que
    cuando escribamos *cd Pro* podemos darle al tabulador un par de
    veces hasta que nos rellene el nombre entero.

::

:   cd c: cd Program Files etc \...

1.  Una vez en el directorio postgres entramos al subdirectorio 9.1 y
    luego al subdirectorio bin. En una instalación normal la ruta
    completa sería más o menos:

`C:\Program Files\PostgreSQL\9.1\bin`

1.  Una vez en ese directorio ya podemos hacer uso del programa
    *psql.exe* y podemos ejecutarlo de la siguiente forma:

`psql.exe -h localhost -U fonsagua -d fonsagua -f c:\20130903-fonsagua-bbdd.sql`

La ruta al fichero de la base de datos puede ser distinta asegúrese de
que está en c:si está en otra ubicación habrá que usar la ruta a esa
ubicación.

Si no estamos en el propio servidor debemos cambiar *localhost* por la
ip que corresponda.

Referencias adicionales
=======================

-   <https://www.youtube.com/watch?v=5CnSaPON6qA>
-   <https://www.youtube.com/watch?v=HKkCymW5rR8>
-   <https://www.youtube.com/watch?v=MM9AdcsukBE>
-   <https://www.youtube.com/watch?v=w8Y3TYORgi0>
-   <http://www.ajpdsoft.com/modules.php?name=News&file=article&sid=548>
-   <http://geodatabase.net/wp/postgresql-series-part-1-installation-and-configuration/>
-   <http://revenant.ca/www/postgis/workshop/introduction.html>
