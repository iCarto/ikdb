# Formatters para CSS (y derivados SCSS, Less, ...)

Los formateadores principales de JavaScript (ver formatters_javascript.md) suelen hacer un buen trabajo formateando CSS y derivados.

-   [Prettier](https://github.com/prettier/prettier)
-   [JS Beautifier](https://github.com/beautify-web/js-beautify).

Y también los hay específicos

-   [CSSComb](https://github.com/csscomb/csscomb.js)
-   [stylelint](https://github.com/stylelint/stylelint). Un linter con opción de fix.

En general cualquier de las opciones hace un trabajo decente, al menos en nuestro caso que no tenemos grandes requisitos.

A no ser que se requiera alguna funcionalidad muy concreta como la opción de re-ordenar las propiedades de CSSComb, cualquier puede ser válido. Probablemente lo mejor sea escoger una herramienta que ya se esté usando para otras tareas para ahorrar una dependencia.

# Prettier

Prettier formatea el css que se encuentre dentro de tags de `<style>` de html, ficheros css, ... pero no formatea atributos "style" dentro de una etiqueta concreta.

Es menos "agresivo" con los cambios. Por ejemplo no transformará `color: #001122` a `color: #012` mientras que el resto de herramientas sí.

# CSSComb

Una de las características más interesantes de CSSComb es que ordena las propiedades dentro de un clasificador.

Mientras que Prettier no lo hace y [probablemente nunca lo hará](https://github.com/prettier/prettier/issues/4833).

El plugin para VS Code parece actualizado. El de Emacs no. Atom tiene soporte a través de atom-beautify. No parece haber creado una configuración para _pre-commit_ directamente.

# stylelint

Un linter, que hace un trabajo suficientemente bueno con el `--fix`. Tiene [soporte para Atom](https://github.com/AtomLinter/linter-stylelint/pull/385) tanto lint como fix. Tiene soporte para pre-commit de terceros. En Emacs y VS Code parece haber [sólo para lint](https://github.com/shinnn/vscode-stylelint/issues/270).

Tiene [un plugin para gestionar el orden de las propiedades](https://github.com/hudochenkov/stylelint-order) al estilo CSSComb que cumple bien.

Tiene tres tipos de reglas: Posibles errores, Problemas Estilísticos, Limitar Características del Lenguaje.

Tiene todas las reglas desactivadas por defecto así que siempre hace falta pasarle un fichero de configuración.

-   [stylelint-config-recommended](https://github.com/stylelint/stylelint-config-recommended). Enciende las reglas de "Posibles Errores".
-   [stylelint-config-standard](https://github.com/stylelint/stylelint-config-standard). Enciende las Reglas Estilísticas. El recomendado si se quiere formatear con stylelint.
-   [Reglas](https://github.com/prettier/stylelint-config-prettier) y [plugins](https://github.com/prettier/stylelint-prettier) para Prettier
-   <https://github.com/kristerkari/stylelint-config-recommended-scss>. Enciende todas las reglas.

stylelint es capaz de interpretar y corregir :

-   Etiquetas de `<style>` dentro de Vue o de HTML (sin necesidad de plugins en las últimas versiones)
-   Ficheros css
-   Atributos `style` dentro html
-   [Con un processor](https://github.com/mapbox/stylelint-processor-arbitrary-tags) se puede hacer un poco más de magia.

Algunas herramientas adicionales interesantes:

-   <https://github.com/stylelint/stylelint/issues/2532>
-   <https://github.com/alexilyaev/stylelint-find-rules>. Detecta reglas que stylelint usa y que no están en nuestro config
-   <https://github.com/mapbox/stylelint-processor-arbitrary-tags>
-   <https://github.com/stormwarning/stylelint-config-recess-order>

## Instalación y configuración

    npm install --save-dev --save-exact stylelint stylelint-order stylelint-config-standard

**Algunos problemas**

-   Los plugins y reglas para Prettier no están mal, pero si quieres corregir dentro de templates de Jinja2 o atributos es mejor usar el propio stylelint y configurarlo de un modo similar a Prettier.
-   En un repositorio grande conviene revisar las opciones de `--cache` y `--cache-location`. Nuestra intención es correrlo con _pre-commit_ por lo que no nos hace falta ahora.
-   En general estás herramientas usan sus propias librerías para interpretar los `globs` por lo que deben ir siempre entrecomillados en la línea de comandos.
-   Las herramientas presentan distintas formas a nivel configuración y cli de como incluir y excluir ficheros y patrones. La diferencia de tiempos de ejecución es notable ajustando bien estos parámetros, que no es sencillo. Y suele haber bugs.
-   Dado que la mayoría suelen presentar la opción de pasarle por cli o configuración el path a un fichero que contiene patrones al estilo `gitignore`, nosotros acostumbramos tener un fichero genérico `.ignore` que se le pasa a todas las herramientas. En este fichero incluimos los patrones de `.gitignore` (hay que acordarse de actualizar ambos ficheros a la vez) y añadimos algunos casos, como librerías descargadas a mano, que acostumbramos situar en algún tipo de directorio `vendor`

```bash
# cp .gitignore .ignore
# echo "static/vendor" >> .ignore

npx stylelint --fix --ignore-path .ignore '**/*.{vue,htm,html,css,sss,less,scss,sass,mak,jinja2}'
```

-   No parece haber una forma sencilla de dinámicamente cambiar una opción en función del tipo de fichero, por ejemplo que cuando la extensión que está procesando sea `.html` use un máximo de línea de 100 en lugar de 88

Usa _cosmiconfig_ para la configuración. En iCarto tratamos de usar una configuración que de un resultado compatible con _Prettier_

```javascript
// stylelint.config.js
module.exports = {
    defaultSeverity: "error", // Valor por defecto. Útil para cambiarlo a warning rápido durante pruebas.

    plugins: ["stylelint-order"],

    extends: "stylelint-config-standard",

    rules: {
        "order/properties-alphabetical-order": true,
        indentation: [4, {baseIndentLevel: 1}],
        linebreaks: "unix",
        "max-line-length": 88,
        "no-empty-first-line": true,
        "string-quotes": ["double", {avoidEscape: true}],
        "font-family-name-quotes": "always-unless-keyword",
        "function-url-quotes": "always",
        "selector-attribute-quotes": "always",
    },

    /*
        https://stylelint.io/user-guide/configuration/#ignorefiles
        `ignorePath` and `ignorePattern` work in the cli, but not here
        https://github.com/stylelint/stylelint/issues/4126
    ignorePath: ".ignore",
    ignorePattern: [ // Ajustar en cada proyecto
	    "static/vendor",
    ],
    */
};
```

# Herramientas descartadas o con poco mantenimiento

-   <https://github.com/hideki-a/css-prettifier>
-   <https://github.com/senchalabs/cssbeautify>
-   [PrettyDiff](https://github.com/prettydiff/prettydiff).
-   [PrettyCSS](https://github.com/fidian/PrettyCSS). CSS beautifier, lint checker, validator. Poca tracción.
-   [Sass Lint Auto Fix](https://github.com/srowhani/sass-lint-auto-fix). Un complemento para Sass Lint que corrige algunos errores. No tiene mala pinta pero dado que preferimos stylelint sobre Saas Lint no tiene sentido usar esto.
-   <https://github.com/morishitter/stylefmt>

# Conclusiones

No merece la pena usar _CSSComb_ si ya se va a usar _stylelint_ como herramienta de linting para evitar una dependencia.

Si se necesita configurar más o menos a medida el css que sale tanto _JS Beautifier_ como _stylelint_ son buenas opciones. Si no se necesita configuración, _Prettier_ también es una buena opción. En todo caso a nivel de resultado, cualquier de los tres es válido. Es mejor usar:

1.  _stylelint_ si consideras que ordenar las properties es una "killer feature", o formatear atributos "style".
2.  El que no suponga introducir nuevas dependencias.
3.  _Prettier_ si te vale el CSS que genera porqué tiene más tracción.

En iCarto usamos _stylelint_ . Se lanza con [pre-commit](https://pre-commit.com/) y se configuran en `stylelint.config.js`.

Incluimos un script en `package.json` con como se ejecutaría para todo el repositorio: `npm run pretty:css`

```json
"scripts": {
    "pretty:css": "npx stylelint --fix --ignore-path .ignore  '**/*.{vue,htm,html,css,sss,less,scss,sass,mak,jinja2}'"
},
```

Cada persona del equipo decide si usa un plugin para el editor o no.
