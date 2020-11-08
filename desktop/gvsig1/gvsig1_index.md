# Configurar Entorno para gvSIG 1.12 / SIGA en un entorno de 64 bits.

## Repositorios

-   https://gitlab.com/icarto/siga. Código principal de SIGA. Incluye la mayoría de los plugins para gvSIG, scripts para generar portables y entorno. Lo usaremos también como carpeta para el Workspace
-   https://gitlab.com/icarto-private/icarto-gvsig. Repo que contiene una versión modificada de gvSIG 1.12. Es el repo a usar para trabajar con gvSIG en proyectos iCarto. Los cambios que se hagan en el core de gvSIG en otros proyectos y que sean "comunes" deberían subirse a este repo también.
-   https://gitlab.com/icarto/es.icarto.gvsig.commons. Único plugin que no está incluido directamente dentro de SIGA.

-   `SIGA_FOLDER` y `GVSIG1_FOLDER` se puede setear al valor deseado

```
GVSIG1_FOLDER=~/development/gvsig1
mkdir -p "${GVSIG1_FOLDER}"
cd "${GVSIG1_FOLDER}"
git clone git@gitlab.com:icarto/es.icarto.gvsig.commons.git
git clone git@gitlab.com:icarto-private/icarto-gvsig.git

SIGA_FOLDER=~/development/audasa
mkdir -p "${SIGA_FOLDER}"
cd "${SIGA_FOLDER}"
git clone git@gitlab.com:icarto/siga.git
```

## Instalar jdk1.6.0_45 y librerías nativas

gvSIG se ejecuta bajo una jvm 1.6. Eclipse se puede ejecutar con su propia jvm

Descargar la última versión de 32 bits de la jdk6 (jdk1.6.0_45) desde la [página de oracle](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase6-419409.html#jdk-6u45-oth-JPR). En caso de no estar disponible para descarga, solicitar a iCarto.

Ejecutar el binario y ponerlo en algún sitio como `~/bin/development/jdk1.6.0_45`

```
JDK_OWN_PATH=~/bin/development/jdk1.6.0_45
```

En caso de usar un jdk proporcionado por iCarto se instalara de la siguiente forma (y no es necesario instalar jai):

```
cp jdk1.6.0_45.iCarto.tgz $(dirname "${JDK_OWN_PATH}")
cd $(dirname "${JDK_OWN_PATH}")
tar xz --preserve-permission --file=jdk1.6.0_45.iCarto.tgz
```

### Instalar jai

**Instalar jai en todos los jdk descargados**

http://docs.geoserver.org/latest/en/user/production/java.html#installing-native-jai-on-linux

```
$ sudo cp jai-1_1_3-lib-linux-i586-jdk.bin "${JDK_OWN_PATH}"
$ cd "${JDK_OWN_PATH}"
$ sudo sh jai-1_1_3-lib-linux-i586-jdk.bin  # accept license
$ sudo rm jai-1_1_3-lib-linux-i586-jdk.bin
```

**Instalar jai_imageio en todos los jdk descargardos**

http://docs.geoserver.org/latest/en/user/production/java.html#installing-native-jai-on-linux

```
sudo cp jai_imageio-1_1-lib-linux-i586-jdk.bin "${JDK_OWN_PATH}"
$ cd "${JDK_OWN_PATH}"
$ sudo su
$ export _POSIX2_VERSION=199209
$ sh jai_imageio-1_1-lib-linux-i586-jdk.bin  # accept license
$ rm ./jai_imageio-1_1-lib-linux-i586-jdk.bin
$ exit
```

### Instalar librerías nativas

Para hacer el desarrollo más sencillo es conveniente instalar a nivel sistema algunas librerías de 32bits. En realidad en cierto momento estas librerías se podrían incluír en el propio repo de gvSIG pero para evitar posibles problemas se hace a nivel sistema y que el LIBRARY_PATH las acabe llamando si es necesario.

Algunas de estas librerías pueden no ser necesarias. Podrían ir instalándose a medida que se encontraran errores.

```
sudo apt-get update

sudo apt-get install libxext6:i386
sudo apt-get install libxtst6:i386
sudo apt-get install libxi6:i386
sudo apt-get install libxml2:i386
```

* En ocasiones puede ser necesario eliminar el fichero `libm.so.6` que está dentro de la carpeta `native` del repo/workspace. No hacer esto si no hay problemas.
* En ocasiones puede ser necesario ejecutar algo como esto. No hacer esto si no hay problemas

```
cd bin/gvSIG/extensiones/com.iver.cit.gvsig
ln -s mod_spatialite.so.7.1.0 mod_spatialite.so.7.1.0.so
```


## Configurar Eclipse

Versión de eclipse recomendada. [Luna SR2](https://www.eclipse.org/downloads/packages/release/luna/sr2) corriendo sobre una jdk 1.7 de Oracle.

* Nuevo Workspace. "${SIGA_FOLDER}"/siga
* Importar proyectos. "${SIGA_FOLDER}"/siga
* `cd ${SIGA_FOLDER}"/siga; ln -s "${GVSIG1_FOLDER}"/es.icarto.gvsig.commons.git`
* Importar proyecto "${SIGA_FOLDER}"/es.icarto.gvsig.commons.git

* Window -> Preferences -> Java -> Installed JREs -> Importar "${JDK_OWN_PATH}"
* Window -> Preferences -> Java -> Compiler -> Todo en 1.6
* Workspace Encoding ISO-8859-1
* Debug Configurations. Importar Launch Configuration de server/other-settings/gvSIG_Linux.launch
* Java -> Code Style; Java -> Editor -> Save Actions. Dejar configuración por debajo. Bajo discusión como gestionar esto. Tratar de no modificar mucho lo existente, para que sea más fácil el code review.
* Marcar build automatically

## Construír SIGA

* En caso de problemas con algún repo al compilar. Asegurarse de que todos los proyectos están con las reglas del workspace. Para cada proyecto Properties -> {Code Style y Compiler} -> SIN reglas específicas para el proyecto

* Marcar todos los proyectos y F5 (Refrescar)
* Clean all
* Botón derecho sobre create-gvsig-portable/deploy.xml -> Run as -> Ant build... -> Marcar únicamente "makeTestEnviroment" -> Run

* Repetir los pasos variando orden hasta que no hay errores

**Otros trucos para resolver el problema**

* Abrir y cerrar eclipse
* Cuando un proyecto tiene problemas, el resto de proyectos que lo tengan en el build path también pueden aparecer con aspas. Hay que identificar el proyecto padre con problemas y trabajar con ese. Una vez resuelto clean all, ...
* Probar a cerrar proyecto y derivados. Abrir proyecto y no derivados. Resolver problemas. Abrir resto de proyectos, ...
