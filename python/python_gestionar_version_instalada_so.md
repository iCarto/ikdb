# Gestionar las versiones de Python instaladas en el Sistema Operativo

Para aislar las librerías que se usan en un proyecto con Python de las librerías a nivel sistema se usan los _virtualenv_. Que simplificando es un copy&paste de los binarios de Python a un directorio y jugar con `$PATH` para instalar las librerías en ese directorio.

Los _virtualenvs_ y herramientas del estilo cubren una parte de los requisitos de aislar el proyecto en desarrollo (o en producción) del sistema operativo, pero falta la parte de como gestionar la versión de Python en sí sobre la que se quiere desarrollar.

Para ello, centrándose en Linux, hay varias opciones:

-   Usar la versión de Python que viene por defecto en el Sistema Operativo
-   Conda y Familia
-   Usar un PPA
-   Compilar
-   Usar _pyenv_
-   Vagrant o Docker
-   Usar _asdf_

## Versión de Python por defecto

Si la distribución del equipo de desarrollo es una Ubuntu 18.04 trabajo con Python 3.6. Sólo tengo que asegurarme de que los servidores en producción también son una Ubuntu 18.04 o tienen Python 3.6

Esta opción falla por todos lados:

-   En el momento en que se actualiza el SO en desarrollo o producción, cambia la versión de Python que se está usando, sin ningún control sobre que versión será. Aparecerán _bugs_ en un entorno que no están en el otro, funcionalidades _deprecated_ o nuevas que no están en el otro entorno, ...
-   Al basarse en la versión del SO sólo podremos trabajar con **la versión**. La versión de Python de las LTS (al menos en Ubuntu) en seguida quedan desfasadas. Empezarán a aparecer librerías que requieran de nuevas versiones, funcionalidades que no se puedan usar, ...

A esta "alternativa" también se le puede llamar: "como pegarse un tiro en el pié una misma".

## Conda y Familia

Conda y derivados es una buena herramienta para muchos casos de uso, pero hacer desarrollo web y poner una aplicación en producción en nuestra opinión no es uno de ellos.

## Usar un PPA

En Ubuntu el [PPA de deadsnakes](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa) proporciona una buena combinación de versiones de Python para distintas versiones de Ubuntu.

En general [es bastante seguro usarlo](https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get), y es una de las formas más sencillas de trabajar, pero como se documenta en el propio PPA:

> there's no guarantee of timely updates in case of security problems or other issues. If you want to use them in a security-or-otherwise-critical environment (say, on a production server), you do so at your own risk.

Esta es una opción aceptable para algunos casos de uso, pero tiene problemas:

-   Para otros sistemas operativos o distribuciones habrá que usar otro sistema, con los riesgos de acabar con versiones distintas.
-   No hay garantías de cuando se liberará una versión, o si en algún momento se morirá el PPA

## Vagrant y Docker

Algunos editores permiten una experiencia de desarrollo completa (IntelliSense, ...) aún cuando el el intérprete de Python está alojado en otra máquina o en un contenedor:

