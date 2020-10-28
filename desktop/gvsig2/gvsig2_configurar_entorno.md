# Creación del entorno.

Para cada versión de gvSIG con la que se trabaja trunk, 2.2, 2.3.1, 2.5.1 se crea un directorio que contendrá los repos, y un directorio que contendrá el workspace.

Se proveen ejemplos para la 2.5.1RC2

Nota: Es posible que haya que instalar algún plugin para eclipse que no esté contemplado en estas instrucciones. En caso de errores revisar el documento de links.instalacion.mas_o_menos_util

## Descargar repos

Las fuentes de gvSIG no están en un único repo. En función de que funcionalidades son necesarias en el plugin a desarrollar habrá que bajar más repos. Además habrá que descargar tags concretos del repo, los que estén asociados a la versión con la que estemos trabajando. La forma de determinar cual es la url del repo y cual es el tag es confusa. Mi sistema es tener un gvSIG-desktop descargado. Entrar en `gvSIG/extensiones` y mirar los nombres tratando de detectar cual es el que necesito. Se mira el fichero `package.info` que está dentro de la extensión y se busca la línea de `sources-url`. De ahí se extrae el cacho bueno. por ejemplo en:

```shell
gvSIG-desktop-2.5.1-3042-RC2-lin-x86_64/gvSIG/extensiones/org.gvsig.postgresql.app.mainplugin/package.info
```

la línea vale:

```shell
sources-url=https\://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.143/org.gvsig.postgresql.app/org.gvsig.postgresql.app.mainplugin
```

y para obtener el repo haremos

```shell
svn checkout https://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.143
```

La relación no es uno a uno, por ejemplo, estos tres directorios de extensiones se corresponden únicamente con un repositorio:

```shell
# org.gvsig.gdal.app.mainplugin
# org.gvsig.gdal.app.ogr.gml
# org.gvsig.gdal.app.ogr.mainplugin

svn checkout org.gvsig.gdal-1.0.106
```

Para ayudarnos en el proceso podemos usar un comando como:

```shell
grep -E -R --include 'package.info' '^sources-url=(.+)'
```

Cuando examinemos el `package.info` también es necesario evaluar la propiedad `dependencies`, y descargarlas.

Esta es la lista de instrucciones para los repos casi mínimos para trabajar en el plugin es.icarto.gvsig.sixhiara:

```shell
mkdir gvsig-desktop-2.5.1-3042-rc2 && cd gvsig-desktop-2.5.1-3042-rc2

svn checkout https://devel.gvsig.org/svn/gvsig-desktop/tags/org.gvsig.desktop-2.0.300
svn checkout https://devel.gvsig.org/svn/gvsig-gdal/tags/org.gvsig.gdal-1.0.106/
svn checkout https://devel.gvsig.org/svn/gvsig-geoprocess/org.gvsig.geoprocess/tags/org.gvsig.geoprocess-2.2.145
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.vectorfilterexpression.app.mainplugin/tags/org.gvsig.legend.vectorfilterexpression.app.mainplugin-1.0.114
svn checkout https://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.143/
svn checkout https://devel.gvsig.org/svn/gvsig-raster/org.gvsig.raster/tags/org.gvsig.raster-2.2.134
svn checkout https://devel.gvsig.org/svn/gvsig-raster/org.gvsig.raster.gdal/tags/org.gvsig.raster.gdal-2.2.122
svn checkout https://devel.gvsig.org/svn/gvsig-vectorediting/org.gvsig.vectorediting/tags/org.gvsig.vectorediting-1.0.129
svn checkout http\://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.complexlegend/tags/org.gvsig.complexlegend-1.0.120
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.quantitybycategory.app.mainplugin/tags/org.gvsig.legend.quantitybycategory.app.mainplugin-1.0.115
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.graduatedsymbols.app.mainplugin/tags/org.gvsig.legend.graduatedsymbols.app.mainplugin-1.0.114
# svn checkout https://devel.gvsig.org/svn/gvsig-jcrs/org.gvsig.projection.jcrs/tags/org.gvsig.projection.jcrs-2.1.137



# Estas dos antes las usábamos pero ahora no se donde están. los tags son los de la 2.3
svn checkout http://devel.gvsig.org/svn/gvsig-toolbox/org.gvsig.toolbox/tags/org.gvsig.toolbox-1.0.31
svn checkout http://devel.gvsig.org/svn/gvsig-tools/org.gvsig.tools/library/tags/org.gvsig.tools-3.0.92
```

## Configurar workspace para Eclipse

Si se tiene una instalación de eclipse funcionando para gvSIG 1, se recomienda descargar un nuevo eclipse actualizado para trabajar sobre gvSIG 2. En `eclipse.ini`:

-   Usar al menos `-Xmx1024m`
-   Correr con jdk 1.8 o superior

