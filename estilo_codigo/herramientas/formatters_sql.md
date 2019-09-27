# Formatters para SQL (PostgreSQL)

SQL es seguramente uno de los lenguajes más difíciles de formatear, porqué es difícil encontrar un estilo que convenza a uno mismo y el lenguaje es muy flexible.

# pgFormatter

[pgFormatter](https://github.com/darold/pgFormatter) un programa escrito en Perl por un contribuidor de PostgreSQL. Probablemente uno de los que más tracción tiene.

Algo que no me gusta es que alinea los JOIN con el FROM, en lugar de indentarlos

Está actualizado en el [repositorio de PostgreSQL para Ubuntu](https://www.postgresql.org/download/linux/ubuntu/), así que se puede instalar con apt `sudo apt-get install pgformatter`

-   `-m` No usar. Directamente elimina de la query lo caracteres que pasen de esa longitud.
-   `-b` para usar el formato de coma al principio
-   `-u2` Poner en mayúsculas las palabras reservadas (`SELECT`, `CREATE FUNCTION`, ...)
-   `-f2` Poner en mayúsculas las llamadas a funciones (`COALESCE`, `SUBSTRING`, ...
-   `-B` para que en los inserts rompa distintos grupos de values en nuevas líneas
-   `-g` deja una línea en blanco entre sentencias cuando están dentro de una transacción
-   `-t` para algunas sentencias usa un formato alternativo

```
echo "INSERT INTO myschema.mytable (foo, bar) VALUES ('a', 1), ('b', 2);" | pg_format -B -b
INSERT INTO myschema.mytable (foo
    , bar)
    VALUES ('a'
        , 1)
    , ('b'
        , 2);

echo "INSERT INTO myschema.mytable (foo, bar) VALUES ('a', 1), ('b', 2);" | pg_format -b
INSERT INTO myschema.mytable (foo , bar)
    VALUES ('a' , 1) , ('b' , 2);
```

-   `-W` Especifica en términos absolutos el número de columnas de una lista que deben mostrarse juntas. Es útil para compactar el código y no poner cada columna en una línea independiente.

```
echo -e "INSERT INTO myschema.mytable (foo, bar) VALUES ('a', 1), ('b', 2), ('c', 3);\n\nSELECT one, two, three FROM foo.bar;" | pg_format -W2 -B -b -u2

INSERT INTO myschema.mytable (foo , bar)
    VALUES ('a' , 1)
    , ('b' , 2)
    , ('c' , 3);

SELECT one , two
    , three
FROM foo.bar;

echo -e "INSERT INTO myschema.mytable (foo, bar) VALUES ('a', 1), ('b', 2), ('c', 3);\n\nSELECT one, two, three FROM foo.bar;" | pg_format -W3 -B -b -u2

INSERT INTO myschema.mytable (foo , bar)
    VALUES ('a' , 1) , ('b'
        , 2) , ('c' , 3);

SELECT one , two , three
FROM foo.bar;
```

Las opciones base que usamos son:

    pg_format -b -B -u2 -g example.sql
    
Y jugamos con `-t`, `-W x` y `-w x` según el caso. El uso de `-f2` está bajo discusión. En general tratamos de optar por la forma que PostgreSQL usa en su documentación (minúsculas para tipos de datos, mayúsculas para "palabras reservadas", pero el nombre de funciones no es consistente, por ejemplo usa minúsculas para `substring` y mayúsculas para `COALESCE`)

-w | --wrap-limit N : wrap queries at a certain length.


Tiene plugin para VS Code. El de Atom no está actualizado.

**Algunos problemas**

-   No es capaz de hacer el reformateo del fichero "in place".
-   Sólo trabaja los ficheros de uno en uno. Formatear un repositorio completo implica un poco de scripting y probablemente no funcione con _pre-commit_.


# sqlparse

[sqlparse](https://github.com/andialbrecht/sqlparse/) es una librería Python para parsear y formatear SQL. No tiene soporte específico para PostgreSQL

Admite cambiar la capitalización de palabras reservadas, coma al principio, ...

-   `-a` y `--indent_after_first` Quedan muy raro, mejor no usarlas.

**Algunos problemas**

-   El formato de salida no está mal del todo pero [algún problema si que tiene](https://github.com/andialbrecht/sqlparse/issues/334) con subselects, `WITH`, ...
-   No es capaz de hacer el reformateo del fichero "in place".
-   Sólo trabaja los ficheros de uno en uno. Formatear un repositorio completo implica un poco de scripting y probablemente no funcione con _pre-commit_.
-   Demasiadas peticiones abiertas

No está mal, y que esté en Python es muy positivo por la facilidad de mantenimiento pero el formato de salida no acaba de convencerme. Es demasiado estricto, por ejemplo aunque una sentencia quepa en una línea claramente la corta en palabras concretas, y en otros casos líneas cortadas muy largas las junta.

    sqlformat -k upper -r --indent_width 4 --comma_first true file.sql

Hay plugin para Atom a través de atom-beautify.

Lo más positivo que tiene es que "no valida" y por tanto siempre formatea nunca arroja errores sintácticos. El problema es que no está adaptado a la sintaxis de PostgreSQL y el formato de salida no es acorde a nuestras preferencias.

# pglast

[pglast](https://github.com/lelit/pglast) es una librería Python basada en [libpg_query](https://github.com/lfittl/libpg_query) y por tanto centrada en PostgreSQL. Usa un AST. Nació por algunas issues del autor con [sqlparse](https://pypi.org/project/sqlparse/)

Convierte palabras reservadas a mayúsculas, por defecto pone la coma al principio y permite cierto control sobre cuando debe generarse una nueva línea (-m)

-   `-s` permite especificar el número de caracteres que puede tener una cadena de texto ('foobar') antes de cortarla y moverlo a otra línea. Mejor no usarlo.
-   `-m` es una especie de control del máximo número de caracteres por línea. Cuando una "lista" (las columnas del `SELECT`, o del `ORDER BY`, las condiciones del `WHERE`) entren en ese número de caracteres las pondrá en una sóla línea.
-   `-f` es para [evitar que el parser renombre](https://github.com/lelit/pglast/issues/2) algunas funciones especiales.


    pgpp -m 40 -f example.sql

**Algunos problemas**

-   [Elimina los comentarios del código](https://github.com/lelit/pglast/issues/23).
-   No es capaz de hacer el reformateo del fichero "in place".
-   Sólo trabaja los ficheros de uno en uno. Formatear un repositorio completo implica un poco de scripting y probablemente no funcione con _pre-commit_.
-   Se carga el último ';' que haya. https://github.com/lelit/pglast/issues/24
-   Da un error de parseo con variables psql `ALTER FUNCTION myschema.myfunction OWNER TO :owner;` https://github.com/lelit/pglast/issues/34
-   En general tiene un soporte limitado para muchas cosas. Por ejemplo no interpreta `REFRESH MATERIALIZED VIEW`

No está mal, y que esté en Python es muy positivo por la facilidad de mantenimiento pero el formato de salida no acaba de convencerme. Por ejemplo:

    WITH exps AS (SELECT e.gid
                       , e.exp_id

El `SELECT` debería ir en otra línea para no indentar tanto el resto de columnas seleccionadas.

Pero en general tiene demasiados pequeños problemas que a día de hoy lo hacen inusable como herramienta general.

# Herramientas descartadas o con poco mantenimiento

## sql-formatter

[sql-formatter](https://github.com/zeroturnaround/sql-formatter) es una librería JavaScript. El formato que genera en general es bastante bueno pero en este momento tiene varios problemas:

-   No tiene soporte específico para PostgreSQL
-   Sin opciones de configuración (no tiene porqué ser un problema pero ...)
-   No tiene opción para cambiar la capitalización de palabras reservadas, ni para usar coma al principio, ...
-   No tiene cli por lo que es necesario crear un wrapper script. Tampoco parece haber plugins para Editores ni configuraciones de _pre-commit_ preparadas

El mantenimiento parece irregular y con no demasiada tracción. Esto hace que sea descartada

## prettier-plugin-pg

[prettier-plugin-pg](https://github.com/benjie/prettier-plugin-pg) un plugin para _prettier_ que formatea PostgreSQL-flavour SQL. Por ahora es sólo un WIP y no hay commits desde Enero/2018

-   <https://github.com/TaoK/PoorMansTSqlFormatter>
-   <https://github.com/SethRAH/format-sql>
-   <https://github.com/jdorn/sql-formatter/>
-   <https://github.com/paetzke/format-sql>

# Configuración iCarto

Dado la dificultad de uso que tienen algunas de estas herramientas, y la casuística del SQL en iCarto no forzamos, en este momento, el uso de una herramienta específica.

Recomendamos al equipo ir probando pgFormatter para ir descartando herramientas o decidirse por una.
