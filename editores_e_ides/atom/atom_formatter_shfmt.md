# Atom - Formatter - shfmt

_(Actualizado a Octubre/2019. format-shell v0.2.16)_

Hay varios plugins de [shfmt](https://github.com/mvdan/sh) para Atom. Los más conocidos serían:

-   [format-shell](https://atom.io/packages/format-shell). El recomendado.

-   [atom-beautify](https://github.com/Glavin001/atom-beautify). Intenta ser el plugin para aunar todos los formatters para Atom. El mantenedor principal [está trabajando en una versión disinta](https://unibeautify.com/) por lo que ya apenas tiene mantenimiento. Es útil si no se quieren instalar muchos plugins. Por desgracia es fácil que un determinado formatter tenga bugs no resueltos, y el intentar aunarlos a todos introduce otros problemas. En nuestra experiencia suele ser mejor usar plugins concretos para el formatter que interese.

## Atom Format Shell

[format-shell](https://atom.io/packages/format-shell) se instala de la forma normal y requiere instalar `shfmt` a parte. La ruta al ejecutable se puede indicar en la configuración de Atom, por defecto asume que está en el PATH, que es lo recomendado según lo indicado en formatters_bash.md

Es necesario especificar las opciones de shfmt en las opciones de configuración del plugin para Atom:

```
"format-shell":
  binary: true
  formatOnSave: true
  indent: 4
  indentSwitch: true
  spaceAfterRedirect: true
```

Se puede lanzar desde la paleta con: `format-shell:format`
