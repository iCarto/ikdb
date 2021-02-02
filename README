# ikdb

ikdb son las siglas de [iCarto Knowledge Database](https://gitlab.com/icarto/ikdb).

Aquí tratamos de reflejar lo que vamos aprendiendo o aplicando y que creemos que puede ser de utilidad para otras personas y organizaciones. Es una mezcla entre:

* Un _employee handbook_
* Guías, recetas y _scripts_ de utilidad
* Análisis y soluciones técnicas detalladas
* ...

Salvo mención expresa de lo contrario la licencia será GPL v.3 o superior para el código y CC-by-sa 4.0 para el resto de contenido.

## Muy importante

Este repositorio está en constante construcción. No podemos garantizar que esté al día, que refleje nuestras prácticas actuales o que no contenga errores.

Especialmente y a pesar de estar bajo el _namespace_ de iCarto:

* La empresa no se hace responsable de lo que suceda para bien o para mal usando los scripts o textos de este repo
* La autoría de los textos corresponde a quien los escriba (_sic_), que no tiene porqué ser necesariamente personal de iCarto y que tampoco se hace responsable de las catástrofes que puedan acontencer al usarlos

## Principios y Valores

Para situar en contexto el porqué de algunas de nuestras normas debes saber por lo que nos guíamos:

* Valoramos enormemente la existencia de _rules of dumb_ y _sincronía_ entre nuestros desarrollos. Dedicar menos tiempo al _boilerplate_ nos permite dar más cariño a los problemas reales de nuestros clientes. Y en ese sentido no _optimizamos de forma prematura_. Por ejemplo sabemos como usar [el alineamiento de datos de postgres](https://www.enterprisedb.com/blog/column-storage-intervals) para reducir y el tamaño de una tabla. Pero también sabemos que en "muchos casos" de uso es sólo desperdiciar el dinero de nuestros clientes. Y sólo "optimizamos" cuando hemos medido un problema y atacado su causa principal.

* Cuando hablamos de "muchos casos" para nuestras _rules of dumb_ nos referimos a:
    + Tablas con decenas o unos pocos centenares de miles de filas
    + Bases de datos por debajo de los 10GB
    + Decenas de usuarios usando una aplicación de forma concurrente
    + Equipos de desarrollo del orden de 5 personas
