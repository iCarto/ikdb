# virtualenvwrapper

### Instalación

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

Tras instalarlo debemos hacer un _logout_ del sistema (_host_, equipo de desarrollo) para que esté plenamente activo. Si quisiéramos usarlo en la misma sesión o en un script de provisionamiento es un poco más complicado. Se pueden ver ejemplos en los directorios `server` de los [proyectos publicados de iCarto](https://gitlab.com/icarto).
