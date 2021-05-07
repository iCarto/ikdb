# Trabajando con .gvp

En ProjectExtension.readProject se hace una validación del elemento `VERSION` que hay en el .gvp contra el valor `version=1.12.0` que haya en el fichero `package.info` que esté en el plugin en el que esté la clase `FPanelAbout` (que sería `appgvSIG`, `com.iver.cit.gvsig`). En caso de que no coincida simplemente se loguea un aviso y se continúa con la carga.

```xml
<property key="VERSION" value="1.12.0"/>
```

En caso de cambios en la gestión de .gvp hay que actualizar esta validación de la versión.
