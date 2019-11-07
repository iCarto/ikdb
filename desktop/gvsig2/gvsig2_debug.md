# Debugging con Eclipse en gvSIG 2

Hay dos formas de hacer debugging desde eclipse de gvSIG 2.

-   Remote Java Aplication. El sugerido como el mejor en la documentación oficial de desarrollo
-   Java Aplication. El que estamos usando en iCarto como preferido

## Remote Java Aplication

Una versión funcional de gvSIG se arranca desde la consola pasándole unos parámetros para permitir el debug remoto desde Eclipse.

Para configurarlo, `Debug Configurations` se crea una `Remote Java Aplication`:

-   Nombre: Remote gvSIG
-   Project: org.gvsig.andami
-   Connection: Socket Attach
-   Host: localhost
-   Port: 8765

Para ejecutar y debuggear:

```
cd gvsig-desktop2.3.1-2501/org.gvsig.desktop/target/product
./gvSIG.sh --debug --pause
```

Esto arranca gvSIG que hace unas cosas y se queda parado. Luego se va a eclipse y se lanza el "Remote gvSIG". De este modo quedan conectados.

### Problemas

-   Demasiados pasos para lanzar el debug
-   No se pueden ver en los errores en la consola de Eclipse

## Java Aplication

Consiste en lanzar directamente el método `main` de gvSIG desde Eclipse, de este modo podemos relanzar la aplicación con F11, ver la salida en la consola, ...

El arranque de gvSIG es un poco "triki". Para entenderlo debe seguirse el script `gvSIG.sh` para entender como gvSIG genera las variables de entorno, classpath, library path y pasa parámetros a la aplicación.

Puede haber algunos problemas ocultos usando este modo de depuración por lo que en caso de problemas se puede revisar este script y actualizar la configuración.

En `Debug Configurations` creamos una nueva `Java Application`

-   Nombre: `Debug gvSIG`
-   Project: `org.gvsig.andami.updater`
-   Main class: `org.gvsig.andamiupdater.Updater`
-   Program arguments: gvSIG gvSIG/extensiones
-   VM arguments: `-Xms256M -Xmx1024M -Djava.library.path=${workspace_loc:org.gvsig.desktop/target/product/gvSIG/extensiones/org.gvsig.gdal.app.mainplugin/gdal}`
-   Project execution enviroment: `java 1.8`
-   Classpath: Pinchamos en "User Entries" y luego en "Add Jars". Navegamos hasta "org.gvsig.desktop/target/product/lib". Seleccionamos todo el contenido y aceptamos. Seleccionamos todos los jar añadidos y le damos a "Up" hasta colocarlos todos como primera entrada de "User Entries".
-   Enviroment. Añadimos las siguientes variables
    -   `GDAL_DATA=${workspace_loc:org.gvsig.desktop/target/product/gvSIG/extensiones/org.gvsig.gdal.app.mainplugin/gdal/data}`
    -   `GVSIG_APPLICATION_NAME=gvSIG`
    -   `LD_LIBRARY_PATH=$LD_LIBRARY_PAT:${workspace_loc:org.gvsig.desktop/target/product/gvSIG/extensiones/org.gvsig.gdal.app.mainplugin/gdal}`

### Problemas

-   Cada vez que añadamos un nuevo plugin debemos tener cuidado de si añade nuevos jars a "lib" o si contiene un fichero `startup.sh` que en cierto modo cambie la configuración de aranque.
