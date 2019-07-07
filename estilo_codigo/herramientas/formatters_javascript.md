# Formatters para JavaScript

Hay un montón de librerías que permiten formatear código JavaScript.

Las principales son:

-   [clang-format](https://clang.llvm.org/docs/ClangFormat.html). Demasiadas opciones y lejos de ser el más popular para JavaScript.
-   [JS Beautifier](https://github.com/beautify-web/js-beautify). A probar, html, css, ...
-   [Pretty Diff](https://github.com/prettydiff/prettydiff). Poca tracción pero dice soportar, Django, Jinja2, ...
-   [eslint](https://eslint.org/) y derivados. No son verdaderos formatters. Son linters, capaces de corregir algunos errores como quitar espacios finales o insertar punto y coma.
    -   <https://github.com/xojs/xo>
    -   <https://standardjs.com/>
-   [Prettier](https://github.com/prettier/prettier). Un formatter opinativo. De lejos la herramienta de este tipo más popular para JavaScript.


## Prettier

[Prettier](https://github.com/prettier/prettier) es el formatter más popular de JavaScript. Es opinativo con lo que hay, relativamente, pocas opciones de configuración. El resultado es bastante bueno sin necesidad de tocar nada. Y cuando queda bastante mal, generalmente es que necesite un refactor.

Una de las peores cosas es que rompe las líneas después de los operadores lógicos, y [a pesar de que hay discusión y forks](https://github.com/prettier/prettier/issues/3806) no parece que lo vayan a cambiar.

```javascript
// Lo que hace Prettier
foo &&
bar

// Lo que debería hacer
foo
&& bar
```

Se lleva bien con los editores, _pre-commit_ y los entornos de CI.

Teóricamente soporta un montón de "lenguajes" (JavaScript, CSS, JSX, Markdown, YAML, ...), frameworks (Vue, Angular, ...) y plugins para [PostgreSQL](https://github.com/benjie/prettier-plugin-pg), [TOML](https://github.com/bd82/toml-tools/tree/master/packages/prettier-plugin-toml)

### Instalación y configuración

La forma preferida de instalarla sería a través de la configuración del `package.json`.

```bash
npm install prettier --save-dev --save-exact
```

y podemos ejecutar con

```bash
npx prettier --ignore-path '.ignore' --debug-check "**/*.js"
npx prettier --ignore-path '.ignore' --write "**/*.js"
```

Usa _cosmiconfig_ para la configuración. En iCarto usamos

```javascript
// prettier.config.js
module.exports = {
    printWidth: 88,
    tabWidth: 4,
    useTabs: false,
    semi: true,
    singleQuote: false,
    quoteProps: "as-needed",
    trailingComma: "es5",
    bracketSpacing: false,
    arrowParens: "avoid",
    proseWrap: "preserve",

    // review https://prettier.io/blog/2018/11/07/1.15.0.html#whitespace-sensitive-formatting
    htmlWhitespaceSensitivity: "css",

    endOfLine: "lf",
};
```

Usamos la versión JavaScript de _cosmiconfig_ frente a otras opciones porqué:

-   Permite poner comentarios
-   Puede ser linteada y formateada
-   Al final es JavaScript, por lo que te permite workarounds en caso de necesitarlos. Como cambiar configuraciones en función de variables de entorno.

Y usamos [npx porque es lo recomendado](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b).

# PrettyDiff

PrettyDiff es más que un formatter. Hace diff, minimifica, formatea, ...

Tiene poca tracción y pocos contribuidores (7 en este momento). La documentación no está demasiado bien. , no parece tener un `--write`, o `--in-place`, ...

No tiene una sección sobre la integración con editores, _pre-commit_, ...

Las posibilidades que parece tener para formatear correctamente html para lenguajes de plantillas Django/Jinja2, hace que se le pueda dar una oportunidad en este sentido si no hay otra opción. Pero el resto de cosas lo descarta para JavaScript y CSS porqué hay opciones claramente mejores.

# JS Beautify

Más tracción que PrettyDiff. Menos que Prettier.

Tiene bastantes opciones de configuración. No funciona con Vue. No corrige comillas. Después de jugar un poco con las opciones el resultado de Prettier parece en general mejor.

Integración con al menos Atom y VS Code. Hay un pre-commit [no listado](https://github.com/scottybarr/pre-commit-js-beautify) en la web oficial y desactualizado.

En la misma base de código JS Beautify tardó 16s, mientras que Prettier tardó un minuto. En otro proyecto más pequeño JS Beautify tardó 0.5s frente a 2s de Prettier.

# Herramientas descartadas o con poco mantenimiento

-   <https://github.com/jshint/fixmyjs>
-   <https://github.com/millermedeiros/esformatter>
-   <https://github.com/tests-always-included/pretty-js>

# Configuración iCarto

En iCarto usamos Prettier. Se lanza con [pre-commit](https://pre-commit.com/) y se configuran en `prettier.config.js`.

Incluimos un script en `package.json` con como se ejecutaría para todo el repositorio: `npm run-script pretty:js`

```json
"scripts": {
    "pretty:js": "npx prettier --ignore-path '.ignore' --write '**/*.js'",
    "pretty:others": "npx prettier --ignore-path '.ignore' --write '**/*.{md,yml,yaml,json}'"
},
```

Cada persona del equipo decide si usa un plugin para el editor o no.
