En este artículo se presentan algunas notas sobre como actualizar un plugin o proyecto a una nueva versión de gvSIG.

En primer lugar se debe construir un nuevo workspace y descargar los repositorios de la nueva versión como se explica en `gvsig2_configurar_entorno.md`. En casos particulares puede incluso resultar apropiado descargar una nueva versión de Eclipse.

Una vez se comprueba que se puede lanzar gvSIG sin problemas, se incorporan los plugins que se quieren migrar al workspace. Si es plugin de propósito general deberían separarse las ramas por las versiones de gvSIG a las que están destinadas. Probablmente esto sea más sencillo que tratar de mantener la compatibilidad entre distintas versiones a la vez.

Se actualiza el número de versión del `parent` en el `pom.xml` del plugin. La versión será el tag del plugin principal. Por ejemplo para `gvsig-desktop-2.5.1-3042-rc2` el plugin principal es `org.gvsig.desktop-2.0.300` y por tanto el número de versión a usar `2.0.300`.

Con cambios de _minor_ en gvSIG se suele producir _breaking changes_ que hay que identificiar y corregir.

## 2.3.1-2501 -> 2.5.1-3046-final

Algunos cambios detectados.

**Plugins de simbología**

La simbología se ha dividido en varios plugins, mientras antes llegaba con tener `org.gvsig.legend.vectorfilterexpression.app.mainplugin`, ahora para una simbología _mínima_ es necesario tener al menos

```shell
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.vectorfilterexpression.app.mainplugin/tags/org.gvsig.legend.vectorfilterexpression.app.mainplugin-1.0.114
svn checkout http://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.complexlegend/tags/org.gvsig.complexlegend-1.0.120
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.quantitybycategory.app.mainplugin/tags/org.gvsig.legend.quantitybycategory.app.mainplugin-1.0.115
svn checkout https://devel.gvsig.org/svn/gvsig-base-legends/org.gvsig.legend.graduatedsymbols.app.mainplugin/tags/org.gvsig.legend.graduatedsymbols.app.mainplugin-1.0.114
```

Hay más plugins con más simbología pero estos serían los más habituales.

EditableFeatureType targetFeatureType = DALLocator.getDataManager().createFeatureType();
return targetFeatureType.getNotEditableCopy();

**DefaultEditableFeatureAttributeDescriptor y DefaultEditableFeatureType**

La clase `DefaultEditableFeatureAttributeDescriptor` cambió la firma del constructor. El constructor sin firma `new DefaultEditableFeatureAttributeDescriptor()`, ahora sería equivalente a `new DefaultEditableFeatureAttributeDescriptor(null, false);`

Aunque sería más correcto obtener la instancia a través de un `DataManager`:

```java
EditableFeatureAttributeDescriptor newAttr = DALLocator.getDataManager().createFeatureAttributeDescriptor();
```

Del mismo modo con `DefaultEditableFeatureType` usaremos `new DefaultEditableFeatureType(null);` o mejor:

```java
EditableFeatureType featureType = DALLocator.getDataManager().createFeatureType();
// Si necesitamos FeatureType en lugar de EditableFeatureType
featureType.getNotEditableCopy();
```

**FeatureQuery y relacionados**

FeatureQueryOrder, Ha pasado a ser una interfaz por lo que hay que substituirla por su implementación

```java
// antes
new FeatureQueryOrder()

// ahora
new DefaultFeatureQueryOrder();
```

Antes para crear una expresión/filtro que añadir a una FeatureQuery se usaba:

```java
FeatureStore store = my_get_feature_store() // al menos atributos gid, bar, foo
DataManager dataManager = DALLocator.getDataManager();
FeatureQuery query = store.createFeatureQuery(); // Esta query antes devolvía todos los atributos de la capa, pero ahora sólo los implicados en el filtro
if (hasFilter()) {
    String where = "foo = 5"
    Evaluator evaluator = dataManager.createExpresion(where)
    query.addFilter(evaluator);
}
FeaturePagingHelper set = manager.createFeaturePagingHelper(store, query, 10);

Feature feat = set.getFeatureAt(position);
feat.get("bar"); // IllegalArgumentException: Attribute name 'bar' not found in the feature.
```

ahora:

o bien hay que agregar `query.retrievesAllAttributes();` para obtener todos los atributos o usar uno de los métodos sobrecargados:

```java
FeatureStore store = my_get_feature_store() // al menos atributos gid, bar, foo
DataManager dataManager = DALLocator.getDataManager();
FeatureQuery query = null;
if (hasFilter()) {
    String where = "foo = 5"
    query = store.createFeatureQuery(where, "", false);
    Evaluator evaluator = dataManager.createExpresion(where)
    query.addFilter(evaluator);
} else {
    query = store.createFeatureQuery("", "", false);
}
FeaturePagingHelper set = manager.createFeaturePagingHelper(store, query, 10);

Feature feat = set.getFeatureAt(position);
feat.get("bar"); // It works!
```

**Feature**

La interfaz Feature ha sufrido varios cambios, desapareciendo algunos métodos y apareciendo otros.

**Persistencia**

La carpeta "home/gvSIG" donde van las preferencias ahora es "preferences/gvSIG". Además hay preferencias que se guardan en `plugins-persistence-2_0.xml`, `andami-config.xml` y otras en `preferences/gvSIG/plugins/*/plugin-persistence.dat`

Los .xml tenderán a desaparecer en favor de los .dat pero ahora sigue habiendo cosas duplicadas o que están en los .xml y no en los .dat como el idioma o la vista por defecto. Seguiremos usando los .xml hasta que el cambio sea obligatorio y esté consolidado como usar los .dat.

Ver hilo de correo "Directorio de preferencias en la portable" en la lista de desarrollo
