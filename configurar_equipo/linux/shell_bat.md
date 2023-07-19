# Bat

`bat` es un `cat` con mejoras, sobre todo coloreado de la salida.

-   https://github.com/sharkdp/bat/

Quizás lo más interesante es que no sólo colorea _código_ (Python, JavaScript, ...) si no también otro tipo de ficheros como Markdown, logs, y cosas variadas como `/proc/cpuinfo`.

Con un poco de configuración, o alias también se puede hacer que coloree las páginas de `man` o los `--help` de cualquier comando.

## Instalar

Los paquetes de la distro seguramente están anticuados así que lo mejor es una instalación semimanual. En macOS se puede usar brew y en Ubuntu descargar el .deb de la página de releases (que además incluye el bash-completion)

```
VERSION=0.23.0

case "$OSTYPE" in
  darwin*)
      MY_OS="darwin"
      echo 'Do `brew install bat`'
      ;;
  linux*)
      MY_OS="linux"
      ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

url=https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_amd64.deb
wget -q -O /tmp/bat_${VERSION}_amd64.deb ${url}
sudo dpkg -i /tmp/bat_${VERSION}_amd64.deb
rm /tmp/bat_${VERSION}_amd64.deb
```

## Uso y configuración

Su uso básico es sencillo, en cualquier situación en la que usaríamos `cat`, usamos `bat`. Si el fichero no es reconocido por `bat`, por ejemplo un `requirements.txt` podemos forzar un tipo de coloreado.

Por defecto usa el pager que tengamos configurado en el sistema, y en general asumirá que si la salida entra en una pantalla no hará paginación.

Admite un fichero de configuración, con bastantes opciones como las "decoraciones" (`style`) que usa en la salida, el tema de colores, ...

Algunos ejemplos de uso típicos:

```shell
bat myfile.py
bat ~/.ssh/config

# Fuerza el coloreado de sintaxis estilo Python
bat -l python requirements.txt

# El -pp elimina el pager y las decoraciones. Útil para copy&paste
bat -pp myfile.js

# Muestra los non-printable characters
bat -A myfile.md
```

En `.bashrc` o similar

```
# Colorea la salida de man mediante bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

Si se usa zsh también se puede colorear automáticamente la salida de `--help`, `-?`, ...

```
# https://github.com/victor-gp/cmd-help-sublime-syntax/issues/5
if (($+commands[bat])); then
  bat-help() {
    for opt in $@; do
      alias -g -- "$opt=\\$opt | bat -plhelp --paging=never"
    done
  }
  bat-help --help
  # man
  bat-help '-\?'
  # x264
  bat-help --longhelp --fullhelp
  # gnome
  bat-help --help-all --help-gapplication --help-gtk
  unfunction bat-help
fi
```

En `~/.config/bat/config`:

```
# To preview  the themes https://github.com/sharkdp/bat#highlighting-theme
--theme="Monokai Extended"

# Con un tipo de letra adecuado usa cursiva/itálica para algunos coloreados
--italic-text=always

# Un buen equilibrio entre copy&paste, decoración e información
--style=changes,header-filename,header-filesize,rule,snip
```