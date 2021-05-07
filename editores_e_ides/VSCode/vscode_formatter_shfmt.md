# VSCode - Formatter - shfmt

El plugin a usar para formatear shell scripts en VSCode con shfmt es:

-   [shell-format](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format)

Justo después de instalarlo debe entrarse en la configuración del plugin e indicar la ruta al ejecutable. Si no se hace a sí descargará la última versión y lo instalará dentro de la extensión de VSCode. Hay [un bug abierto](https://github.com/foxundermoon/vs-shell-format/issues/46) al respecto que debe consultarse

Es preferible especificar la ruta para que todo coincida con los cambios que se hagan con pre-commit. Ver `formatters_bash.md`

Para configurarlo, tras instalar el plugin y asumiendo que `shfmt` está en path, añadir a `settings.json`:

```
"shellformat.path": "shfmt",
    "shellformat.flag": "-i 4 -bn -sr -ci",
    "shellformat.effectLanguages": [
        "shellscript"
    ]
```

Esta extensión permite formatear otros ficheros como Dockerfiles. Se puede configurar en `effectLanguages`
