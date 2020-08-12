# Formatters para HTML y Templates

Para el formateado de HTML o templates basados en HTML no hay tantas opciones como para otros lenguajes. Las principales librerías para formatear JavaScript (ver formatters_javascript.md) también funcionan con HTML puro, pero suelen tener problemas parseando templates de Mako, Django/Jinja2/Nunjucks, ...

Las principales son:

-   [Tidy](http://www.html-tidy.org/). Complicado de usar e instalar.

-   [Prettier](https://github.com/prettier/prettier)

-   [JS Beautifier](https://github.com/beautify-web/js-beautify).

-   [Pretty Diff](https://github.com/prettydiff/prettydiff).

-   [eslint](https://eslint.org/) y derivados. No son verdaderos formatters. Son linters, capaces de corregir algunos errores como quitar espacios finales o insertar punto y coma.

# Prettier

Tiende a romper demasiado las líneas. Por ejemplo un

```html
<tr>
    <td>foo</td>
    <td>bar</td>
</tr>
```

acaba en

```html
<tr>
    <td>
        foo
    </td>
    <td>
        bar
    </td>
</tr>
```

Soporta Vue, pero a junio/2019 hay problemas con lenguajes de plantillas:

-   Mako. No lo soporta.
-   Jinja2 / Django. No suele dar errores de parseo, pero la salida es problemática. Por ejemplo agrupa en la misma línea tags de la plantilla que deberían estar en líneas separadas.
-   Underscore. Templates de Underscore dentro de etiquetas `<script>` son formateados correctamente

Otro detalle a tener en cuenta es que el HTML debe ser correcto para que lo formatee, por lo que conviene pasarle un linter primero. Y no permite hacer "workarounds".

Indenta los tags de body y head, lo que ya te hace perder un montón de espacio. El setting de `htmlWhitespaceSensitivity: "css"` es por seguridad pero [el resultado queda rarísimo](https://prettier.io/blog/2018/11/07/1.15.0.html#whitespace-sensitive-formatting)
,

Algunas referencias a seguir:

-   <https://github.com/robertquitt/prettier-plugin-djangohtml>
-   <https://github.com/justrhysism/prettier-plugin-nunjucks>. Prometedor pero haría falta tocarla para que se llevara bien con webassets, django-webpack-loader, ...
-   <https://github.com/prettier/prettier/issues/5581>
-   <https://github.com/prettier/prettier/issues/5754>

# PrettyDiff

Lo bueno de PrettyDiff es que funciona aceptablemente con Jinja2/Django y al menos no rompe con Mako, Lo malo es lo comentado en formatters_javascript.md

-   <https://github.com/Glavin001/atom-beautify/issues/321>
-   <https://github.com/prettydiff/prettydiff/issues/95>

# JS Beautify

Tiene un soporte aceptable para Jinja2/Django y al menos no rompe para Mako. Pero no funciona con Vue.

-   <https://github.com/beautify-web/js-beautify/issues/477>
-   <https://github.com/beautify-web/js-beautify/issues/1110>
-   <https://github.com/beautify-web/js-beautify/pull/956>
-   <https://github.com/beautify-web/js-beautify/issues/404>
-   <https://github.com/beautify-web/js-beautify/issues/993>
-   <https://github.com/Glavin001/atom-beautify/issues/418>
-   <https://stackoverflow.com/questions/42170561/vscode-html-autoformat-on-django-template>

**Algunas notas**

-   No tiene soporte para ignorar o incluir ficheros más allá de los que se le pasan por la consola.

Hay que jugar un poco con las opciones para obtener buenos resultados

-   Para Jinja2 la opción de `templating` a "auto" y a "django" dan el mismo resultado y es el que mejor queda.
-   Para Mako con "auto" no queda mal del todo. Pero la lía un poco con "assets". El de "django" parece quedar mejor. Pero también tiene algún problema.
-   brace-style no afecta a html
-   wrap-attributes
    -   force, force-aligned y force-expand-multiline. Cada atributo en una nueva línea.
    -   aligned-multiple. Mete varios atributos en la misma línea, pero si hay que saltar intenta que estén alineados con la anterior. Queda raro.

```bash
npm install js-beautify
npx html-beautify path-to-templates/**/*.jinja2
```

# Herramientas descartadas o con poco mantenimiento

-   <https://github.com/threedaymonk/htmlbeautifier>
-   <https://github.com/johnotander/prettify-html>
-   <https://github.com/berniey/html5print>. Python.
-   <https://github.com/juancarlospaco/css-html-prettify>. Python.

# Conclusiones

Ninguna de las herramientas probadas es perfecta.

_Prettier_ ocupa demasiado espacio vertical para los que estamos acostumbrados a escribir un html regulero. Y su soporte de los templates no es bueno. _JS Beautify_ hace un trabajo mejor con los templates y ocupa menos espacio vertical. La posibilidad de no indentar body y head también ahorra espacio horizontal.

En iCarto no forzamos el uso de ningún formateador para html o derivados en este momento. Queda a discreción de cada persona del equipo si pasar con cierto criterio y corrección manual un formateador de vez en cuando, recomendado _JS Beautify_ para templates de Python y _Prettier_ para html puro y Vue.

Eso sí, incluimos ambas herramientas en el `package.json` con sus correspondientes ficheros de configuración.
