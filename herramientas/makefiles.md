# Makefiles

[make](<https://en.wikipedia.org/wiki/Make_(software)>) es una utilidad para la construcción automática de software (_build automation tool_). Nació en el mundo de C para facilitar la compilación de los programas pero en la actualidad muchos proyectos la usan como una herramienta generalista de automatización: preparar el entorno, ejecutar tests, construir el software (sea JavaScript, C, ...), arrancar servicios, ...

Es decir se usa `make` como _interfaz_ única para las distintas tareas del proyecto independientemente del lenguaje de programación, u otros aspectos. Por ejemplo en un proyecto cualquiera `make test` llamará al _test runner_ que corresponda sea `pytest`, `jest`, ... o todos los _test runners_ del proyecto.

Esta es su gran ventaja. Una forma estandarizada de trabajar independientemente del lenguaje, entorno, ... de modo que disminuye la cantidad de herramientas o comandos que quien desarrolle necesita conocer (más allá de quien prepare los _Makefile_)

## Problemas

-   El mayor problema, es que `make` no está diseñado para esto, así que implementar algunas tareas puede ser complicado.
-   Tiene que haber alguien en el equipo que conozca la herramienta, y a día de hoy esto no es habitual. Así que exige un conocimiento a mayores difícil de aprovechar para otras tareas.
-   Es fácil caer en la tentación de intentar escribir un `Makefile` cómo si fuera `bash`, y son distintos. Escribir buenos `Makefile` es difícil. Acabas separando el principal en distintos ficheros que acaban llamando a scripts. Así que al final no es muy distinto a usar scripts directamente.

## iCarto

En el caso de iCarto hemos optado por prescindir de los `Makefile`.

En su lugar nos basamos en ["Scripts to Rule Them All"](https://github.blog/2015-06-30-scripts-to-rule-them-all/). Qué básicamente consiste en tener una carpeta `scripts`, donde dentro hay unos scripts con nombres normalizados `install`, `test`, ... que se encargan de las tareas que es necesario automatizar.
