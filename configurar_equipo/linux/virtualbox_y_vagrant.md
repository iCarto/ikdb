La combinación de Virtualbox + Vagrant es muy potente para poder levantar rápidamente entornos de desarrollo similares a los de producción sin necesidad de cada persona del equipo invierta mucho tiempo en configurarlo.

Virtualbox también permite crear máquinas virtuales con Microsoft Windows (si tienes una licencia adecuada). Estás máquinas se puede usar para probar la aplicación en los distintos posibles entornos que tengan los usuarios.

En esta miniguía se dan también las instrucciones para que en los `guest` Windows que se creen funcione "hardware" como el micrófono o la cámara, lo que permitirá usar un equipo Linux para participar en Video-Conferencias de más de dos usuarios a través de Skype o aplicaciones parecidas que no tienen un buen soporte en Windows.

Algunas de estas instrucciones pueden ser "excesivas" o haber sido simplificadas con actualizaciones, pero está comprobado que funcionan en Ubuntu 18.04.

## Virtualbox

La recomendación es instalar desde los repositorios propios de la distribución. A pesar de tener versiones menos actualizadas que la oficial evitan problemas al usar extensiones como `virtualbox-guest-x11` (para compartir el clipboard), ...

```
# Substituir por el usuario deseado
USER=$(whoami)

sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-dkms

# Si no estamos en un entorno de servidor seguir con estas instrucciones
sudo apt install virtualbox-guest-x11
sudo usermod -a -G vboxusers $USER
sudo usermod -a -G video,audio,pulse-access $USER
sudo usermod -a -G audio pulse
```

Ciertas funcionalidades de Virtualbox sólo están habilitadas a través de la instalación de las [guest additions](https://www.virtualbox.org/manual/ch04.html#idm1936).

Para cada máquina virtual se cree (importe, agregue, ...) hay que instalar **dentro** del guest las `guest additions` (en Vagrant puede automatizarse):

-   Encender la máquina virtual
-   `Dispositivos ópticos` -> `montar una nueva iso` -> En `/usr/share/virtualbox` seleccionr VBoxGuestAdditions.iso.
-   En caso de que no se ejecute automáticamente el cd/iso, ejecutaremos el .exe desde el explorador de archivos.

Con estas instrucciones tendremos una máquina virtual que soporte webcam, audio, usbs, portapapeles bidireccional (activar en la configuración de cada máquina), ...

### Actualizar Virtualbox

Virtualbox se actualiza de forma normal a través del sistema de paquetes del sistema.

Las `guest additions` habrá que actualizarlas a mano (vagrant es una excepción) para cada máquina virtual. Aunque en general no será necesario actualizar salvo cambios de versiones mayores en Virtualbox.

Usando vagrant una forma sencilla de mantener el "guest addition" actualizado es usar el plugin [vbguest](https://github.com/dotless-de/vagrant-vbguest)

## Vagrant

La versión de los repositorios suele estar _demasiado_ anticuada, por lo que es mejor el ppa oficial de hashicorp

```

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

vagrant version
```

En principio no es necesaria ninguna configuración, pero hay varios plugins útiles que pueden ser instalados:

```
# Actualiza `guest additions` en cada guest
# https://github.com/dotless-de/vagrant-vbguest
vagrant plugin install vagrant-vbguest
```

### Actualizar Vagrant

-   Se actualiza automáticamente desde el repositorio oficial
-   Los plugins se actualizan mediante `vagrant plugin update`
-   Aprovechar para eliminar boxes desactualizados `vagrant box prune`

### Plugins que no se deben usar

-   vagrant-cachier. Da más problemas de los que soluciona. Es continuo el problema de permisos, y errores aleatorios.
