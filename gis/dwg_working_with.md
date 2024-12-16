# Trabajar con DWG

DWG es un formato propietario de Audodesk (AutoCAD). Es uno de los formatos más complicados de trabajar con Software Libre y/o gratuíto.

Las únicas alternativas válidas (ninguna libre) para convertir versiones modernas del formato DWG a algo usable han sido:

-   ODA File Converter. Que permite convertir un DWG moderno a una versión más antigua que pueda leer QGIS, GDAL, ... o a DXF. Luego se puede importar a un geopackage con QGIS y a partir de ahí ya se puede jugar con python o lo que se quiera. **Esta es la mejor opción**

-   FME. Todo el proceso se puede hacer aquí dentro. No es libre, tiene una versión de prueba.

La búsqueda de utilidades se centró en aquellas que permitieran la automatización de procesos al trabajar la información.

## Generalidades

-   https://gis.stackexchange.com/questions/92270/workflow-to-convert-a-dwg-cad-file-to-a-shapefile
-   https://gis.stackexchange.com/questions/27007/transforming-from-dwg-dxf-to-gis

## Librerías y Aplicaciones que funcionan

### Open Design Alliance / Teigha

Al formato de la [Open Design Alliance](<(https://www.opendesign.com/)>) se le suele llamar [DWGDirect](https://es.wikipedia.org/wiki/DWGDirect) o OpenDWG pero no es libre. Es una ingeniería inversa sobre DWG y no compatible al 100%.

[Aquí parece haber una especificación](https://www.opendesign.com/files/guestdownloads/OpenDesign_Specification_for_.dwg_files.pdf).

Al software que tenían antes se le llamaba Teigha ahora parece tener otro nombre. La librería de interés se llama [Drawings SDK](https://www.opendesign.com/products/drawings), y tienen bindings para Java, .NET y C++

Las [versiones de prueba](https://www.opendesign.com/free-trial) son de 30 días y sólo para Windows.

Tienen alguna aplicación gratuita:

-   Un [conversor online](https://www.opendesign.com/oda_online_converter) de DWG/DXF a PDF
-   [ODA Viewer](https://www.opendesign.com/guestfiles/oda_viewer) sólo visualiza la información. Sólo Windows.
-   [ODA Drawings Explorer](https://www.opendesign.com/guestfiles/oda_drawings_explorer). En teoría permite visualizar, editar, crear. Tiene buena pinta pero se me cierra cuando abro un fichero DWG o DXF.
-   [ODA File Converter](https://www.opendesign.com/guestfiles/oda_file_converter). Convierte entre distintas versiones de DXF y DWG. Tras convertir el fichero de interés a "2000 DWG" pude importarlo en QGIS. Se puede [usar desde la consola para automatizar la conversión](https://www.freecadweb.org/wiki/FreeCAD_and_DWG_Import). `ODAFileConverter "." "/tmp/foo" "ACAD2000" "DWG" "0" "1"`

-   https://stackoverflow.com/questions/2637038/how-do-i-open-a-dwg-file-extension-with-python
-   https://en.wikipedia.org/wiki/Open_Design_Alliance

## Librerías y Aplicaciones que podrían funcionar en un determinado momento

### LibreDWG

https://www.gnu.org/software/libredwg/

El esfuerzo de la FSF por tener una librería C con licencia GPL que sea capaz de trabajar con formatos modernos. Parece que la usa LibreCAD y Grass. Tiene bindings para python

Por ahora no parece fácilmente usable porque hay que compilarla de algún modo.

### GDAL

Hay muchos posts antiguos por ahí, así que hay que tener cuidado con las referencias:

Hay tres drivers relacionados con el soporte de DXF y DWG:

-   **CAD**. [AutoCAD DWG](https://gdal.org/drivers/vector/cad.html) sólo lectura y soporte limitado. Funciona a través de la librería [libopencad](https://github.com/sandyre/libopencad). Sólo soporta la versión: "DWG R2000 [ACAD1015]"
-   **DWG**. [AutoCAD DWG](https://gdal.org/drivers/vector/dwg.html) a través de Open Design Alliance Teiga library, y hay que compilar el soporte a mano.
-   **DXF**. [AutoCAD DXF](https://gdal.org/drivers/vector/dxf.html)

Para comprobar los formatos soportados por nuestra versión de gdal `ogrinfo --formats | grep -iE 'dxf|dwg|cad'`

-   https://trac.osgeo.org/gdal/wiki/DWG_driver

El driver no soporta versiones modernas.

### QGIS

Tiene un importador "Project -> Import -> Import DWG into GPKG".

No soporta versiones modernas de DWG, seguramente use GDAL por debajo.

-   https://gis.stackexchange.com/questions/32730/importing-dwg-into-qgis-project
-   https://www.youtube.com/watch?v=ZgHvKnmSqGI

### gvSIG

La versión 2.4 tiene un plugin para abrir DWG pero no soporta formatos de DWG modernos

## Aplicaciones y Librerías que no se han probado

-   https://itsfoss.com/cad-software-linux/

## Otras utilidades

-   https://github.com/mozman/ezdxf. Librería python para manipular .dxf
-   https://github.com/gncloud/dwg-filter basada en jdwglib. Es una librería java soporta DWG2000 y DWG2004
-   https://plugins.qgis.org/plugins/AnotherDXF2Shape/
-   https://www.qgis.ch/en/projects/dxf-export
-   lx-viewer http://lx-viewer.sourceforge.net/download.php
-   DraftSight https://www.ubuntizando.com/tres-estupendas-alternativas-a-autocad-para-linux/
-   Descarga gratuita para ubuntu: https://www.3ds.com/es/productos-y-servicios/draftsight/descargagratuita/

## Librerías descartadas

-   Geokettle no parece ser una opción. Parece funcionar a través de gdal y parece un poco muerto.
-   https://sourceforge.net/projects/jdwglib/ librería java para leer DWG. Sin actualizaciones desde 2015
-   https://purchase.aspose.com/pricing/cad/java sólo parece transformar a ráster (pdf, png, ...)
-   Apache Tika. https://tika.apache.org/0.9/formats.html#The_DWG_AutoCAD_format sólo parece mirar los headers
-   https://stackoverflow.com/questions/31874109/autocad-library-in-java-to-read-dwg-files/32142064#32142064.
