# React + Bootstrap

Hay dos formas genéricas de integrar Bootstrap en React:

-   Usar directamente la librería
-   Usar una tercera librería que "componetiza" Bootstrap

En general el uso de terceras librerías reduce el "code bloat" comparado con usar directamente Bootstrap, pero introduce más cosas a aprender, más peso del paquete, posiblemente más bugs, ...

## Librerías de terceros

### React Bootstrap

React-Bootstrap is a library with a complete re-implementation of Bootstrap components using React. It has no dependency on bootstrap.js or jQuery.

-   https://react-bootstrap.github.io/
-   https://github.com/react-bootstrap/react-bootstrap

### reactstrap

This library contains React Bootstrap 4 components that favor composition and control. The library does not depend on jQuery or Bootstrap javascript. However, https://popper.js.org/ via https://github.com/souporserious/react-popper is relied upon for advanced positioning of content like Tooltips, Popovers, and auto-flipping Dropdowns.

-   https://reactstrap.github.io/
-   https://github.com/reactstrap/reactstrap

### MDB

-   https://mdbootstrap.com/

## Usar Bootstrap directamente

No tiene una dificultad especial. Se escribe JSX pero su estructura, las clases css, etc... a emplear deben hacerse como se indica en la documentación de Bootstrap.

Para usarla lo más sencillo es descargar la librería a través de npm.

```bash
$ # No instalamos popper porqué no suele usarse directamente y viene incluida en
$ # bootstrap.bundle. El warning puede ignorarse
$ npm install bootstrap jquery --save
```

La forma concreta de integrarla es opinativa.

_Todavía no se han explorado todas las opciones de forma extensa. A continuación se presunta algunas posibles opciones y consideraciones iniciales, pero habría que analizarlas con más detalle._

_Estas opciones son asumiendo que usamos la configuracion por defecto de create-react-app o algo que funcione igual_

### Fuera del bundle

En lugar de gestionarla a través de Webpack, ES-modules, ... se puede usar de forma autónoma y simplemente ubicar todo en el objeto global.

-   Copiamos los ficheros JavaScript y css necesarios de node-modules al directorio (o subdirectorios dentro de) `public`.
-   Editamos `public/index.html` y añadimos los `<script>` y `<link>`

```html
<!-- 
%PUBLIC_URL% es una variable que webpack gestiona por si sólO
https://create-react-app.dev/docs/using-the-public-folder

bootstrap.bundle incluye Popper.js pero no JQuery
https://getbootstrap.com/docs/4.4/getting-started/contents/
-->
<link rel="stylesheet" href="%PUBLIC_URL%/vendor/bootstrap-4.4.1/bootstrap.min.css" />

<script src="%PUBLIC_URL%/vendor/jquery-3.4.1/jquery-3.4.1.slim.min.js"></script>
<script src="%PUBLIC_URL%/vendor/bootstrap-4.4.1/bootstrap.bundle.min.js"></script>
```

### A través del bundle

Como en general Bootstrap (y jQuery) serán un requisito de toda la aplicación y no de componentes específicos lo más sencillo es gestionarlo en el fichero de inicio general `src/index.js`

```javascript
// webpack sabe como gestionar el css que coge de node-modules
import "bootstrap/dist/css/bootstrap.min.css";
import $ from "jquery";
// No importamos popper porqué no suele usarse directamente y viene incluida en bootstrap.bundle
import "bootstrap/dist/js/bootstrap.bundle.min";

import React from "react";
import ReactDOM from "react-dom";
// Nuestro css general si no usamos otra cosa

import "./index.css";

import App from "./App";
import * as serviceWorker from "./serviceWorker";

// ...
```

### Observaciones

Cuando usamos Bootstrap o jQuery de esta forma, al convertirse en variables globales podemos tener problemas con los linters por no ver la definición de la variable. Una [forma sencilla de solucionarlo](https://create-react-app.dev/docs/using-global-variables) es:

```js
const $ = window.$;
```

## Referencias

-   https://github.com/verekia/js-stack-from-scratch/blob/master/tutorial/08-bootstrap-jss.md#readme
-   https://blog.logrocket.com/how-to-use-bootstrap-with-react-a354715d1121/
-   https://create-react-app.dev/docs/adding-bootstrap/
-   https://www.sitepoint.com/integrating-bootstrap-with-react/
-   https://www.pluralsight.com/guides/integrating-bootstrap-react-1. Código: https://codesandbox.io/s/9y8qq85qqo

## A Investigar

-   Como se integran los temas de Bootstrap con librerías de terceros o al usarlo directamente a mano
-   Como se integra otros plugins de jquery/bootstrap como select2, widgets de fechas, ...
-   https://www.bootstrapdash.com/use-bootstrap-4-with-reactjs/
-   Tiene sentido importar los ficheros minificados de bootstrap o es mejor importar los no minificados y dejar a Webpack hacer su trabajo.
