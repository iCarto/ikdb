Hay unas herramientas para la mayoría de las _shell_ que si no tienen un nombre perfectamente definido generalmente se pueden denominar como _autojump_. Son básicamente un substituto del comando `cd` que agiliza moverse entre directorios en la terminal.

Hay muchas implementaciones de esta funcionalidad siendo las más conocidas:

-   [autojump](https://github.com/wting/autojump). Es la más antigua que conozco. Nació en 2008. Pero dejó de actualizarse en 2018. Está escrita en Python. Soporta la mayoría de shells y sistemas operativos. Se puede instalar con brew en MAC o el gestor de paquetes en Linux.
-   [fasd][https://github.com/clvv/fasd]. Que tuvo su momento pero lleva sin actualizarse desde 2015.
-   [z.lua](https://github.com/skywind3000/z.lua). Nació en 2018. No demasiado popular. Escrito en lua. En teoría más rápida que fasd, z y autojump. Integración con fzf. Disponible para la mayoría de shells y sistemas operativos como un simple script lua. Para instalarla es necesario tener lua instalado y tocar el fichero de configuración de la shell. Tiene unas cuantas opciones de configuración y trucos para navegar.
-   [z](https://github.com/rupa/z). Otra de las más veteranas, nacida en 2010. La más popular en este momento. Es un simple script de shell que se carga desde el fichero de configuración de la shell que usemos.
-   [zoxide](https://github.com/ajeetdsouza/zoxide). Es la más reciente, nación en 2020. Escrita en Rust, todavía no es tan popular como `z` pero crece rápido. Destaca en la integración con otras herramientas como Vi, Emacs o fzf. Funciona con la mayoría de sistemas operativos y shells. Se autodeclara como una de las más rápidas.

La idea de todas las herramientas es similar.

-   Tras instalarla navegamos los directorios con `cd` o los comandos de la herramienta para construir la base de datos inicial.
-   La base de datos en algunos casos es un simple archivo de texto y en otros es algún tipo de binario. Por lo que podemos "exportarlo" o tocarlo.
-   Una vez tiene suficiente información los comandos que proporcionan agilizan el acceso a los directorios. En lugar de escribir rutas completas podemos escribir una parte o el directorio final y la herramienta infiere a que directorio queremos saltar. El algoritmo de decisión es distinto para cada herramienta, en algunas puntúan más el último directorio visitado, en otros los más visitados, o permiten asignar pesos a los criterios de decisión.

# Cual usar

Si no quieres complicarte `z` es la mejor opción. Es la más popular, una de las más antiguas y es un simple script. Pero `zoxide` empieza a coger mucha tracción, y su integración con otras herramientas como FZF o Emacs es muy, así que es nuestra recomendación.

# Zoxide

## Instalar

En el [README] del proyecto dan varias opciones para la instalación, importar los datos de otras herramientas de _autojump_, ... Si tu distribución está soportada se puede instalar como paquete.

Si no la mejor opción es usar el [webinstaller](https://webinstall.dev/).

```shell
curl -sS https://webinstall.dev/zoxide | bash
```

Lo único que hace es crear alguna carpeta en `$HOME/.local/opt` y hacer un enlace simbólico al binario en `$HOME/.local/bin/zoxide` para que esté en el `PATH`. El mismo comando se puede usar para actualizar la versión. Luego añadimos una línea al fichero de configuración de la shell y estaría funcionando.

A partir de este momento podemos empezar a navegar por los directorios usando `z` en lugar de `cd`. Independientemente de cual usemos `zoxide` usará ambos comandos para ir generando la base de datos que por defecto está en `~/.local/share/zoxide/db.zo`

A nivel configuración, en realidad sin un criterio demasiado cientifico usamos:

```
# .bashrc

# Zoxide
export _ZO_MAXAGE=5000 # default 10000. 4 * _ZO_MAXAGE number of entries in the db
export _ZO_RESOLVE_SYMLINKS=1 # resolve symlinks before adding directories to the db
eval "$(zoxide init bash)"
```

Sin `_ZO_RESOLVE_SYMLINKS=1` el path absoluto y el path a través del symlink podrán aparecer por separado en la base de datos. Cuestión de gustos.

Algo a tener en cuenta es que ignora la capitalización pero no los diacríticos y es [una discusión en curso](https://github.com/ajeetdsouza/zoxide/issues/224).

## Uso

Esta es una de esas herramientas que es más fácil de usar que de describir como se usa.

Dada una base de datos de este tipo:

```
10   /home/user/work/inbox
30   /home/user/mail/inbox
10   /home/user/workspace
20   /home/user/workspace/project1
30   /home/user/workspace/project2
40   /home/user/workspace/project3
```

-   `z in`. cd into highest ranked directory matching "in". `/home/user/mail/inbox`
-   `z w p`. cd into highest ranked directory matching "w" and "p". `/home/user/workspace/project3`
-   `z in /`. cd into a subdirectory starting with `in`.

z also works like a regular cd command

-   `z ~/work/inbox`.
-   `z foo/`. cd into relative path
-   `z ..`. cd one level up
-   `z -`. cd into previous directory
-   `z`. cd into `$HOME`

z also have "interactive" features

-   `zi foo`. cd with interactive selection (using fzf)
-   `z foo<SPACE><TAB>`. show interactive completions

## Hacks

El comando `zoxide` permite algunos hacks como agregar un directorio a mano a la base de datos. `zoxide --help` para más información.
