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

-   Editar el fichero Vagrantfile. REVISAR SI ESTO ES NECESARIO.

```
  # no modificar esta línea de como esté en el fichero original
  config.vm.box = XXXX


  config.vm.box_check_update = false


  config.vm.network "forwarded_port", guest: 80, host: 8008
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  config.vm.network "forwarded_port", guest: 443, host: 4433
  config.vm.network "forwarded_port", guest: 8443, host: 8433

  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "1256"
  end

end
```

-   El fichero path/to/mynew.box se puede borrar

## Exportar máquina vagrant

-   [Referencia](https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one)

```
vagrant package --output mynew.box
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
