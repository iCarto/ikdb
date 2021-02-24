---
title: "Preparar entorno para proyectos Ionic con React"
author:
    - iCarto
    - Pablo Sanxiao
date: 2020-11-06
license: CC BY-SA 4.0
---

# Preparar entorno para proyectos Ionic con React"

**NOTA:** *Estas instrucciones están basadas en la configuración para MacOS, para otro sistema operativo puede ser necesario hacer pequeños ajustes.*

https://ionicframework.com


## Instalación base

Necesitamos tener instalado Node.js ya que usaremos npm para instalar paquetes.

Instalamos ionic CLI:

```
$ npm install -g @ionic/cli
```

**NOTA:** *Con la opción -g estamos instalando de forma global en el sistema*

Para crear la estructura de nuestra primera aplicación sólo tenemos que hacer:

```
$ ionic start myApp blank --type=react
```

Esto creará un directorio llamado *myApp* que contendrá la estructura de ficheros de nuestra aplicación. Podemos pasarle un par de plantillas de aplicación predefinidas.
En este caso estamos pasando la plantilla *blank* que creará una aplicación básica con una página en blanco sin más. Podemos pasar también como opciones:

- *tabmenu*: Creará una plantilla inicial de aplicación con 3 pestañas
- *sidemenu*: Creará una plantilla con un menú lateral

Para ver la lista completa de plantillas que podemos usar:

```
$ ionic start --list
```

Con *--type=react* estamos diciendo que cree una estructura de aplicación React. Podría también ser *angular* o *Vue*.

Para probar la aplicación en el navegador, podemos ejecutar:

```
$ ionic serve
```

## Preparar entorno para ANDROID

Como requisito previo necesitamos instalar [Android Studio y el Android SDK](https://developer.android.com/studio).

Además, tenemos que configurar nuestra línea de comandos y las variables de entorno para poder usarlo:

En MacOS tendremos que setear las siguientes variables de entorno:

```
$ export ANDROID_HOME=/Users/{{your user}}/Library/Android/sdk
$ export ANDROID_SDK_ROOT=/Users/{{your user}}/Library/Android/sdk
```

Establecer que se use la versión del JDK instalada para la ejecución

```
$ export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
```

Es recomendable hacerlo en el fichero *~/.bashrc, ~/.bash_profile* o similar.

Si vamos a querer usar el emulador de Android Studio, tenemos que configurar un dispositivo, según nuestras necesidades (Móvil o Tablet, versión de Android...). 
Para ello usaremos el AVD Manager del Android Studio, donde podremos configurar el tipo de dispositivo que queramos con las diferentes opciones.

Una vez que tenemos el Android Studio y el SDK instalado y configurado, tenemos que generar la estructura del proyecto nativo para Android, dentro de la carpeta de nuestra aplicación:

```
$ cd myApp
$ ionic capacitor add android
```

Si este comando nos da un error del estilo "*Capacitor could not find the web assets directory...*", ejecutar primero:

```
$ ionic build
```

Entre otras cosas, esto habrá creado un fichero *capacitor.config.json* en el directorio raíz de nuestra aplicación. Es conveniente editar al menos el *appid* que será el nombre que identificará
a nuestra aplicación.

Si en lugar de usar [capacitor](https://capacitorjs.com) para empaquetar, queremos usar Apache cordova, el comando sería:

```
$ cd myApp
$ ionic cordova prepare android
```

### Lanzar la aplicación Android

Para poder lanzar la aplicación a través de nuestro emulador, lo primero será empaquetarla de forma nativa, lo cual podemos hacer con el siguiente comando:

```
$ ionic ionic capacitor copy android
```

Una vez hecho esto ya podemos ir a nuestro Android Studio y lanzar el emulador para que se cargue la aplicación. Antes habremos tenido que crear un proyecto en Android Studio que apunte a la carpeta *android/app* que ionic habrá creado dentro del directorio de nuestra aplicación.

Si queremos tener un servidor que permita recargar automáticamente la aplicación android cada vez que hacemos cambios, podemos usar el siguiente comando:

```
$ ionic capacitor run android -l --host=YOUR_IP_ADDRESS
```

o, de forma alternativa:


```
$ ionic capacitor run android -l --external
```