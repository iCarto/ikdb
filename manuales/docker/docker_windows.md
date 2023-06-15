# Docker para usuarias no técnicas

En este artículo hablamos brevemente de como usar e instalar docker en Windows.

## Introducción poco rigurosa para quien conoce Vagrant

Docker es una implementación de una tecnología llamada de forma genérica _containers_ (contenedores). Mientras que Vagrant/VirtualBox/Máquina Virtual sería como crear un ordenador entero (_guest_) dentro del nuestro (_host_), y dentro de la máquina virtual se instalarían distintas aplicaciones y servicios (una base de datos, una aplicación web, ...), Docker es una aproximación distinta.

Lo que hace es crear como pequeñas máquinas virtuales (contenedor) que no equivaldrían a un ordenador entero si no a cada servicio por separado. Levantas un docker con la base de datos, y otro docker con la aplicación web.

El equivalente al `Vagrantfile` sería el `Dockerfile`, pero este fichero en general no es necesario. Directamente se puede traer una imagen (un fichero que contiene esa pequeña máquina virtual ya creada) de un repositorio de imágenes de internet. Cuando ejecutas esa imagen, a la imagen en ejecución es cuando se le llama contenedor.

Cuando quieres ejecutar varios docker a la vez, en lugar del `Dockerfile` o lanzar un comando a mano se usa un fichero llamado `docker-compose.yml`. Este fichero contiene el nombre de las imágenes a ejecutar, configuración para los contenedores, mapeo de puertos, ...

Para poder ejecutar un fichero `docker-compose.yml` hace falta un plugin para Docker, llamado `docker compose`.

## Instalar `docker` y `docker compose` en Windows.

En primer lugar hay que instalar WSL. Un "plugin" de Microsoft para Windows, que permite ejecutar un Linux dentro de Windows. Simplemente hay que abrir una terminal de Windows o PowerShell, escribir:

```
wsl --install
```

y reiniciar.

En el menú de Windows aparecerá un nuevo icono para Ubuntu, lo abrimos y definimos nombre de usuario y password.

A continuación podremos usar Linux en modo administrador desde la línea de comandos escribiendo en un PowerShell

```
wsl -u root
```

Tras la primera instalación conviene actualizar el sistema ejecutando `apt update && apt upgrade`

Una vez instalado WSL podemos instalar Docker.

En Windows tendríamos dos opciones.

-   Descargar e instalar Docker Desktop [desde la página de Docker](https://docs.docker.com/desktop/install/windows-install/). Opción recomendada.
-   Descargar e instalar Docker directamente en Linux

Una vez instalado Docker debemos editar un fichero de configuración. En WSL en ocasiones [hay problemas con los volúmenes compartidos](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly#ensure-volume-mounts-work) (por ejemplo pasa con la imagen de `postgis`).

Cuidado al copiar el siguiente comando. Son varias líneas que deben copiarse y pegarse a la vez.
```
echo '
[automount]
root = /
options = "metadata"
' >> /etc/wsl.conf
```

Después debemos volver a reiniciar Windows.


### Instalar docker directamente en Linux

```
wsl -u root
apt update
apt install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" > /etc/apt/sources.list.d/docker.list
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# si esto saca un mensaje de hello world todo ha ido bien
docker run hello-world
```



### Referencias

-   https://learn.microsoft.com/en-us/windows/wsl/install
-   https://learn.microsoft.com/en-us/windows/wsl/setup/environment
-   https://docs.docker.com/desktop/install/windows-install/

## Ejecutar un docker-compose.yml desde Docker Desktop

**ToDo**

## Ejecutar un docker-compose.yml desde la consola

En general un fichero de docker-compose.yml no estará aislado. Tendremos una carpeta con distintos ficheros (código, configuración, ...) uno de los cuales será el docker-compose.yml.

Tendremos que seguir las instrucciones previas de quien creo esa "carpeta" en caso de que sea necesario configuración previa.

Si no llega con navegar hasta la carpeta, abrir wsl en ella y ejecutar:

```
docker compose up -d
```

Esperamos un rato y podemos ejecutar un par de veces

```
docker compose logs
```

Cuando parezca que ya no hay información nueva en el log es que los contenedores estarán levantados.

Cuando queramos parar los contenedores:

```
docker compose down
```

Si queremos ver el estado de los contenedores podemos usar `docker ps`.