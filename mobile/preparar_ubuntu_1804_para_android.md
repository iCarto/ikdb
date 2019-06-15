# Preparar Ubuntu 18.04 para desarrollo en Android

Ya vayas a desarrollar aplicaciones híbridas, PWAs o Nativas para Android es útil tener instalado un montón de software, aplicaciones y librerías. Entre ellas:

* Aceleración por hardware del emulador con KVM si tu equipo lo soporta para que el emulador no vaya increíblemente lento
* Los SDK de Android
* El Android Studio
* Las imágenes de los dispositivos a emular
* ...

Ten en cuenta que está guía está escrita por y para gente novata en el desarrollo para dispositivos móviles. Pero "It work for us". Ten en cuenta la fecha de la última actualización (2019-06-04) para compatibilidad de versiones.

Lo primero asegurate de que tienes unos 5GB de espacio libre porqué te harán falta. Los enlaces a la documentación de Android consultalos en Inglés. Los de castellano parecen desactualizados.

## Aceleración por hardware del emulador

Primero hay que comprobar [si el hardware lo soporta](https://help.ubuntu.com/community/KVM/Installation). Una forma sencilla es:

```bash
sudo apt install cpu-checker
kvm-ok 
```

que debería presentar una salida de este tipo:

```bash
INFO: /dev/kvm exists
KVM acceleration can be used
```

En ese caso instalamos los paquetes necesarios y damos de alta a nuestro usuario en los grupos adecuados:

```
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
sudo adduser $USER kvm
```

Para que añadir nuestro usuario al grupo tenga efecto debemos reloguearnos. Un truco sencillo es ejecutar en el terminal `su $USER`. Los comandos que ejecutemos en ese terminal serán con el usuario relogueado y por tanto con permisos de acceso a `/dev/kvm`. Es desde aquí desde donde lanzaremos `android-studio`.

Como chequeo adicional podemos comprobar que la salida del siguiente comando no produce error:

```bash
$ virsh list --all
 Id    Name                           State
----------------------------------------------------
```

o si ya hemos instalado el SDK y configurado las variables de entorno

```bash
$ emulator-check accel
accel:
0
KVM (version 12) is installed and usable.
accel
```

## Instalar Android Studio y Android SDK

Hay muchas formas de hacerlo. Una relativamente sencilla es mediante [Ubuntu Make](https://wiki.ubuntu.com/ubuntu-make). En el momento de escribir esta guía necesitas usar el daily ppa, el resto de paquetes no funcionan.

```bash
sudo add-apt-repository ppa:lyzardking/ubuntu-make # hace el apt-get update el mismo
sudo apt-get install ubuntu-make
umake android
# Aceptar la licencia
```

A continuación lo lanzamos con `android-studio`. Y creamos un proyecto nuevo con algún template que ya tenga algo. De este modo tendremos una aplicación básica para probar que el emulador funciona. Tardará un buen rato en configurar y compilar todo.

Si como template escogemos la actividad de mapa debemos seguir las instrucciones de `google_maps_api.xml` para generar una API Key.

Por defecto Android Studio descarga el SDK para Android 9.0 (API Level 28). Muchos frameworks pueden no estar todavía preparados para esta versión. Así que en `Settings` buscamos `SDK` y en la lista seleccionamos Android 8.1 (API Level 27).

Anotamos también la localización del SDK, habitualmente `$HOME/Android/Sdk`



## Variables de Entorno

La instalación anterior de Android Studio probablemente haya modificado `$HOME/.profile` añadiendo algo como esto:

```bash
# Ubuntu make installation of Ubuntu Make binary symlink
PATH=/home/fpuga/.local/share/umake/bin:$PATH

# Ubuntu make installation of Android Studio
export ANDROID_HOME=/home/fpuga/.local/share/umake/android/android-studio
export ANDROID_SDK=/home/fpuga/.local/share/umake/android/android-studio
```

Esos valores no son correctos para nuestras configuraciones habituales. Además dado que el desarrollo en Android es más bien ocasional queremos evitar polucionar el sistema con esas variables de entorno. Los valores anteriores se substituyen por los indicados a contituación en el propio `.profile` o se crea un nuevo fichero `load_android_envars.sh` con este contenido:

```bash
# load_android_envars.sh
# for android and cordova development

export ANDROID_HOME=$HOME/Android/Sdk/
export ANDROID_SDK_ROOT=$HOME/Android/Sdk/
export JAVA_HOME=$HOME/bin/development/jdk1.8.0_102/
export PATH=$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$HOME/.local/share/umake/bin/:$PATH
```

que cargaremos cuando vayamos a desarrollar en Android mediante `source load_android_envars.sh`. 

Se puede comprobar que todo está correcto ejecutando `adb --version`


## Configurar un ADV y probar el emulador

Android Virtual Device (AVD) es el [emulador por defecto](https://developer.android.com/studio/run/managing-avds) de Android. Lo podemos abrir desde `Tools -> AVD Manager`. Por defecto tendremos un Nexus 5, semi-configurado. Si pulsamos en `Download` bajara la imagen del dispositivo para Android 9. En lugar de eso pulsamos en el botón de `Edit this AVD` y en `Change` del sistema operativo para descargar "Android 8.1 (Google APIs) API Level 27".

En la parte de Graphics si el equipo lo soporta pondremos aceleración por Hardware.

Cuando esté listo, lanzamos el emulador desde el botón de `Launch`. En general el emulador es bastante lento y ralentiza mucho el sistema. Pero al menos nos permite comprobar si está bien instalado.


## Probar en un dispositivo de verdad

En este punto también es útil comprobar si el proyecto de ejemplo funciona en un dispositivo de verdad.

Para ello comprobamos en [el dispositivo está configurado para desarrollo](http://developer.android.com/tools/device.html#setting-up) y permitimos el "USB debugging?" cuando pregunte. Básicamente llega con seguir las [instrucciones de la página de Android](https://developer.android.com/studio/run/device). El resumen:

* Habilitar `USB Debugging` en el dispositivo
* Modificar `AndroidManifest.xml` y `build.gradle (Module:App)`
* Correr `adb devices` y aceptar la clave RSA en el dispositivo.
* `Run -> Run`y seleccionamos el dispositivo.
* En el dispositivo debería abrirse automáticamente la aplicación de ejemplo que hayamos creado.

## Otros emuladores

El emulador de android es bastante lento, aún así es la mejor opción a la hora de hacer desarrollo. Aquí se presentan algunas alternativas por si fueran de utilidad en algún caso especial.

* [Anbox](http://www.linuxandubuntu.com/home/anbox-runs-android-in-your-linux-without-emulation/) no es un emulador. Es un sistema operativo android corriendo dentro de un container (LXC). Las app se instalan dentro del container mediante `adb`. No es lo más comodo para depurar pero tiene mejor rendimiento que un emulador, por eso se incluye aquí.
* [Genymotion](https://www.genymotion.com/). Es considerado el mejor. La versión desktop 300€/usuario-año. La versión cloud 0.5€/h
* [Andy OS](https://www.andyroid.net/). Es una forma de sincronizar el móvil con el ordenador más que otra cosa. Por ejemplo recibir los watsapp, ... en el desktop en lugar de el teléfono. Controlar el ordenador desde el móvil, ...
* [Android-x86](https://www.android-x86.org/). Port de Android para plataformas x86. Permitiría rular "algo como Android" en un VirtualBox por ejemplo.
* [Archon](https://github.com/vladikoff/chromeos-apk). Instala aplicaciones Android en Chrome.
