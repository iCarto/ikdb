# Atom - Formatter - Prettier

_(Actualizado a Octubre/2019. prettier-atom v0.57.2)_

Hay varios plugins de [Prettier](https://github.com/prettier/prettier) para Atom. Los más conocidos serían:

-   [atom-mprettier](https://github.com/t9md/atom-mprettier) y [atom-miniprettier](https://github.com/duailibe/atom-miniprettier). Dos plugins muy similares cuyo objetivo es la sencillez y no añadir mucho peso a Atom. No se actulizan desde 2018 así que no los hemos probado.

-   [atom-beautify](https://github.com/Glavin001/atom-beautify). Intenta ser el plugin para aunar todos los formatters para Atom. El mantenedor principal [está trabajando en una versión disinta](https://unibeautify.com/) por lo que ya apenas tiene mantenimiento. Es útil si no se quieren instalar muchos plugins. Por desgracia es fácil que un determinado formatter tenga bugs no resueltos, y el intentar aunarlos a todos introduce otros problemas. En nuestra experiencia suele ser mejor usar plugins concretos para el formatter que interese.

-   [prettier-atom](https://github.com/prettier/prettier-atom). Es un plugin mantenido bajo el propio paraguas de Prettier. Cumple su cometido y es el recomendable a usar.

## Prettier for Atom

[prettier-atom](https://atom.io/packages/prettier-atom) se instala de la forma normal y permite usar una versión de Prettier que viene con el propio plugin o delegar en la instalada, que es lo recomendable.

Tiene integración con stylelint y eslint.

En general funciona sin problemas usando una configuración como la propuesta en iCarto:

-   Especificar versión de Prettier en `package.json` e instalado en local
-   Fichero de configuración `prettier.config.js` en la raíz del repo
-   Abrir Atom con `atom .` desde la raíz del repo y dentro de un entorno virtual de Python

Hay dos detalles a tener en cuenta para evitar sorpresas:

-   Cuando hay un error sintáctico que no permita construir el AST el plugin simplemente no reformatea, pero no muestra ningún error ni aviso.
-   Siempre respeta `.prettierignore` si un fichero está ahí no lo formatera automática, ni manualmente.

Nuestra configuración con explicaciones:

```
"prettier-atom":
formatOnSaveOptions:
  enabled: true  // Generalmente es lo deseado
  excludedGlobs: [] // Configurarlo a nivel editor es molesto y peligroso (ficheros que cambian entre proyectos)
  // Sólo usamos Prettier para ciertos ficheros. Somos explicitos sobre los tipos de ficheros para format-on-save y delegamos en otras herramientas o hacerlo a mano para otros casos.
  // No queremos por ejemplo que formatee un .html que en realidad es un template de Jinja2. Ver formatters_html.md, formatters_css.md, ...
  // Este punto está bajo discusión
  whitelistedGlobs: [
        "*.js"
        "*.{md"
        "yml"
        "yaml"
        "json}"
      ]
  isDisabledIfNoConfigFile: true  // Si no es nuestra configuración y nuestra versión no lo hacemos automático. Se puede lanzar a mano

  // Parece buena idea ponerlo a true, de modo que si no es nuestra configuración y nuestra versiónno formatee automático
  // Pero en una estructura tipo project/package.json (con cosas generales) y project/web/package.json con especificas y
  // sin prettier no funcionaría. Con dejar el de la configuración es suficiente
  isDisabledIfNotInPackageJson: false

  showInStatusBar: true  // Para que sea fácil de deshabilitar si no se quiere para un determinado fichero
  respectEslintignore: false  // No usamos ficheros de ignore específicos para herramientas
  ignoreNodeModules: false
useEslint: false  // Bajo discusión
useStylelint: false  // Bajo discusión
```
