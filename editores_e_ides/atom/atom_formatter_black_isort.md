# Atom - Formatter - black & isort

_(Actualizado a Octubre/2019. prettier-atom v0.7.0)_

Hay varios plugins de black e isort para Atom. Aunque es más difícil encontrar uno que funcione a la vez para ambos formatters.

-   [atom-black](https://github.com/hauntsaninja/atom-black). Sin actualizar desde 2018.

-   [atom-beautify](https://github.com/Glavin001/atom-beautify). Intenta ser el plugin para aunar todos los formatters para Atom. El mantenedor principal [está trabajando en una versión disinta](https://unibeautify.com/) por lo que ya apenas tiene mantenimiento. Es útil si no se quieren instalar muchos plugins. Por desgracia es fácil que un determinado formatter tenga bugs no resueltos, y el intentar aunarlos a todos introduce otros problemas. En nuestra experiencia suele ser mejor usar plugins concretos para el formatter que interese. Hay [un PR abierto](https://github.com/Glavin001/atom-beautify/pull/2321) para que el formatter de black funcione a la vez que el de isort.

-   [python-black](https://atom.io/packages/python-black). El referenciado en la web de black. Tampoco está demasiado actualizado.

-   [python-isort](https://atom.io/packages/python-isort). Referenciado en la web de isort. 24,163 descargas, 41 estrellas en atom. 3 contributors, 20 estrellas, última actualización octubre de 2016 en github.

-   [atom-isort](https://atom.io/packages/atom-isort). Referenciando en la web de isort. 5.500 descargas, 5 estrellas en atom. 7 contributos, 1 estrella, septiembre 2019 en github.

-   [atom-isort-buffer](https://github.com/junzh0u/atom-isort-buffer). Sin actualizar desde 2017.

-   [python-black-isort](https://atom.io/packages/python-black-isort). Combina black e isort. El código es algo complejo y tiene muy poca tracción.

## Python Black for Atom editor

[python-black](https://atom.io/packages/python-black) se instala de la forma normal y permite especificar el path al ejecutable de `black` que debe ser instalado por separado.

Preferimos el uso de este plugin unicamente sobre otras opciones porqué:

-   El código es sencillo hace lo que tiene que hacer sin más.
-   Como la configuración que usamos de `black` es compatible con `isort` pocas veces será necesario formatear los imports, y se puede relegar directamente en `pre-commit` para ello, de modo que simplificams un poco la configuración del editor.

En general funciona sin problemas usando una configuración como la propuesta en iCarto:

-   `black` instalado dentro del entorno virtual
-   Fichero de configuración `pyproject.toml` en la raíz del repo
-   Abrir Atom con `atom .` desde la raíz del repo y dentro de un entorno virtual de Python

Nuestra configuración:

```
  "python-black":
    showErrors: "flash"
```
