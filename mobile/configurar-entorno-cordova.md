---
title: "Preparar entorno para proyectos con Apache Cordova"
author:
    - iCarto
    - Pablo Sanxiao
date: 2019-08-29
license: CC BY-SA 4.0
---

# Preparar entorno para proyectos con Apache Cordova

**NOTA:** *Estas instrucciones están basadas en la configuración para MacOS, para otro sistema operativo habrá que hacer pequeños ajustes.*

https://cordova.apache.org

## Instalación base

Necesitamos tener instalado Node.js ya que usaremos npm para instalar paquetes.

Instalamos cordova:

```
$ npm install -g cordova
```

Creamos nuestro primer proyecto

```
$ cordova create MyApp
```

Añadimos una plataforma

```
$ cd MyApp
$ cordova platform add browser
```

Con esto le indicaremos para que plataformas queremos que sea compatible nuestra aplicación. Por defecto para que funcione simplemente en una navegador web nos llega con esto. Para otras plataformas, Androi o iOS, necesitaremos además instalar otras cosas, como veremos más adelante.

Ejectuar nuestra App

```
$ cordova run browser
```

## Preparar entorno para ANDROID

Antes de nada necesitamos instalar una serie de dependencias:

* Java JDK
* Gradle
* Android SDK (Android Studio)

Para ejecutar la versión de nuestra aplicación para ANDROID

```
$ cordova run android
```

### Algunos problemas de configuración

Algunos problemas comunes de configuración relacionados con las variables de entorno y que pueden variar con el SO. Aquí se muestran los de MacOS.

Setear variables de entorno correctas:

```
$ export ANDROID_HOME=/Users/{{your user}}/Library/Android/sdk
$ export ANDROID_SDK_ROOT=/Users/{{your user}}/Library/Android/sdk
```

Establecer que se use la versión del JDK instalada para la ejecución

```
$ export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
```

Problemas al ejecutar el emulador con: cordova run android

```
$ export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$PATH
```

Para ejecutar el emulador, cordova hace uso del que tengamos definido por defecto en Android Studio, aunque también le podemos pasar el nombre si tenemos varios. A veces no es capaz de encontrarlo y por eso es necesario ajustar el path.

## Instalar Plugins

Cordova tiene un sistema de plugins que nos permiten añadir funcionalidad a nuestra aplicación.

Para instalar plugins:

```
$ cordova plugin add <nombre-plugin>
```

Algunos plugins útiles:

* cordova-plugin-storage (Trabajar con bases de datos SQLite)
* cordova-plugin-file (Copiar ficheros auxiliares de nuestra app al dispositivo)
* cordova-plugin-dbcopy (Copiar bases de datos al dispositivo)
* ...

## Debugging

Una forma sencilla de hacer debug en nuestra aplicación es a través de Chrome. Podemos usar las opciones de las Chrome Developer Tools y por ejemplo usar la consola de Javascript para debuggear nuestra app cordova como si fuese una webapp normal.

* Abrir Chrome Developer Tools
* More Tools -> Remote devices
* Seleccionar nuestro dispositivo Android SKD -> Inspect
