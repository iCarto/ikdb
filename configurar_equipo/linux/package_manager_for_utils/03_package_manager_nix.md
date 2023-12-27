# Nix

Nix es una herramienta poco conocida, aunque [el primer commit](https://github.com/NixOS/nix/graphs/code-frequency) es del 2004.

Se autodefine cómo:

> Declarative builds and deployments.
> Nix is a tool that takes a unique approach to package management and system configuration. Learn how to make reproducible, declarative and reliable systems.

Nix es mucho más que un gestor de paquetes, es todo un ecosistema para la construcción de entornos (de desarrollo o producción) de forma declarativa, reproducibles y aislados. El ecosistema tiene hasta su propia distribución de Linux: NixOS.

En este artículo ignoraremos todo lo que el ecosistema Nix permite para trabajar sólo con el gestor de paquetes en lo que podemos llamar _modo brew_.

## ¿Por qué usar Nix?

Nix cumple todas las características que planteamos para una herramienta de este tipo:

-   Soporta MacOS, Linux y Windows (a través de WSL)
-   Se instala fácil, y su uso básico es trivial
-   La colección de software es muy amplia. Seguramente nos encontremos "todo" lo que necesitemos.
-   Todos los paquetes quedan contenidos en bajo una estructura de directorios muy concreta.
-   Todos los paquetes están pineados y podemos instalar versiones concretas.

Cómo sucede con brew, Nix gestiona sus propias dependencias. El simple hecho de instalarlo son 500MB.

A pesar de que lo usamos únicamente en _modo brew_ esto nos da experiencia en si tiene sentido emplear más capacidades de Nix.

## Cómo funciona Nix

El funcionamiento de Nix está resumido en esta [sección de la documentación](https://nixos.org/manual/nix/stable/introduction).

Nix almacena cada paquete en un subdirectorio `/nix/store` de este estilo `/nix/store/b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z-firefox-33.1/`. Una vez construido, Nix nunca sobrescribe ficheros. Añade nuevas versiones en paths diferentes. Dado que nunca sobrescribe, ni elimina (hasta que se lo indiquemos) tener múltiples versiones o hacer roll back es sencillo.

El `b6gvzjyb...` es un identificador único ("hash") que captura la versión del paquete y sus dependencias. Los paquetes declara explícitamente el hash de sus dependencias de modo que se reutilizan entre paquetes que las compartan, o se instalan nuevas en sus propios paths, por lo que el riesgo de colisión es mínimo.

Cada paquete de Nix (`nixpkgs`) usa un DSL funcional para describir como construir el paquete. En algunos casos directamente descargaremos los binarios en otros los construirá.

Un fichero de _setup_ (`~/.nix-profile/etc/profile.d/nix.sh`) que el propio instalador añadirá a `~/.profile` o lo que toque se encarga de modificar las variables de entorno como `$PATH` para tener disponibles las versiones de los binarios instalados con Nix que hayamos seleccionado. En `~/.nix-profile/bin` estarán los enlaces simbólicos de estos binarios hace `/nix/store/...`

## Instalación

En Linux y WSL Nix tiene [dos modos de instalación](https://nixos.org/download) "multi-user" y "single-user". En MacOS sólo está disponible el modo "multi-user". En Linux el modo multi-user instala un servicio de `systemd`, crea usuarios y grupos, ... Para un entorno de desarrollo el modo "single-user" es "suficientemente bueno" y es el que usaremos.

```
if [[ "${OSTYPE}" == "darwin"* ]]; then
    sh <(curl -L https://nixos.org/nix/install)
else
    if [[ $(id -u) == 0 ]]; then
        echo "Do not run this script as root"
        exit 1
    fi
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi
```

### Actualización

```
if [[ "${OSTYPE}" == "darwin"* ]]; then
    sudo -i sh -c 'nix-channel --update && nix-env --install --attr nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
else
    if [[ $(id -u) == 0 ]]; then
        echo "Do not run this script as root"
        exit 1
    fi
    nix-channel --update; nix-env --install --attr nixpkgs.nix nixpkgs.cacert
fi
```

## Uso

```
# Listar todos los paquetes disponibles. Tarda un buen rato.
nix-env --query --available --attr-path

# Paquetes con firefox o chromium en el nombre
nix-env --query --available '.*(firefox|chromium).*'

# Listar paquetes instalados
nix-env --query --installed --attr-path


# Instalar un paquete
nix-env --install --attr nixpkgs.hello
nix-env --install firefox
nix-env --install firefox-32.0

# Entra en una shell temporal con el paquete deseado presente. Cuando salimos con `exit` el paquete desaparece
nix-shell --packages hello

# Desinstalar un paquete. Todavía nos permite rollback
nix-env --uninstall firefox

# Borrar de disco los paquetes desinstalados y dependencias no usadas. Ya no permite rollback
nix-collect-garbage --delete-old

# Actualizar todos los paquetes, tras actualizar Nix
nix-env --upgrade '*'
```

## Tips

-   Es mejor instalar varios paquetes en un sólo comando que en comandos separados. Esto evita crear `generations` distintas

## Enlaces útiles

-   https://nixos.org/manual/nix/stable/introduction
-   https://nixos.org/manual/nix/stable/package-management/profiles
-   https://search.nixos.org/packages
-   https://nixos.org/guides/nix-pills/
-   [Encontrar versiones antiguas de un paquete](https://lazamar.co.uk/nix-versions/)
-   https://nix.dev/
    -   https://nix.dev/tutorials/first-steps/reproducible-scripts
    -   https://nix.dev/tutorials/first-steps/declarative-shell
    -   https://nix.dev/guides/recipes/sharing-dependencies
