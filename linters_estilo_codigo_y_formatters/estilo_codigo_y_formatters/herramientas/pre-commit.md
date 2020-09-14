# pre-commit

[pre-commit](https://pre-commit.com/) es una herramienta escrita en Python (con soporte multi-idioma para las herramientas) que permite:

-   Instalar hooks de git
-   Instalar las herramientas asociadas a los hooks
-   Compartir los hooks a nivel repo

Es importante leer la documentación para entender que hace. Lo básico:

-   Un fichero de configuración `.pre-commit-config.yaml` en el repo dice que herramientas se usarán, con que parámetros, y en que hook de git se instalaran
-   Por defecto se lanza en `precommit`
-   Filtra la lista de ficheros del área _stage_/_cached_ en base a las directivas `files` y `type` de configuración y pasa los paths de los ficheros a la herramienta que toque.
-   Se puede [evitar temporalmente el uso de una herramienta](https://pre-commit.com/#temporarily-disabling-hooks) o evitar todos los hooks: `git commit --no-verify`

**Importante**

La mayoría de formatters devuelve un código de salida mayor a 0 cuando reformatean algún fichero lo que hace que pre-commit lo considere un "Fail" y no termine el commit. Llega con revisar los cambios y volver a añadir los ficheros.

```bash
git diff
git add -u
git commit
```

**Algunos detalles**

-   El parámetro `rev` es obligatorio. Debe irse repo a repo poniendo el texto usando para el último tag de release. `pre-commit autoupdate`, puede actualizarlos todos después.
-   Cada herramienta instalada crea un un entorno virtual (virtualenv, pyenv, [py-nodeenv](https://github.com/ekalinin/nodeenv), con el que se lanza el ejecutable de la herramienta, de modo que ni el proyecto en sí, ni el equipo se poluciona.
-   Mantener la sincronización de versiones y de los ficheros que deben ser procesados entre _pre-commit_, la configuración propia de la herramienta y el `package.json` puede ser complicado. Hay que hacer algunas pruebas hasta conseguirlo y se aconseja forzar la configuración de [types](https://pre-commit.com/#filtering-files-with-types) y/o [files]() de _pre-commit_ durante algún tiempo hasta que bugs y nuevas funcionalidades sean un poco más compatibles entre proyectos.
-   El uso de un repositorios local, donde tira de los binarios ya instalados en el repo con `package.json` o mediante `pip` puede ser útil para mantener versiones en sincronía, no tener que configurar los plugins en `additional_packages`, ... En iCarto hacemos mucho uso de ellos sobre todo para las herramientas basadas en node porqué hemos encontrado que de este modo ganamos bastante versatilidad y control sobre las versiones y opciones empleadas.
-   Con _pre-commit_ parece una buena idea usar `pre-commit run prettier -a` o similares para evitar meter scripts en `package.json` pero en las pruebas realizadas y por como se comportan las funcionalidades de `ignore` puede haber problemas.
-   Los ficheros de configuración de las herramientas deben estar al menos en stage para que pre-commit las coja. _pre_commit_ hace algo similar a `git stash` antes de ejecutarse, de modo que si hay cambios en esos ficheros no serán aplicados al hook en curso.

**Actualizar y limpiar**

De vez en cuando al trabajar con pre-commit. Quizás en cada nueva fase:

```bash
pre-commit gc
pre-commit clean
pre-commit install --install-hooks
pre-commit autoupdate
```
