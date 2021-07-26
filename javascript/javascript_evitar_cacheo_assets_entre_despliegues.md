# Evitar el cacheo de ciertos assets o ficheros entre despliegues

Pongamos un caso particular del que se puede extraer el problema general.

Tenemos un _asset_ o fichero llamado `template.docx`. Este fichero cambia muy poco a menudo y como mucho entre despliegues. El fichero se carga a través de AJAX. En este caso a través de `JSZipUtils.getBinaryContent` para usarlo como plantilla de [docx-templates](https://github.com/guigrpa/docx-templates) y generar un nuevo fichero que es el que se devuelve a la usuaria. El uso de esta funcionalidad es variable, algunas usuarias pueden usarla muy ocasionalmente (semanal), otras a menudo (varias veces al día), otras pueden usarla varias vecs el mismo día y luego no usarla en semanas, ... Así que la política que use el navegador para cachear está bien.

Es un problema difícil de detectar porqué en desarrollo es difícil que suceda, no es habitual tener tests que se aseguren de que el fichero de salida tiene los cambios (imaginemos simplemente en el tamaño de letra de un título), y detectarlo en _staging_ dependerá de la cache del navegador de quien pruebe.

El problema está en que tras un despliegue el navegador puede haber cacheado el fichero antiguo y seguir sirviéndolo. `Ctrl + Shift + R`, no soluciona el problema y sólo limpiar la cache manualmente funciona. O cuando se usa con las herramientas de depuración y el cacheado deshabilitado.

Es un problema que podemos abortar desde diferentes perspectivas.

## No cachear

No cachear no es la mejor de las opciones pero puede haber escenarios donde sea lo más adecuado.

-   Con [jQuery](https://smoothprogramming.com/jquery/explicitly-set-cache-false-jquery-ajax/). Poner `cache=false` [en la práctica](https://stackoverflow.com/q/41133752/930271) es lo mismo que añadir un `querystring` random.
-   [Usando](https://stackoverflow.com/q/61813991/930271) los [headers](https://stackoverflow.com/a/948873/930271)
-   [Resumen de opciones](https://www.checkoutall.com/Blog/Index/201605230627219560/Prevent-AJAX-request-from-getting-cached-in-internet-explorer-browser)

También podemos hacerlo mano, añadiendo un _query string_, con un código como `${url}?t=${new Date().getTime}`, pero lo mejor es encapsularlo en alguna función `noChachedUrl` porqué debemos tener varias cosas en cuenta:

-   La url ya puede contener otros parámetros `uri + (uri.indexOf("?") > 0 ? "&" : "?") + "timestamp=" + new Date().getTime();`
-   Puede tener caracteres extraños y debemos hacerlos _url safe_
-   La _key_ del _query string_ debe ser escogida de modo que no interfiera con otros parámetros de nuestra api. Es habitual [usar nombres](https://stackoverflow.com/a/367827/930271) como `t`, `rnd`, `timestamp`, `_`, `cache`, ...
-   Es mejor usar un timestamp `new Date().getTime()` que que `Math.random()` porqué no está garantizado que no obtenga el mismo valor.

## Herramientas de construcción de JavaScript

Un _asset bundler_ como Webpack tiene funcionalidades para copiar un asset (`template.docx`) al directorio de salida e inyectar en el código la url resultante, permitiendo en el proceso configurar el nombre final, para incluír por ejemplo el hash y por tanto cachear sólo cuando el fichero cambie. En Webpack5 se consegue mediante el [asset module](https://webpack.js.org/guides/asset-modules/) y en versiones anteriores mediante el _file-loader_.

Esta es una buena solución si ya se está usando Webpack.

## Query string de versión

Se puede usar la técnica de añadir un _query string_ a la url para en lugar de añadir un timestamp con lo que nunca cacheará usar el código de versión del despliegue. De este forma cacheara el fichero para cada despliegue.

```
let version = getCurrentVersion();
let cachedUrl = `${url}?v=${version}`;
```

El problema de esta solución es de donde sacamos el código de versión en el cliente. Puede estar _hardcodeado_ en algún JavaScript, si usamos plantillas podemos inyectarlo desde el backend, ...

Si ya estamos usando el código de versión en el cliente esta puede ser una buena opción, pero si no, hacerlo en exclusiva para este caso de uso puede dar problemas, e introduce la complejidad extra de mantener ese código de versión actualizado.

## Versión en el nombre del asset

Está es una de las soluciones más sencillas. En lugar de tener un fichero `template.docx` tendremos un `template.v2.docx`, `210720_template.docx`, `templates/v2/template.docx` o el esquema que consideremos adecuado.

La única precaución es que la url debe estar en una constante o configuración que se puede cambiar con facilidad en un único punto, y asegurarnos de que las versiones antiguas del asset "desaparecen" (control de versiones, producción, ...)

Siempre que nos aseguremos de borrar el fichero antiguo, no da muchos problemas porqué cualquier test fallará si no está disponible la nueva versión.
