# TODO

A medida que probamos las herramientas, descubrimos nuevas lecturas y escribimos esta guía, encontramos temas que no podemos o no queremos abordar todavía. En esta sección los listamos, para poder iniciar investigaciones futuras y como referencia de temas que no estamos gestionando a nivel equipo.

## Lista corta

-   [ ] Probar las configuraciones de pre-commit
-   [ ] Valorar script de bandit en package.json
-   [ ] Valorar mezclar distintos comportamientos en los scripts de package.json. Por ejemplo bandit+flake
-   [ ] Reorganizar carpetas. A que nivel hablar de "estilo_codigo", "linters", "herramientas_scaffolders", ...
-   [ ] Método estándar para lanzar las herramientas de formateado y lint. En `package.json`, `make`, `scripts to rule then all`, ...
-   [x] linters de bash
-   [ ] linters de python "genéricos"
-   [ ] linters o métricas de complejidad, ... de python, tipo mcabe
-   [ ] linters sql
-   [ ] linters de markdown
-   [ ] linters de "prosa" en castellano: ortografía, gramática, ...

## Comunes

-   Queda pendiente fijar recomendaciones sobre el uso de plugins para editores, discusiones como pre-commit vs IDE
-   Como actualizar las herramientas y sus configuraciones. Con que periodicidad. Como mantener los proyectos actualizados. ¿nitpick?
-   Todo lo que pase cuando el código abandona el ordenador en que se desarrolla. O dicho de otra forma lo que pasa tras un `push`. Integración con servicios de CI/CD y similares, Code Review, que hacer si una de estas herramientas rompe el `build`

## Linters

-   linters de java
-   linters de frontend: javascript, css, html
-   linters de ficheros de configuración y otras cosas: mensajes de commit, expresiones regulares, json, geojson, yaml, toml, ini, docker...
-   linters y herramientas relacionadas de seguridad: salvo casos bastante concretos
-   linters de python referidos a tipado estático
-   Deberían usarse configuraciones distintas en el IDE y en pre-commit. Es algo que aumenta la complejidad pero si se tiene un formatter cual es el sentido de que el IDE nos marque que estamos dejando dos líneas en blanco en lugar de una. De hecho, es necesario tener esa valicación en las reglas del linter.

## Formatters

-   Tiene sentido ordenar los `import` en JavaScript. Y que herramientas pueden usarse. https://github.com/renke/import-sort https://eslint.org/docs/rules/sort-imports
-   Debemos usar 2 o 4 espacios para indentar html. El máximo de línea debería ser 88, 100, 119?. La configuración actual está en 2/100
-   No hay configurado formateo automático para html/jinja2/mako. Ver formatters_html. Para html puro se podría usar js-beautify o prettier
    -   prettier no vale para mako ni django/jinja a día de hoy
    -   js-beautify no vale para Vue
    -   Prettier indenta body y head lo cual es un poco de desperdicio
    -   En principio lo mejor sería usar prettier lo máximo posible. De este modo sería js-beautify cuando haya templating python en el servidor, hasta que haya un plugin para prettier que funcione. Y prettier para lo demás, html puro y vue
    -   Formatear html, bien, es complicado y ningún resultado convence. Decidir si dejarlo así, o como mejorar este punto
-   No se ha fijado ninguna herramienta para .sql aunque hay candidatos. Hay que probar distintos workflows antes de recomendar uno
-   java
