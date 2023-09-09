# Instalación de WSL

WSL (Windows Subsystem for Linux) es un "plugin" de Microsoft para Windows, que permite ejecutar un Linux dentro de Windows.

Para instalarlo simplemente hay que:

-   Abrir una terminal de Windows o PowerShell
-   Ejecutar: `wsl --install`
-   Reiniciar el ordenador

En el menú de Windows aparecerá un nuevo icono para Ubuntu Linux. Lo abrimos y definimos nombre de usuario y contraseña.

A continuación podremos usar Linux en modo administrador desde la línea de comandos escribiendo en un PowerShell

```
wsl -u root
```

Tras la primera instalación conviene actualizar el sistema ejecutando `apt update && apt upgrade`

A continuación debemos editar un fichero de configuración. En WSL en ocasiones [hay problemas con los volúmenes compartidos](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly#ensure-volume-mounts-work) (por ejemplo pasa con la imagen docker de `postgis`).

Cuidado al copiar el siguiente comando. Son varias líneas que deben copiarse y pegarse a la vez.

```
echo '
[automount]
root = /
options = "metadata"
' >> /etc/wsl.conf
```

Después debemos volver a reiniciar Windows.

### Referencias

-   https://learn.microsoft.com/en-us/windows/wsl/install
-   https://learn.microsoft.com/en-us/windows/wsl/setup/environment
