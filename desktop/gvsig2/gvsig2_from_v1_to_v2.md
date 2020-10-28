Esta es una guía rápida e informal para migrar proyectos de gvsig1 a gvsig2. El objetivo no es crear o migrar un plugin de acuerdo al estándar de gvSIG sino tenerlo funcionando ASAP.

Esta guía no cubre por tanto:

-   Como hacer la separación de un proyectos en los módulos sugeridos por gvSIG, ni como separar entre librería y aplicación,...
-   Mantiene el proyecto funcionando con Ant a base de chapucear el classpath

De nuevo, el objetivo es únicamente tener el proyecto funcionando ASAP para luego implementar maven, el sistemas de módulos, separación entre api e implementación,...

-   Importa tu proyecto existente al nuevo workspace
-   Desactiva en las preferencias del IDE las save actions, especialmente las referidas a importar automáticamente clases.
-   Borra todas las dependecias del classpath que den problemas. Las iremos metiendo después.
-   Empieza a resolver los problemas de librerías externas a gvSIG del classpath
-   Ve borrando las librerías añadiendo librerías externas que estén en el repositorio maven cuando antes eran librerías que se encontraban en gvSIG. Todas las rutas son referenciadas respecto al respositorio de maven (en general ~/.m2/repository). Por ejemplo:

```
log4j -> log4j/
jts -> com/vividsolutions/jts/
slf4j -> org/slf4j/slf4j-api
```

-   Borra el resto de librerías y proyectos que tengas en el classpath que pertenezcan a gvSIG
-   Fichero a fichero elimina todos los imports que den error (Recomendable eliminar las opciones de save actions), y vete resolviendo. Hay que ir saltando entre clases para resolver problemas así que trata de empezar por las más sencillas

Equivalencia de clases genérica:

-   \_fwAndami -> org.gvsig.andami
-   appGVSIG -> org.gvsig.app.mainplugin
-   appgvSIG (relacionado con tablas) -> org.gvsig.app.document.table.app.mainplugin
-   libFMap -> Está distribuido en varios: org.gvsig.fmap.mapcontext.api, org.gvsig.fmap.control, org.gvsig.fmap.geometry.api
-   libIverUtiles - org.gvsig.utils
-   libExceptions -> org.gvsig.tools.exception
-   libUIComponents -> org.gvsig.ui
-   En caso de encontrarse con el error de que falta una clase de org.gvsig.tools.swing.api incluír el jar .m2/repository/org/gvsig/org.gvsig.tools.swing.api

# Algunas clases que cambian de nombre:

## View

```java
BaseView, View -> Intentar usar la interfaz IView, de modo que cambiaremos
View view = (IView) PluginServices.getMDIManager().getActiveWindow();
// por
IView view = (IView) PluginServices.getMDIManager().getActiveWindow();
```

## Table

Table (de la IWindow que representa la tabla) pasa a ser FeatureTableDocumentPanel en el proyecto org.gvsig.app.document.table.app.mainplugin

Ejemplo:

```java
Table table = (Table) PluginServices.getMDIManager().getActiveWindow();
// por
FeatureTableDocumentPanel table = (FeatureTableDocumentPanel) PluginServices.getMDIManager().getActiveWindow(); Esf39bff4c
```

En gvsig1 para conseguir la capa asociada a una tabla se usaba:

```java
table.getModel().getAssociatedTable()
// ahora
table.getModel().getAssociatedLayer()
```

## Otros

XMLEntity - Está en org.gvsig.utils

ExtensionPoint está en .m2/repository/org/gvsig/org.gvsig.tools.lib/VVV/org.gvsig.tools.lib-VVV.jar

MapControl está en org.gvsig.fmap.control

ReadDriverException y StopWriterVisitorException son substituidos DataException

About. La forma estándar de gestionar el about también cambia un poco. Antes la idea era añadir una pestaña de about por cada "contribución" realizada al proyecto. La idea ahora es añadir una pestaña por cada entidad que realiza una contribución, y dentro de esa pestaña añadir las contribuciones concretas. Para trabajar con el about hay que añadir el proyecto org.gvsig.about.api

Ejemplo:

```java
About about = (About) PluginServices.getExtension(About.class);
FPanelAbout panelAbout = about.getAboutPanel();
java.net.URL aboutURL = this.getClass().getResource("/about.htm");
panelAbout.addAboutUrl("NavTable", aboutURL);

// por

ApplicationManager application = ApplicationLocator.getManager();
AboutManager about = application.getAbout();
about.addDeveloper("iCarto", getClass().getClassLoader().getResource("about/icarto.html"), 1);
AboutParticipant participant = about.getDeveloper("iCarto");
participant.addContribution("NavTable", "NavTable", 2016, 6, 1, 2016, 7, 1 ;

// o si no queremos generar nuevos recursos ahora:

ApplicationManager application = ApplicationLocator.getManager();
AboutManager about = application.getAbout();
about.addDeveloper("NavTable", getClass().getClassLoader().getResource("/about.htm"), 1);
```

## Recorset y Source

getRecordset y getSource serán substituidos por getFeatureStore

```
FeatureStore fs = layer.getFeatureStore();
editableType = fs.getDefaultFeatureType().getEditable();
```

Contar las features de la capa:

```
layer.getRecordset().getFieldCount()

// por

sds.getFeatureSet().getDefaultFeatureType().getAttributeDescriptors().length;
```

## Selección de Features

Generalmente para operar con la selección se hacía

```
layer.getRecordset().getSelection(), lo que devolvía un FBItSect

// ahora sería

layer.getFeatureStore().getFeatureSelection() // que devuelve un FeatureSelection
// FBitSect tienen algunos métodos en común con FeatureSelection
// el getSelection de getRecorset, es un getFeatureSelection en el FeatureStore
```

## Registrar iconos

Antes para registrar un icono para mostrar en la barra de herramientas se usaba un código de este estilo:

```
private void registerIcon(String iconName) {
    URL iconUrl = this.getClass().getClassLoader().getResource("images/" + iconName.toLowerCase() + ".png");
	PluginServices.getIconTheme().registerDefault(iconName, iconUrl);
}
```

Ahora:

```
IconThemeHelper.registerIcon("action", "navtable", this);
```

Se pondrá un icono navtable.png en images/action/navtable.png, y el config.xml

```xml
<action
    name= "navtable"
    label="navtable"
    tooltip="Navtable"
    action-command="NavTable"
    icon="navtable"
    position="001009000000"
    accelerator=""
/>
<menu text="Capa/NavTable" name="navtable"/>

<tool-bar name="NavTable" position="133">
    <action-tool name="navtable" />
</tool-bar>
```

# Proyecciones

La parte de CRS implementa interfaces muy parecidas.

```
// Default CRS
MapContextLocator.getMapContextManager().getDefaultCRS()


import org.gvsig.fmap.crs.CRSFactory;
import org.cresques.cts.IProjection;

IProjection epsg4326 = CRSFactory.getCRS("EPSG:4326")
IProjection epsg25829 = CRSFactory.getCRS("EPSG:25829")


if (layer.getCoordTrans() != null) {
    geometry.reProject(layer.getCoordTrans());
}


mapControl.getMapContext().setProjection(CRSFactory.getCRS("EPSG:23030"));
```

# PluginServices

PluginServices.getMDIManager() -> MDIManagerFactory.getManager();
