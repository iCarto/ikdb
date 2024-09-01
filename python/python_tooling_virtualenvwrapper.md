# virtualenvwrapper

## Variables de Entorno

Estas son las principales variables de entorno y terminología que se usa en virtualenv

`${WORKON_HOME}` es el path al directorio donde estarán los distintos virtualenv que estemos usando. Es la localización donde se guardaran las librerías python que cada proyecto tenga como requisitos. El directorio debe existir, si no debemos crearlo.

`${PROJECT_HOME}` es el path al directorio en el que tengamos habitualmente el código fuente de nuestros proyectos. Esta variable no es necesario fijarla. De hecho puede ser positivo no setearla para evitar "magia". Generamente será algo así como ~/projects o ~/devel.

_virtualenv_ es el directorio donde estará el entorno virtual. Es decir donde estará el binario de python que estemos usando, las librerías que hayamos descargado, y también donde se _instalará_ nuestro proyecto. Cuando hayamos activado un virtualenv el path a este directorio estará recogido en la variable `${VIRTUAL_ENV}`

_project directory_ Es el directorio donde estará el código fuente del proyecto en el que estemos trabajando. Generalmente estará en una ruta del tipo. Si hemos vinculado un virtualenv a un project directory (muy recomendable) habrá un fichero `.project` dentro de `${VIRTUAL_ENV}` con el path absoluto al project directory

## Instalación

En Ubuntu 20.04 lo instalamos del siguiente modo:

```shell
sudo pip3 install --upgrade pip
sudo pip3 install --upgrade virtualenvwrapper
_PYTHON_PATH=$(command -v "python3")
_VIRTUALENVWRAPPER_PATH=/usr/local/bin/virtualenvwrapper.sh
echo "VIRTUALENVWRAPPER_PYTHON=${_PYTHON_PATH}" >> ~/.bashrc
echo "source ${_VIRTUALENVWRAPPER_PATH}" >> ~/.bashrc
source ~/.bashrc
echo 'cdproject' >> ~/.virtualenvs/postactivate
```

Tras instalarlo debemos hacer un _logout_ del sistema (_host_, equipo de desarrollo) para que esté plenamente activo. Si quisiéramos usarlo en la misma sesión o en un script de provisionamiento es un poco más complicado.

Se pueden ver ejemplos en los directorios `server` de los [proyectos publicados de iCarto](https://github.com/iCarto/).
