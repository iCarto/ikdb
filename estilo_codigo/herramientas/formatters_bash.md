# Formatters para Shell Scripts (bash)

En iCarto usamos _bash_ como shell por defecto dado que está presente en la mayoría de sistemas y consideramos útil usar los [bashims](https://mywiki.wooledge.org/Bashism). En este documento usamos "shell", "shell script" y "bash" como sinónimos.

Hay varias opciones disponibles en distinto estado de madurez:

-   [Plugin para Prettier](https://github.com/azz/prettier-plugin-bash). Está en WIP a Julio/2019. Usar [bash-parser](https://github.com/vorpaljs/bash-parser) para construir el AST con una librería JavaScript.
-   [shfmt](https://github.com/mvdan/sh). Está escrito en Go, es un parser, formatter e intérprete.
-   [beautysh](https://github.com/lovesegfault/beautysh). Escrito en Python. No genera un AST si no que se basa en expresiones regulares para identificar construcciones de bash y luego las reformatea.
-   [IntelliJ Bash Support](https://github.com/BashSupport/BashSupport). Es más que un formatter pero sólo para la plataforma de IntelliJ

# shfmt

[shfmt](https://github.com/mvdan/sh), seguramente el formatter más popular para Shell Scripts. No tienen muchas opciones de configuración apenas si usar tabuladores o espacios y cuantos pero funciona bien. Entiende la sintaxis del lenguaje por eso es bastante seguro de usar.

El resultado es bastante satisfactorio.

Para probarlo lo más sencillo es usar una imagen de docker:

    docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt --version
    docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt --help

    # El último parámetro debe ser el path desde $(pwd) a los scripts. Si es un directorio se tratará de forma recursiva.
    docker run --rm -it -v "$(pwd)":/scripts -w /scripts peterdavehello/shfmt:latest shfmt -l -w -i 4 -bn -sr -ci .

-   La opción `-mn` elimina todas las líneas en blanco, comentarios, etc... No parece útil salvo casos excepcionales.
-   La opción `-s` "trata" de simplificar el código, eliminando comillas donde no parecen estrictamente necesarias, y otras operaciones que pueden ser consideradas como peligrosas, y con las que _shellcheck_ dará error. Mejor no usarla. 
-   La opción `-kp` no acabo de entenderla pero genera resultados que no me cuadran.

Tiene plugin propio para [Atom](https://github.com/focusaurus/atom-format-shell) y [VS Code](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format). Hay al menos dos repos que dan soporte para pre-commit [1](https://github.com/syntaqx/git-hooks), [2](https://github.com/jumanjihouse/pre-commit-hooks) pero para ambos es necesario tener _shfmt_ en el path. No parece haber soporte para Emacs.

**Algunos problemas**

-   No hay [opción directa para ignorar ciertos ficheros](https://github.com/mvdan/sh/issues/288) por ejemplo node_modules. Sobre todo usando el docker el comando se convierte en un churro muy complicado de leer.


    shfmt -l -w -i 4 -bn -sr -ci $(shfmt -f . | grep -v node_modules/)

-   Si _Go_ no está en tus lenguajes habituales instalar y mantener actualizado _shfmt_ y _Go_ puede ser bastante incómodo. Para un uso ocasional _docker_ es la mejor solución. Para su uso sólo en _pre-commit_ se puede usar `language: golang` y dejar que \_pre-commit\` construya el ejecutable. Si se va a usar de forma más intensa las mejores opciones son [usar snap](https://snapcraft.io/shfmt) o descargar el binario de la [página de releases](https://github.com/mvdan/sh/releases) y ponerlo en el path.

# beautysh

[beautysh](https://github.com/lovesegfault/beautysh) es un programa en Python que usa expresiones regulares para reformatear código bash.

Hace menos formato que _shftm_, por ejemplo:

-   no transforma backticks a $()
-   O respeta una línea donde `do` esté en una línea distinta a `for`, mientras que _shftm_ lo pondrá en la misma línea

Que formato es más "limpio" es muy opinativo, nosotros preferimos el de _shfmt_. Lo mejor de _beautysh_ es que está escrito en Python lo que simplifica su uso e instalación.

Por otro lado obliga a pasarle un parámetro files con los ficheros mientras que _shfmt_ identifica los "sheebang", las extensiones .sh, es recursivo, etc ...

    beautysh --indent-size 4 --files **/*.sh

Tiene soporte para pre-commit en el propio repo. Soporte para Atom a través de atom-beautify. Para [VS Code](https://marketplace.visualstudio.com/items?itemName=shakram02.bash-beautify) algo desactualizado. No parece haber soporte para Emacs.

# Herramientas descartadas o con poco mantenimiento

-   [beautify_bash](https://github.com/ewiger/beautify_bash), [bashbeautify](https://github.com/bergwerf/bashbeautify)

# Configuración iCarto

En iCarto usamos _shfmt_ con las opciones: `-w -l -i 4 -bn -sr -ci`. Se lanza en _pre-commit_ en un hook local. El ejecutable lo mantiene cada persona del equipo como quiere pero la recomendación es descargar el binario y poner el `$HOME/bin/shfmt`

Incluimos un script en `package.json` con como se ejecutaría para todo el repositorio: `npm run-script pretty:bash`

```json
"scripts": {
    "pretty:bash": "shfmt -l -w -i 4 -bn -sr -ci $(shfmt -f . | grep -v node_modules/)",
},
```

Cada persona del equipo decide si usa un plugin para el editor o no.
