# Formatters para Shell Scripts (bash)

En iCarto usamos _bash_ como shell por defecto dado que está presente en la mayoría de sistemas y consideramos útil usar los [bashims](https://mywiki.wooledge.org/Bashism). En este documento usamos "shell", "shell script" y "bash" como sinónimos.

Para formatear bash usamos `shfmt`

# shfmt

[shfmt](https://github.com/mvdan/sh), es el formatter más popular para Shell Scripts. No tienen muchas opciones de configuración apenas si usar tabuladores o espacios y cuantos pero funciona bien. Entiende la sintaxis del lenguaje por eso es bastante seguro de usar.

El resultado es bastante satisfactorio.

Para probarlo lo más sencillo es usar una imagen de docker:

```
docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt --version
docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt --help

# El último parámetro debe ser el path desde $(pwd) a los scripts. Si es un directorio se tratará de forma recursiva.
docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt -l -w -i 4 -bn -sr -ci .
```

-   La opción `-mn` elimina todas las líneas en blanco, comentarios, etc... No parece útil salvo casos excepcionales.
-   La opción `-s` "trata" de simplificar el código, eliminando comillas donde no parecen estrictamente necesarias, y otras operaciones que pueden ser consideradas como peligrosas, y con las que _shellcheck_ dará error. Mejor no usarla.
-   La opción `-kp` no acabo de entenderla pero genera resultados que no me cuadran.
-   La opción `-fn` hace que los paréntesis de una función vayan en la siguiente línea. Cuestión de gustos.

Tiene plugins para varios editores y pre-commit.

**Algunos problemas**

-   No hay opción directa para ignorar ciertos ficheros por ejemplo node_modules, ni ficheros de configuración. Aunque a partir de la versión 3 / 3.1 se puede user EditorConfig.

    -   https://github.com/mvdan/sh/issues/288
    -   https://github.com/mvdan/sh/issues/358
    -   https://github.com/mvdan/sh/issues/393
    -   https://github.com/mvdan/sh/issues/234

-   Pero en `.editorconfig` no se puede especificar `-l`, ni `-w` así que esas opciones hay que mantenerlas en la línea de comandos o pre-commit.

-   Si _Go_ no está en tus lenguajes habituales instalar y mantener actualizado _shfmt_ y _Go_ puede ser incómodo y en los repos oficiales suele estar desactualizado. Para un uso ocasional _docker_ es buena solución. Para su uso sólo en _pre-commit_ se puede usar `language: golang` y dejar que pre-commit construya el ejecutable. Para un uso regular se puede usar snap o descargar el binario, aunque nuestra preferida es usar Nix.

# Herramientas descartadas o con poco mantenimiento

-   [beautify_bash](https://github.com/ewiger/beautify_bash), [bashbeautify](https://github.com/bergwerf/bashbeautify)
-   [Plugin para Prettier](https://github.com/azz/prettier-plugin-bash). Está en WIP a Julio/2019. Usar [bash-parser](https://github.com/vorpaljs/bash-parser) para construir el AST con una librería JavaScript.
-   [beautysh](https://github.com/lovesegfault/beautysh). Escrito en Python. No genera un AST si no que se basa en expresiones regulares para identificar construcciones de bash y luego las reformatea.
-   [IntelliJ Bash Support](https://github.com/BashSupport/BashSupport). Es más que un formatter pero sólo para la plataforma de IntelliJ

# Configuración iCarto

En iCarto usamos `shfmt`. Se lanza en _pre-commit_ en un hook local. Y cada persona decide si usa un plugin en el editor. La configuración se realiza a través de `.editorconfig`.

El binario lo gestionamos a través de los scripts de configuración del entorno.

Puedes ver la configuración e instalación en nuestro template de proyectos.

## Versión rápida

```
nix-env --install shfmt-3.7.0
shfmt -w -l -i 4 -bn -sr -ci <path>
```
