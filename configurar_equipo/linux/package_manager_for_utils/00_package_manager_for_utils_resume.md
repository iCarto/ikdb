# Resumen

Hay herramientas cómo `shellcheck` que un equipo de desarrollo puede considerar obligatorias. Hay otras herramientas como `fzf` que pueden no considerarse obligatorias pero si estuvieran en el entorno permitirían mejorar el _tooling_.

Qué cada persona del equipo a instale y actualice estas herramientas a mano es una pérdida de tiempo y una fricción innecesaria.

Hacer scripts automáticos multiplataforma que gestionen estas herramientas es complicado, verboso, y propenso a errores.

Definir un _package manager_ estándar para el equipo, que gestione este tipo de software ayuda a solucionar estos problemas.

En iCarto nos hemos decidido por [nix](https://nixos.org/).

En el resto de artículos de esta serie ampliamos los motivos:

-   00_package_manager_for_utils_resume.md Este artículo y el punto de entrada a la serie.
-   01_package_manager_for_utils.md Donde se amplían los motivos de porqué este tipo de software es útil.
-   02_package_manager_for_utils_brew.md Donde se habla de brew y el motivo principal por el que no lo hemos escogido.
-   03_package_manager_for_utils_nix.md Donde se habla de nix.

# ¿Con prisa?

```
# Instalar Nix

if [[ "${OSTYPE}" == "darwin"* ]]; then
    sh <(curl -L https://nixos.org/nix/install)
else
    if [[ $(id -u) == 0 ]]; then
        echo "Do not run this script as root"
        exit 1
    fi
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

# Opcionalmente eliminar primero shfmt, shellcheck

# Instalar los paquetes
nix-env --install shfmt-3.7.0 shellcheck-0.9.0
```
