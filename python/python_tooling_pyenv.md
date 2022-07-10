# pyenv

pyenv es una herramienta para poder mantener en el equipo de una forma sencilla varias versiones de Python a la vez. En [python_gestionar_version_instalada_so](python_gestionar_version_instalada_so.md) revisamos otras alternativas en esta línea, pero no explicamos como funciona o como usar pyenv.

## Como funciona

Los puntos clave para entender como funciona serían:

-   pyenv son una serie de scripts en bash para descargar y compilar versiones de Python.
-   Funciona correctamente en Linux y MacOS. En Windows es necesario usarlo bajo WSL o mediante [pyenv-win](https://github.com/pyenv-win/pyenv-win).
-   Además de bash debemos instalar en el sistema los binarios necesarios para compilar Python.
-   Tiene plugins para facilitar algunas tareas como la gestión de virtualenvs, integrarse con virtualenvwrapper o actualizar el propio pyenv.
-   Se instala descargando el repo de github, o mediante [pyenv-installer](https://github.com/pyenv/pyenv-installer) (que hace lo mismo pero instala plugins adicionales como `pyenv-update` y `pyenv-virtualenv`) y modificando `.bashrc` y/o `.profile`.
-   Los binarios de Python que compila se guardan en `"${PYENV_ROOT}/versions"`. Donde por defecto `PYENV_ROOT="${HOME}/.pyenv"`.
-   Funciona mediante _shims_, esto es, modifica `${PATH}` para que la primera entrada sea `${PYENV_ROOT}/shims/`. En este directorio hay unos pequeños scripts bash ejecutables (_shims_) de nombres `python`, `pip`, ... y que por tanto se ejecutarán antes que los del mismo nombre presentes en otras rutas del sistema. Estos scripts lo único que hacen es invocar [pyenv exec](https://github.com/pyenv/pyenv/blob/master/libexec/pyenv-exec) que se encarga de llamar al binario real que toque en función de la "configuración activa" de pyenv.
-   La "configuración activa", o que versión de Python debe ejecutarse, depende de varios factores y no es [simple de entender](https://realpython.com/intro-to-pyenv/#specifying-your-python-version).
-   pyenv es un _good citizen_ (se lleva bien tox y poetry), tiene plugin para virtualenv, y otras herramientas como pipenv lo usan por debajo.

## Con qué herramientas combinarlo para montar el entorno de desarrollo

Para usar pyenv o combinarlo con otras herramientas para un proyecto tenemos varias opciones:

-   Simplemente usarlo para descargar versiones. Luego usar directamente venv/virtualenv o virtualenvwrapper indicando la versión de Python a usar y luego trabajando como si no existiera pyenv.
    -   Ejemplo venv: `PYTHON_VERSION=3.9.7 && cd "${PROJECT_ROOT_FOLDER}" && $( pyenv shell "${PYTHON_VERSION}" && python -m venv env ) && source env/bin/activate`
    -   Ejemplo virtualenvwrapper: `PYTHON_VERSION=3.9.7 && mkvirtualenv -p $(pyenv shell "${PYTHON_VERSION}" && pyenv which python) -a "${PROJECT_ROOT_FOLDER}" "${PROJECT_NAME}"`
    -   Si queremos trabajar de este modo, debemos modificar las instrucciones de instalación típicas y no incluir estás líneas en los ficheros de configuración de la shell `eval "$(pyenv init --path)"`, `eval "$(pyenv virtualenv-init -)"`
-   Usar la integración de pyenv con venv/virtualenv
-   Usar la integración de pyenv con [virtualenwrapper](https://github.com/pyenv/pyenv-virtualenvwrapper). Pero el plugin lleva sin actualizarse desde 2017. Parece más recomendable evitar este plugin y usar [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv) o directamente virtualenwrapper definiendo a mano la versión de Python.
-   Usarlo a través de otras herramientas como poetry o pipenv

## Comandos

pyenv, más sus plugins tiene bastantes [comandos](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md), cada uno con sus particularidades. `pyenv help <command>` nos da información de cada uno. Aquí presentamos el resumen de lo más interesante:

-   `pyenv update`. Cada cierto tiempo para actualizar pyenv y los plugins. Es comando lo aporta el plugin `pyenv-update`
-   `pyenv install --list | grep ' 3.'`. Para listar las versiones de Python que se pueden instalar filtrando por las de CPython 3.x
-   `pyenv install 3.9.7`. Para instalar la versión `3.9.7`
-   `pyenv uninstall -f 3.9.7`. Para desinstalar (borrar) la versión `3.9.7`, la tengamos instalada o no (`-f`). Con el plugin de virtualenv también se le puede pasar el nombre de un entorno para que lo borre.
-   `pyenv versions`. Para listar las versiones que tenemos instaladas con pyenv, inclyendo virtualenvs si tenemos el plugin.
-   `python --version ; pyenv version`. Para ver la versión activa en ese momento en la shell. Útil hasta que nos acostumbremos a definir la versión activa.
-   `command -v python ; pyenv which python`. Otra combinación útil hasta que nos acostumbremos al uso de pyenv. `which` (o `command -v`) nos mostraran un ejecutable del directorio de _shims_. Para ver la ruta real al binario de python activo usamos `pyenv which`
-   `pyenv commands` para listar los comandos disponibles, incluidos los proporcionados por plugins, y `pyenv <command> --help` para obtener la ayuda.
-   `pyenv virtualenvs` para listar los virtualenvs. Salen dos filas por cada entorno virtual.
-   `pyenv virtualenv 3.9.7 "${PROJECT_NAME}"`. Creamos un entorno virtual con la versión `3.9.7` de nombre `${PROJECT_NAME}`. Este comando no crea el directorio del proyecto. Crea un nuevo directorio `"${PYENV_ROOT}/versions/3.9.7/envs/${PROJECT_NAME}"` donde estarán los nuevos binarios de python y paquetes que instalemos.
-   `pyenv activate "${PROJECT_NAME}"`. Para activar el virtualenv.

## Problemas y cosas a tener en cuenta.

-   Las versiones de Python disponibles para instalar dependen de la versión de pyenv que tengamos instaladas, así que debemos actualizarlo periódicamente `pyenv update`

-   pyenv compila las versiones de Python. Si actualizamos el sistema operativo puede haber dependecias que se rompan. Tras un cambio de versión del sistema operativo (ie: Ubuntu 18.04 -> Ubuntu 20.04), es conveniente eliminar todos los entornos virtuales y las versiones de Python instaladas a través de pyenv y volver a generarlas.

-   Tras instalar pyenv de la forma recomendada, es necesario hacer un logout completo del sistema. Hacer un script bash de provisionamiento (de una máquina Vagrant por ejemplo, o de un entorno de desarrollo) que lo instale, descargue Python y cree un virtualenv necesita bastantes _triquiñuelas_. En los proyectos de iCarto se pueden ver ejemplos de este tipo de scripts.

-   El plugin de `pyenv-virtualenv` tiene comportamientos que puede resultar confuso para alguna gente. Ver por ejemplo este bug: https://github.com/pyenv/pyenv-virtualenv/issues/135.
-   En lugar de `pyenv activate` si tenemos en `.bashrc` la línea `"$(pyenv virtualenv-init -)"`, al entrar en un directorio que tenga un fichero `.python-version` se activara el virtualenv. Si sales del directorio se desactiva el virtualenv. Y configurar el PROMPT para que indique que se está en un virtualenv es complicado.

-   `.python-version` no tiene porqué contener una versión de Python, si no el nombre que le hemos asignado a un entorno virtual a través de virtualenv. Recordemos que `pyenv` asocia los virtualenv directamente con las versiones de Python a partir del que se crean. Este es un fichero que sólo se puede comitear al repo si todo el equipo acuerda unas prácticas comunes en torno al uso de `pyenv` y los nombres de los entornos.

-   **No existen las balas de plata**. `pyenv` soluciona algunos problemas pero introduce [otros](https://frostming.com/2021/01-22/introducing-pdm/):

    -   Es una nueva herramienta a mantener y aprender su uso.
    -   Si usamos el Python del sistema operativo cada vez que creamos un virtualenv estaremos usando una versión de Python actualizada (al menos en la versión micro). Con pyenv debemos descargar también a mano las versiones micro.
    -   Si también lo usamos en producción estaremos añadiendo un montón de dependencias que en realidad no son necesarias en el servidor.
    -   Para reducir los problemas y mejorar la **D**eveloper e**X**perience, el uso `pydev` debería estar bien documentado, y lo más automatizado posible, desde la instalación a la creación de nuevos _virtualenv_

## Configuración iCarto

En iCarto usamos `pyenv` para gestionar las versiones de Python en el entorno de desarrollo, y lo combinamos con `virtualenvwrapper`.

Cuando creamos un _virtualenv_ para un proyecto lo hacemos a través de scripts de forma parecida a esta:

```shell
PROJECT_NAME=foo
PROJECT_ROOT_FOLDER="~/repos/${PROJECT_NAME}"
PYTHON_VERSION=3.9.7

command -v deactivate && deactivate
rmvirtualenv "${PROJECT_NAME}"

if ! pyenv versions | grep "${PYTHON_VERSION}" > /dev/null 2>&1; then
    pyenv update
    pyenv install "${PYTHON_VERSION}"
fi

PYTHON_VERSION_BINARY_PATH="$(pyenv shell "${PYTHON_VERSION}" && pyenv which python)"

# https://github.com/pexpect/pexpect/commit/71bbdf52ac153c7eaca631637ec96e63de50c2c7
mkvirtualenv -p "${PYTHON_VERSION_BINARY_PATH}" -a "${PROJECT_ROOT_FOLDER}" "${PROJECT_NAME}" || true

workon "${PROJECT_NAME}"
```

Para crear _virtualenv_ temporales o de pruebas podemos jugar con la variable `VIRTUALENVWRAPPER_PYTHON` de nuestro `.bashrc` para tener una versión de Python predefinida con lo que simplemente ejecutaríamos: `mkvirtualenv -a mi_proyecto mi_projecto`, usar una sentencia como el ejemplo de virtualenvwrapper que pusimos en una sección anterior, o incluso crear una pequeña función en nuestro `.bashrc`

### Instalación

En Ubuntu 20.04 lo instalamos del siguiente modo:

```shell
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
sed -Ei -e '/^([^#]|$)/ {a \
export PYENV_ROOT="${HOME}/.pyenv"
a \
export PATH="${PYENV_ROOT}/bin:${PATH}"
a \
' -e ':a' -e '$!{n;ba};}' ~/.profile

echo '
eval "$(pyenv init --path)"
' >> ~/.profile

echo '
eval "$(pyenv init -)"
' >> ~/.bashrc
```

Tras instalarlo debemos hacer un _logout_ del sistema (_host_, equipo de desarrollo) para que esté plenamente activo. Si quisiéramos usarlo en la misma sesión o en un script de provisionamiento es un poco más complicado. Se pueden ver ejemplos en los directorios `server` de los [proyectos publicados de iCarto](https://gitlab.com/icarto).
