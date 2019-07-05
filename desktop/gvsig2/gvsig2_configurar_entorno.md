# Creación del entorno.

Para cada versión de gvSIG con la que se trabaja trunk, 2.2, 2.3.1, se crea un directorio que contendrá los repos, y un directorio que contendrá el workspace. 

Se proveen ejemplos para la 2.3.1

Nota: Es posible que haya que instalar algún plugin para eclipse que no esté contemplado en estas instrucciones. En caso de errores revisar el documento de links.instalacion.mas_o_menos_util

## Descargar repos

Las fuentes de gvSIG no están en un único repo. En función de que funcionalidades son necesarias en el plugin a desarrollar habrá que bajar más repos. Además habrá que descargar tags concretos del repo, los que estén asociados a la versión con la que estemos trabajando. La forma de determinar cual es la url del repo y cual es el tag es confusa. Mi sistema es tener un gvSIG-desktop descargado. Entrar en gvSIG/extensiones y mirar los nombres tratando de detectar cual es el que necesito. Se mira el fichero `package.info` que está dentro de la extensión y se busca la línea de `sources-url`. De ahí se extrae el cacho bueno. por ejemplo en:

```
gvSIG-desktop-2.3.1-2501-final-lin_ubuntu_16.04-x86_64/gvSIG/extensiones/org.gvsig.postgresql.app.mainplugin/package.info
```

la línea vale:

```
sources-url=https\://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.63/org.gvsig.postgresql.app/org.gvsig.postgresql.app.mainplugin
```

y para obtener el repo haremos `svn checkout https://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.63`

Esta es la lista de instrucciones para los repos casi mínimos para trabajar en el plugin es.icarto.gvsig.sixhiara:

```
mkdir gvsig-desktop2.3.1-2501 && cd gvsig-desktop2.3.1-2501

svn checkout http://devel.gvsig.org/svn/gvsig-desktop/tags/org.gvsig.desktop-2.0.157
svn checkout http://devel.gvsig.org/svn/gvsig-postgresql/tags/org.gvsig.postgresql-2.0.63
svn checkout http://devel.gvsig.org/svn/gvsig-gdal/tags/org.gvsig.gdal-1.0.32
svn checkout https://devel.gvsig.org/svn/gvsig-geoprocess/org.gvsig.geoprocess/tags/org.gvsig.geoprocess-2.2.66
svn checkout http://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.vectorfilterexpression.app.mainplugin/tags/org.gvsig.legend.vectorfilterexpression.app.mainplugin-1.0.37
svn checkout https://devel.gvsig.org/svn/gvsig-raster/org.gvsig.raster/tags/org.gvsig.raster-2.2.52
svn checkout https://devel.gvsig.org/svn/gvsig-raster/org.gvsig.raster.gdal/tags/org.gvsig.raster.gdal-2.2.46
svn checkout http://devel.gvsig.org/svn/gvsig-toolbox/org.gvsig.toolbox/tags/org.gvsig.toolbox-1.0.31
svn checkout http://devel.gvsig.org/svn/gvsig-tools/org.gvsig.tools/library/tags/org.gvsig.tools-3.0.92
svn checkout http://devel.gvsig.org/svn/gvsig-vectorediting/org.gvsig.vectorediting/tags/org.gvsig.vectorediting-1.0.48

cd ..

mkdir gvsig2-plugins && cd gvsig2-plugins

git clone git@github.com:iCarto/es.icarto.gvsig.commons.git && cd es.icarto.gvsig.commons && git checkout gvsig2
git clone git@github.com:cartolab/extCopyFeatures.git && cd extCopyFeatures && git checkout gvsig2
git clone git@github.com:iCarto/extDBConnection.git && cd extDBConnection && git checkout gvsig2
git clone git@github.com:iCarto/extELLE.git && cd extELLE && git checkout gvsig2
git clone git@github.com:navtable/navtable.git && cd navtable && git checkout gvsig2
git clone git@github.com:navtable/navtableforms.git && cd navtableforms && git checkout gvsig2

cd ..
cd sixhiara

git clone git@github.com:iCarto/sixhiara.git && cd sixhiara && git checkout gvsig2
```

## Configurar workspace

Se crea un workspace nuevo desde eclipse, por ejemplo: workspace-gvsig-desktop2.3.1-2501

Para cada repo (en realidad es recursivo, si se hace para un directorio pilla los subdirectorios, pero yo prefiero hacerlo uno a uno)

File -> Import -> Existing maven projects -> Aceptar todo

En debug configurations se crea una "Remote Java Aplication":
* Nombre: Remote gvSIG
* Project: org.gvsig.andami
* Connection: Socket Attach
* Host: localhost
* Port: 8765

## Compilar

* El documento org.gvsig.desktop-2.0.157/maven-howto.rst da algunas pistas sobre como usar maven para compilar gvSIG
* La primera vez que se hace el mvn, se crea el fichero `~/.gvsig-devel.properties`, con una línea similar a `gvsig.product.folder.path=/home/fpuga/development/gvsig-desktop2.3.1-2501/org.gvsig.desktop/target/product` que da la ruta absoluta a donde se van a meter los binarios compilados. Si se cambia el entorno hay que borrar ese fichero o cambiar la ruta.

Para cada repo descargado (empezando por org.gvsig.desktop-2.0.157) hay que ejecutar:

```
mvn -Danimal.sniffer.skip=true -Dsource.skip=true -Dmaven.javadoc.skip=true -Dmaven.test.skip=true -DskipTests -Dgvsig.skip.downloadPluginTemplates=true install
```

Esto tarda bastante la primera vez. Se descarga internet y suelen petar cosas.

Cada vez que se haga un cambio, hay que compilar el repo(s) que toquen con ese comando, o desde eclipse.

## Aplicar parches

En la versión 2.3.1-2501 hay varios parches reportados. Pero es necesario aplicarlos al workspace antes de poder trabajar. En `es.icarto.gvsig.sixhiara/portable/common/patches` están los jar compilados. Lo más fácil es sobreescribir los jar originales con estos ya compilados (y reaplicar cada vez que haya un cambio)

```
bash apply_patches SVN_PATH/target/product
```

En `es.icarto.gvsig.sixhiara/portable/common/patches/modified_files` están los ficheros java modificados, habría que sobreescribir los originales. Ver fichero de `notas.txt` en ese directorio. No se han generado diffs.

## Ejecutar y debug

```
cd gvsig-desktop2.3.1-2501/org.gvsig.desktop/target/product
./gvSIG.sh --debug --pause
```

Esto arranca gvSIG que hace unas cosas y se queda parado. Luego se va a eclipse y se lanza el "Remote gvSIG". De este modo quedan conectados.


## Algunos problemas comunes:

> symbol gpgrt_lock_lock version GPG_ERROR_1.0 not defined in file libgpg-error.so.0

Puede ser debido a que esta librería que viene dentrod e gvSIG y que es antigua no se lleve bien con las versiones de sistemas modernos (ie: Ubuntu 18.04). La solución puede ser eliminarla.

```
cd gvsig-desktop2.3.1-2501/org.gvsig.desktop/target/product
find -iname 'libgpg-error.so.0'
mv ./gvSIG/extensiones/org.gvsig.gdal.app.mainplugin/gdal/libgpg-error.so.0 /tmp/
./gvSIG.sh
```


