# EditorConfig

Una utilidad un poco particular para unificar el estilo de código de un proyecto es [EditorConfig](http://editorconfig.org/)

> EditorConfig helps developers define and maintain consistent coding
> styles between different editors and IDEs. The EditorConfig project
> consists of a file format for defining coding styles and a
> collection of text editor plugins that enable editors to read the
> file format and adhere to defined styles. EditorConfig files are
> easily readable and they work nicely with version control systems.

No es una herramienta de análisis estático, ni un formateador, si no más bien un "estándar" de configuración que los IDEs u otras herramientas pueden usar para compartir ciertos settings en un proyecto, en lugar de los que haya fijado el usuario en su propia configuración. De este modo aunque se usen distintos IDEs en el equipo se puede forzar en parte un estilo uniforme de [forma automática para cada proyecto](http://treyhunner.com/2012/02/editorconfig/).

## EditorConfig y Editores

Lo más habitual es usar EditorConfig a través de un plugin para el editor que evite ir configurando para cada cosa aspectos básicos como el "encoding" o los "trailing spaces". La implementación concreta de EditorConfig en un editor debe ser revisada, dado que no todos soportan todas las funcionalidades esperadas, y algunos pueden dar alguna sorpresa.

-   Ver atom_editor_config.md
-   Ver pycharma_editor_config.md
-   Ver emacs_editor_config.md

## Herramientas adicionales

### eclint

[eclint](https://github.com/jedmao/eclint) es una herramienta específica para trabajar con EditorConfig. Permite:

-   Inferir una configuración a partir de los ficheros de un proyecto
-   Chequear si los ficheros se adhieren a las reglas de EditorConfig
-   Corrige algunos errores, como añadir o quitar el `BOM`, convertir los `end_of_line`, quitar los trailing whitespaces, ...

La forma recomendada de lanzar eclint contra un repo git (al contrario de lo que indica la documentación) sería:

    git ls-files -z | xargs -0 npx eclint check

La forma preferida de instalarla sería a través de la configuración del package.json.

    npm install eclint --save-dev --save-exact

`eclint` es una herramienta algo problemática porque es difícil ignorar patrones, y en las pruebas realizadas ignorar algunos chequeos `npx eclint check --indent_size unset` tampoco ha funcionado correctamente.

### Plugins para otras herramientas

Hay plugins para acoplar EditorConfig a otras herramientas como eslint, ...

## EditorConfig vs Linters, Formatters y Editores

-   Muchas de las herramientas de formateo y linting ya incluyen las opciones (¿todas?) de EditorConfig. Como [el propio mantenedor comenta](https://github.com/jedmao/eclint/issues/43), eclint no interpreta el lenguaje en que esté escrito el fichero, por lo tanto sus capacidades de linting o formateo son muy limitadas, y se limitan a generalidades como las ya mencionadas: encoding, una línea vacía al final del fichero, ...
-   En el momento en que hemos hecho las pruebas la integración de EditorConfig con algunos editores con los que hemos probado (Atom, Emacs) no acaba de ser del todo satisfactoria. Y es fácil [que acabe liándose](https://github.com/Glavin001/atom-beautify/issues/533) con la presencia de otros plugins.
-   GitHub [lo usa](https://github.com/editorconfig/editorconfig.github.com/pull/48)

Así que, cuales serían las razones para usarlo. O como sería la forma ideal de usarlo es algo que debe decidir cada equipo. Como reflexión:

-   Un fichero de configuración en el repo, puede no importarte mucho o desde una visión "lean" ser un total desperdicio. A nosotros nos gusta a modo de "documentación" de los mínimos de estilo del proyecto.
-   Si ya se están usando otras herramientas, sobrecargar el editor con esta en general no será necesario.
-   Por otro lado permite de una forma sencilla configurar lo básico como el tamaño del indentado de una forma automática, sin tener que configurarla en cada editor o cada proyecto.
-   Si no hay muchos commits/PRs usar un hook para correr eclint no es demasiado desperdicio, sobre todo para validar algunos tipos de ficheros sobre los que es menos habitual hacer linting/formatting.

## Recomendación iCarto

-   Poner el .editorconfig en el repo
-   No es obligatorio pero se recomienda el uso del plugin para el editor.
-   No usamos `eclint` de forma genérica porqué tiene demasiados problemas.
-   [Nuestra configuración](https://gitlab.com/icarto/ikdb/blob/master/estilo_codigo/herramientas_scaffolder/.editorconfig)
