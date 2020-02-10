# Moment.js

-   https://momentjs.com/

## Sobre React, moment, los locale, webpack y el bundle

Al usar moment con ES Imports, necesitar locales, y empaquetar con Webpack se puede acabar con un bundle más grande de los necesario.

Cuando una aplicación se monta con `create-react-app` los propios `react-scripts` ya tienen definidos los _workarounds_ para Webpack empaquete sólo lo necesario:

Esta forma de trabajar con moment funciona correctamente cuando sólo se necesita uno o unos pocos locales:

```bash
npm install moment --save
```

En `index.js`

```
import moment from "moment";
import "moment/locale/es";
// import "moment/locale/fr"; // En caso de necesitar más

moment.locale("es");
```

Esto sólo mete el locale de castellano en el bundle y configura el castellano como locale por defecto. Funciona así porqué create-react-app ya se [encarga de optimizar específicamente](https://github.com/facebook/create-react-app/pull/2187/files) la [configuración de webpack](https://create-react-app.dev/docs/troubleshooting/#momentjs-locales-are-missing) teniendo en cuenta `moment`.

Si no fuera así habría que hacerlo a mano en Webpack:

-   https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/
-   https://reallifeprogramming.com/get-rid-of-some-fat-from-your-react-production-build-3a5bb4970305
-   https://medium.com/@kudochien/a-react-webpack-optimization-case-27da392fb3ec
-   https://github.com/iamakulov/moment-locales-webpack-plugin
-   https://github.com/jmblog/how-to-optimize-momentjs-with-webpack
