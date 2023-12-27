# Sistemas de Gestión de Paquetes

La Wikipedia dice que un sistema de gestión de paquetes o [package manager](https://en.wikipedia.org/wiki/Package_manager) es una colección de herramientas software que automatiza el proceso de instalar, actualizar, configurar y eliminar software de un ordenador de manera consistente.

A día de hoy todos los sistemas operativos tienen algún tipo sistema de gestión de paquetes "estándar", sea algo como Mac App Store y Software Update, [Windows Package Manager](https://learn.microsoft.com/en-us/windows/package-manager/) y Windows Update, o uno de los múltiples que existen para Linux como apt, yum, ...

# Porqué usar un sistema de gestión de paquetes alternativo

Pero también hay un montón de _package manager_ alternativos. Para Windows y MacOS suele ser una recomendación básica instalar brew o chocolatey. En Linux las opiniones sobre usar un método alternativo, por ejemplo brew para Linux suele tener [bastantes críticas](https://www.reddit.com/r/linuxquestions/comments/naf6ay/does_anyone_uses_brew_on_linux/) y te dicen que uses una _rolling release_ si quieres "software a la última".

Este punto de vista puede ser cierto para _software y usuarias normales_. Si se quiere mantener un sistema estable quédate con tu gestor de paquetes y para algún software concreto, por ejemplo LibreOffice usa un PPA o el equivalente en distribuciones no basadas en Debian.

Pero cuando nos vamos a _power users_ hay muchas pequeñas (o no tan pequeñas) herramientas, como bat, ShellCheck, ... que no están disponibles a través de PPA y en los repositorios oficiales no están o están desactualizadas.

Instalar y actualizar estas herramientas, a mano, acaba siendo un caos. Sobre todo si se quieren estandarizar en un equipo con distintos sistemas operativos.

Pongamos por ejemplo un script de instalación de [ShellCheck](https://www.shellcheck.net/) y otro de [bat](https://github.com/sharkdp/bat) compatible con MacOS y Linux.

<details>
<summary>Script de instalación de Shellcheck</summary>

```shell
VERSION="v0.9.0" # or "latest"
INSTALL_PATH="${HOME}/bin"

case "$OSTYPE" in
  darwin*)
      MY_OS="darwin"
      MY_PATH="/usr/local/bin"
      ;;
  linux*)
      MY_OS="linux"
      MY_PATH="${HOME}/bin"
      ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

url="https://github.com/koalaman/shellcheck/releases/download/${VERSION}/shellcheck-${VERSION}.${MY_OS}.x86_64.tar.xz"
wget -qO- ${url} | tar -xJv
mkdir -p "${INSTALL_PATH="${HOME}/bin"}"
cp "shellcheck-${VERSION}/shellcheck" "${INSTALL_PATH="${HOME}/bin"}/shellcheck"
```

</details>

<details>
<summary>Script de instalación de bat</summary>

```shell
VERSION=0.23.0

case "$OSTYPE" in
  darwin*)
      MY_OS="darwin"
      brew install bat
      ;;
  linux*)
      MY_OS="linux"
      url=https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_amd64.deb
      wget -q -O /tmp/bat_${VERSION}_amd64.deb ${url}
      sudo dpkg -i /tmp/bat_${VERSION}_amd64.deb
      rm /tmp/bat_${VERSION}_amd64.deb
      ;;
  *)        echo "unknown: $OSTYPE" ;;
esac
```

</details>

# Características Deseadas

Que buscamos por tanto en un sistema de gestión de paquetes para "software de utilidades":

1. Multiplataforma: Debe funcionar al menos en MacOS y Linux. Los entornos más usados en desarrollo e idealmente también en Windows. Aunque siempre queda WSL.
2. Fácil de instalar, actualizar y usar. Lo queremos para hacernos la vida más fácil no para complicárnosla más
3. Amplia colección de software. "Todo" lo que necesitemos debe estar en sus repositorios, si hay muchas excepciones es cómo no tenerlo.
4. Aislado del sistema operativo. Instalar paquetes no deja de ser un peligro. Sea por la "fuente" del paquete, o porqué puede romper el sistema. Así que lo que se instale debe en cierta forma estar aislado. Si instalo Python con un package manager alternativo no puede substituir el que esté por defecto en el sistema.
5. Versiones _pineadas_. Seguramente para algo como bat, te da igual tener una versión que otra instalada, pero cuando trabajamos con un formatter como shfmt o un linter como ShellCheck queremos que todo el equipo tenga la misma versión instalada.

# Qué alternativas hay:

Basta entrar en la [sección Installation](https://github.com/sharkdp/bat#installation) de cualquier utilidad como bat para sorprenderse de la cantidad de utilidades de este tipo.

Pero también es fácil descartar la mayoría por no cumplir con las características que buscamos y quedarnos con dos opciones para revisar con más detalle:

-   brew: El gestor de paquetes no oficial de MacOS también disponible para Linux.
-   nix: Una herramienta difícil de explicar pero que también tiene un "modo brew".