-   [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
-   PyCharm. [Create SSH Configurations](https://www.jetbrains.com/help/pycharm/create-ssh-configurations.html), [Configure an interpreter using Vagrant](https://www.jetbrains.com/help/pycharm/configuring-remote-interpreters-via-virtual-boxes.html), ...

Esta forma de trabajo permite construir el entorno de desarrollo de forma aislada no sólo a nivel Python si no también de otras dependencias del sistema, y además enfoca bien la puesta en producción.

Si ya se está usando Docker/Vagrant y todas las personas del equipo usan un editor con estas capacidades esta puede ser muy buena opción, pero si no tienes experiencia con estas herramientas la fricción puede ser demasiado alta.

## pyenv

[pyenv](https://github.com/pyenv/pyenv) es una herramienta que permite gestionar (instalar, activar, ...) distintas versiones de Python sin tocar la del sistema operativo.

El README del repositorio explica bien como funciona internamente, pero poco útil para quien sólo quiera usarlo. Para eso tenemos [este artículo de realpython](https://realpython.com/intro-to-pyenv/). En resumen son una serie de scripts bash que permiten descargar y compilar distintos intérpretes de Python (no sólo cpython), y permiten _activar_ una versión u otra de Python en función del contexto (por debajo juega con `${PATH}`).

Además (en teoría) es un _good citizen_ (por ejemplo se lleva bien tox) y tiene plugins para virtualenv y virtualenvwrapper.

pyenv también podría usarse en producción para gestionar la versión de Python pero al necesitar que estén instaladas en el servidor las dependencias para compilar, puede resultar incómodo.

Instalar pyenv pasa por clonar un repositorio de GitHub y configurar unas variables de entorno. O usar [pyenv-installer](https://github.com/pyenv/pyenv-installer) que en realidad hace lo mismo y además instala algunos plugins.

Algo a tener en cuenta es que de vez en cuando hay que actualizar el propio pyenv con `pyenv update`

Usar pyenv puede parecer similar a usar un PPA. Se depende de un tercero, no oficial, sea descargando binarios o compilando las fuentes. Pero hay dos diferencias:

-   pyenv tiene más versiones y mantenimiento que el PPA de deadsnakes.
-   Los PPA (.deb, ...) para muchos equipos son magia. Mientras que compilar python, escribir scripts en bash y configurar la shell no tiene problema.

En (python_tooling_pyenv)[./python_tooling_pyenv.md] comentamos más cosas sobre su uso.

## asdf

[asdf](https://github.com/asdf-vm/asdf) es una herramienta que permite gestionar distintas versiones de varias aplicaciones. Nació como un substituto unificado de `nvm`, `rvm`, `pyenv`, ... pero actualmente gestiona también aplicaciones como `bat`, `exa`, se lleva bien con `direnv`, ...

Cada aplicación gestionada es un plugin y [tiene decenas](https://github.com/asdf-vm/asdf-plugins).

El funcionamiento es similar al de otros gestores, scripts en bash que actuan cómo `shims`. `asdf` pone de primeros en el `$PATH` sus propios ejecutables que llaman al binario concreto que toca.

En el proyecto se incluye un `.tools-versions` con las versiones deseadas y cuando se entra al directorio y se invoca el ejecutable `python what-ever` el shim intercepta la llamada.

No es una mala opción si se hace "multilenguaje" y realmente se necesitan controlar bien distintas versiones. Si básicamente sólo programas en un lenguaje, es mejor usar un gestor específico para esa lenguaje, y combinarlo con algo como Nix (buscar `nix` en `ikdb` para más info)

Uno de sus problemas es que cuando se instalan binarios con el lenguaje que gestiona (ie `pip install black`), se puede liar y no tener bien controlado el nuevo binario (ie: `black`) por lo que hay que hacer un `asdf reshims`.

## Conclusiones

Si el equipo ya tiene experiencia con Docker y un IDE que soporte el uso del intérprete remoto está es la opción a explorar.

Si no se opta por Docker, pyenv es la herramienta a emplear.

Como combinar pyenv con las herramientas de _virtualenv_ y gestión de dependencias es una cuestión de gustos y estilos que debería ser consensuada en el equipo. No es el objetivo de este artículo entrar en estos temas pero nuestra recomendación:

-   Si estás usando _virtualenvwrapper_ y no otras herramientas, continúa con _virtualenvwrapper_ hasta coger soltura con pyenv. No instales el plugin de `pyenv-virtualenv` ni `pyenv-virtualenvwrapper`. Crea los entornos mediante algo como `PYTHON_VERSION=3.9.7 && mkvirtualenv -p $(pyenv shell "${PYTHON_VERSION}" && pyenv which python) -a "${PROJECT_ROOT_FOLDER}" "${PROJECT_NAME}"`
-   Si usas `virtualenv` o `venv` revisa el uso del plugin `pyenv-virtualenv`. Si no se ajusta a tus gustos continua creando los entornos de forma normal pero a través de la versión de Python que proporciona pyenv. Por ejemplo: `PYTHON_VERSION=3.9.7 && cd "${PROJECT_ROOT_FOLDER}" && $( pyenv shell "${PYTHON_VERSION}" && python -m venv env ) && source env/bin/activate`. A nosotros no nos gusta.
-   Una vez te acostumbres a pyenv, revisa otras herramientas como poetry, pipx y pipenv.