# brew

`brew` es conocido como el gestor de paquetes no oficial de MacOS. Pero también funciona en Linux.

-   https://github.com/Homebrew/brew

## ¿Por qué usar brew?

brew cumple casi todas las características que planteamos para una herramienta de este tipo:

-   Soporta MacOS, Linux y WSL
-   Se instala fácil, y su uso básico es trivial
-   La colección de software es muy amplia. Seguramente nos encontremos "todo" lo que necesitemos.
-   Todos los paquetes quedan contenidos en bajo una estructura de directorios muy concreta.

El mayor problema es que es muy complicado (¿imposible?) pinear versiones para muchos paquetes.

Además debemos tener en cuenta que brew gestiona sus propias dependencias. Así que instalar un paquete implica descargar medio internet. Instalar brew y el paquete `hello` es 1GB.

## Cómo funciona brew

-   https://docs.brew.sh/Homebrew-on-Linux

En Linux brew se instala por defecto (y mejor no cambiarlo) en la ruta `/home/linuxbrew/.linuxbrew`. A esta ruta se le denomina `prefix`, y todos los paquetes instalados colgarán de ella.

El instalador se encarga de generar los enlaces simbólicos necesarios para que estén disponibles en `$PATH`

En algunos casos los binarios estarán en el repositorio, en otros brew descargará las fuentes y construirá los binarios en local. Por debajo brew usa un pequeño script en ruby llamado _formulae_ que contiene las instrucciones de construcción o instalación del paquete.

Antes de instalar un paquete debemos buscar si está disponible para Linux.

-   https://formulae.brew.sh/formula/

## Instalación

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

Para que funcionen las _completions_:

-   https://docs.brew.sh/Shell-Completion

Y a tener en cuenta que justo después de instalar un paquete hay que hacer un `source ~/.profile` o equivalente para que las completions de ese paquete estén disponibles.

## Uso

```shell
brew update # Actualiza la lista de paquetes y el propio brew
brew install bat # Instala el paquete bat
brew outdated # Lista los paquetes desactualizados
brew upgrade # Actualiza todos los paquetes
brew upgrade bat # Actualiza el paquete bat
brew remove bat
brew autoremove # Desinstala las dependencias transitivas no necesarias
brew list # Lista los paquetes instalados
brew cleanup --prune=all -s # Para hacer limpieza
```
