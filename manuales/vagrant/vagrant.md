# Vagrant

Algunos comentarios sobre como usar Vagrant. Pensados desde el punto de vista de alguien que use Windows y necesite importar un box para testear.

## Arrancar (y parar) máquina vagrant en Windows

-   Abrir el directorio donde está el fichero Vagrantfile
-   Shift + Clic Dcho dentro de la carpeta -> Abrir terminal

-   Para encender la máquina: `vagrant up`
-   Para parar la máquina: `vagrant halt`

## Importar máquina vagrant en Windows

-   [Referencia](http://www.sitepoint.com/getting-started-vagrant-windows/)

-   Crear un directorio nuevo
-   Shift + Clic Dcho dentro de la carpeta -> Abrir terminal

```
vagrant box add NOMBRE_CUALQUIERA path/to/mynew.box
vagrant init NOMBRE_CUALQUIERA
```

-   Editar el fichero Vagrantfile. O mejor renombrar el Vagrantfile y crear uno nuevo con este contenido

```
# Function to check whether VM was already provisioned
# https://stackoverflow.com/a/38203497/930271
def provisioned?(vm_name='default', provider='virtualbox')
    File.exist?(".vagrant/machines/#{vm_name}/#{provider}/action_provision")
end

Vagrant.configure(2) do |config|

    # no modificar esta línea de como esté en el fichero original
    # o copiar el valor del fichero original
    config.vm.box = XXXX

    config.vm.box_check_update = false

    if Vagrant.has_plugin?("vagrant-vbguest")
        # Disable it if problems with shared folders or guest additions appears
        # or if you want to speed up `vagrant up` a bit
        config.vbguest.auto_update = true
    end


    # Editar el mapeado de puertos entre el host y el guest según el proyecto
    # este es habitual
    config.vm.network "forwarded_port", guest: 80, host: 8000
    config.vm.network "forwarded_port", guest: 8080, host: 8080
    config.vm.network "forwarded_port", guest: 8081, host: 8081
    config.vm.network "forwarded_port", guest: 5432, host: 5432

    # Si queremos poder acceder al guest como si fuera un servidor en una red
    # descomentaremos la siguiente línea y pondremos la ip deseada. Así
    # podremos acceder a http://192.168.0.10/miweb o a http://localhost:8000/miweb
    # config.vm.network "private_network", ip: "192.168.0.10"

    config.vm.provider "virtualbox" do |vb|
        vb.gui = true
        vb.cpus = 1
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "85"]
        # Fijar la cantidad de memoria que queremos para el guest
        vb.memory = "1512"
    end

    # La carpeta donde está el Vagrantfile se comparte automáticamente con el guest
    # en /vagrant. Si queremos compartir carpetas adicionales, por ejemplo datos de
    # geoserver descomentaremos las siguientes líneas
    # config.vm.synced_folder "RUTA_ABSOLUTA_O_RELATIVA_EN_EL_HOST", "/var/lib/geoserver_data/data",
    #     disabled: !provisioned?(), # !provisioned? | false | true
    #     create: true,
    #     owner: "tomcat8",
    #     group: "tomcat8"
end
```

-   El box (fichero) path/to/mynew.box se puede borrar

## Exportar máquina vagrant

-   [Referencia](https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one)

```
vagrant package --output mynew.box
```

## Limpiando

Cada vez que añadimos un nuevo box mediante `vagrant box add` o al descargar un box que no está en el ordenador este se almacena en una ruta interna. Si creamos un nuevo guest a partir de un box ya existente usará el almacenado internamente, si lo creamos a partir de otro box lo copiará a las rutas internas. Sobre todo si exportamos/importamos boxes podemos acabar con un montón de espacio ocupado por boxes que no nos interesan.

```
# Nos da una lista de los boxes almacenados
vagrant box list
# Borrar un box almacenado, donde NAME es uno de los nombres que salen en `list`
# No afecta a los guest en sí
vagrant box remove NAME
```

Por cada `guest`, máquinas asociadas al Vagrantfile que tenemos en una carpeta, habrá una máquina virtual creada en Virtualbox, que podemos gestionar desde la interfaz de Virtualbox. Y una carpeta oculta `.vagrand.d` a la misma altura que el Vagrantfile. Cuando hacemos `vagrant halt` el `guest` se apaga pero permanece en el sistema. Para eliminarlo debemos usar `vagrant destroy`, o borrarlo en Virtualbox.

Otra opción es listar todas las máquinas y actuar en consecuencia:

```
# en cualquier carpeta
vagrant global-status
vagrant destroy NAME
```

## Conectar dos máquinas virtuales

[Referencia](http://stackoverflow.com/questions/1261975/addressing-localhost-from-a-virtualbox-virtual-machine)

Como conectar desde una máquina virtual (windows guest) a una base de datos, web,... que esté en otra máquina virtual.

Editar @C:\windows\system32\drivers\etc\hosts@ para añadir la línea:

```
10.0.2.2   outer
```

En el navegador, gvSIG, etc... en lugar de usar localhost o 127.0.0.1 se usará 10.0.2.2

## Instalación vagrant en Windows

-   Instalar virtualbox. [Descarga](https://www.virtualbox.org/wiki/Downloads)
-   Instalar vagrant. [Descarga](https://www.vagrantup.com/downloads.html)