Se crea un workspace nuevo desde eclipse, por ejemplo: `workspace-gvsig-desktop-2.5.1-3042-rc2`

Para cada repo (aunque se puede hacer recursivo):

```
File -> Import -> Existing maven projects -> Aceptar todo
```

Usaremos una jdk 8 pero compilando para la 7. La versión que viene en la portable es la 8 pero muchos plugins están marcados como compatibles con la 7 así que esto es la forma más segura de trabajar.

```
Preferences -> Installed JREs -> Seleccionamos una jdk 1.8 por defecto
Preferences -> Installed JREs -> Execution Enviroment -> JavaSE-1.8
Preferences -> Compiler -> 1.8 y "Use default compliance settings"
```

En el documento `gvsig2_debug.md` se indica la configuración para debug.

## Compilar

-   El documento org.gvsig.desktop-2.0.278/maven-howto.rst da algunas pistas sobre como usar maven para compilar gvSIG
-   La primera vez que se hace el mvn, se crea el fichero `~/.gvsig-devel.properties`, con una línea similar a `gvsig.product.folder.path=/home/fpuga/development/gvsig-desktop-2.5.1-3042-rc2/org.gvsig.desktop/target/product` que da la ruta absoluta a donde se van a meter los binarios compilados. Si se cambia el entorno hay que borrar ese fichero o cambiar la ruta.

Para cada repo descargado (empezando por `org.gvsig.desktop-2.0.300`) hay que ejecutar:

```
mvn -Danimal.sniffer.skip=true -Dsource.skip=true -Dmaven.javadoc.skip=true -Dmaven.test.skip=true -DskipTests -Dgvsig.skip.downloadPluginTemplates=true install
```

Esto tarda bastante la primera vez. Se descarga internet y suelen petar cosas.

Cada vez que se haga un cambio, hay que compilar los repos que toquen con ese comando, o desde eclipse.

**Nota:** Como el comando es largo y difícil de recordar resulta conveniente crear un alias en `.bashrc`. Además aprovechamos el `alias` para fijar la versión de Java que queremos que use `mvn`. Sobre todo si la compilación nos da problemas relacionados con javafx debemos usar una versión de Java que lo tenga instalado.v

```
alias gvsigmvn='JAVA_HOME=~/bin/development/jdk1.8.0_102 mvn -Danimal.sniffer.skip=true -Dsource.skip=true -Dmaven.javadoc.skip=true -Dmaven.test.skip=true -DskipTests -Dgvsig.skip.downloadPluginTemplates=true install'
```

También resulta recomendable realizar esta configuración de maven en los "Run as..." de eclipse para lanzarla con: `Shift + Alt + x + m`

## Algunos problemas comunes:

> symbol gpgrt_lock_lock version GPG_ERROR_1.0 not defined in file libgpg-error.so.0

Puede ser debido a que esta librería que viene dentro de gvSIG y que es antigua no se lleve bien con las versiones de sistemas modernos (ie: Ubuntu 18.04). La solución puede ser eliminarla.

```
cd gvsig-desktop2.3.1-2501/org.gvsig.desktop/target/product
find -iname 'libgpg-error.so.0'
mv ./gvSIG/extensiones/org.gvsig.gdal.app.mainplugin/gdal/libgpg-error.so.0 /tmp/
./gvSIG.sh
```

> Plugin execution not covered by lifecycle configuration: org.codehaus.gmaven:gmaven-plugin:1.5:execute

Si sale este mensaje en los pom.xml se puede consultar este hilo:

-   http://osgeo-org.1560.x6.nabble.com/Problemas-compilando-gvSIG-td5284091.html

```
Preferences -> Maven -> Lifecycle Mappings  -> Open Workspace ....
```

Se cierra la ventana para poder editar el fichero (pestaña source), o bien se abre a mano la ruta que indica y se añade:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<lifecycleMappingMetadata>
  <pluginExecutions>
    <pluginExecution>
      <pluginExecutionFilter>
        <groupId>org.codehaus.gmaven</groupId>
        <artifactId>gmaven-plugin</artifactId>
        <versionRange>1.5</versionRange>
        <goals>
          <goal>execute</goal>
        </goals>
      </pluginExecutionFilter>
      <action>
        <ignore />
      </action>
    </pluginExecution>
  </pluginExecutions>
</lifecycleMappingMetadata>
```

> import junit can not be resolved

JUnit está definido en el pom padre. Pero en el código salen mensajes de que no se puede importar la librería.

Tras modificar el `Lifecycle Mappings`, se seleccionan los proyectos en el `Package Explorer` y en el menú contextual se selecciona `Maven -> Update Project`. Puede ser necesario iterar con `Clean`, `Refresh`, ...

> Problemas con nativas / gdal

Ver en la lista de correo hilo: "Actualizar a 2.5.1. Problema con nativas de gdal"
