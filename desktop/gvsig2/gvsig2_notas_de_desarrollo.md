# Variables de interés al trabajar con gvSIG Desktop

**appName**. Es el primer parámetro que recibe por línea de parámetros. Habitualmente toma el valor "gvSIG". Se usa en distintos puntos de la aplicación, para generar paths y otras operaciones parecidas

**appHomeDir** (`getAppHomeDir()` y `getApplicationHomeFolder()`). Es una referencia al directorio de configuración de gvSIG. Esta ruta será habitualmente del tipo `/home/fpuga/gvSIG`

```java
appHomeDir = System.getProperty(appName + ".home");
if (appHomeDir == null) {
    appHomeDir = System.getProperty("user.home");
}

appHomeDir += File.separator + appName;
```

**getAplicationFolder()**. Usa System.getProperty("user.dir") para determinar la ruta desde la que se ha arrancado gvSIG. En un entorno de debug, debe setearse este parámetro para que todo funcione correctamente. Un valor típico para esta propiedad sería: `/var/development/gvsig-desktop2.3.1-2501/org.gvsig.desktop-2.0.157/target/product` siendo esta la ruta donde se encuentra el fichero `gvSIG.sh`

Idealmente en debugging deberías coger este valor de ~/.gvsig-devel-properties

En la configuración de debugging, en la pestaña Arguments, pinchamos en la zona de "Working Directory" seleccionaremos "Other" y escribiremos: `${workspace_loc:org.gvsig.desktop/target/product}`

https://stackoverflow.com/questions/16239130/java-user-dir-property-what-exactly-does-it-mean

```
public static File getApplicationFolder() {
    // TODO: check if there is a better way to handle this
    return new File(System.getProperty("user.dir"));
}



# Logging

gvSIG usa sl4j como wrapper para el log pero la librería de verdad que usa es log4j. El path al fichero de configuración está hardcodeado y por defecto (tiene pinta de bug) apunta (en desarrollo) a:

```

/target/product/lib/log4j.properties

```

Para jugar con la verbosidad del log se puede copiar `/target/product/log4j.properties` a `/target/product/lib/log4j.properties` y cambiar los INFO por WARN.


# Eliminar menús, deshabilitar extensiones, ...

La forma más sencilla de deshabilitar un menú o extensión es editar el `config.xml` del plugin. Puede mantenerse una estructura de directorios como la de `es.icarto.gvsig.sixhiara/portabale` donde ciertos `config.xml` se sobreescriban cuando se distribuye una versión portable.

Esta opción es sencilla de implementar, y tiene buen rendimiento, puesto que hay código que no llegaré a ejecutarse nunca durante la inicialización.

El mayor problema será al actualizar a una nueva versión de gvSIG donde deberemos comparar los `config.xml` para añadir las nuevas funcionalidades.
```
