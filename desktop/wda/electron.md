# Electron

-   https://www.electronjs.org/

Es el framework que usamos en iCarto para construír aplicaciones de escritorio con tecnologías web. Junto a una serie de técnicas adicionales nos permiten construir lo que llamamos WDA (Web desktopable apps). Aplicaciones que con una sólo base de código pueden correr en modo Cliente-Servidor o en modo Desktop.

## Opciones: Aplicaciones de Escritorio con Tecnologías Web:

-   https://github.com/sudhakar3697/electron-alternatives
-   electron
-   ¿cordova + electron?
-   React Native for Windows (lo mantiene microsoft). https://microsoft.github.io/react-native-windows/
-   python + qt + webview
-   python + cef. https://github.com/cztomczak/cefpython
-   java + javafx
-   ...

## Podemos decir que Electron son tres "cosas"

-   Paquete npm, línea comandos, y millones de utilidades de terceros

    -   https://www.electronjs.org/docs/tutorial/boilerplates-and-clis
    -   https://www.electronjs.org/docs/tutorial/application-distribution. scaffollders, empaquetados, instalables, ...
    -   ...

-   Un toolkit/framework para hacer aplicaciones de escritorio en nodejs

    -   Cuidado con paquetes "node" que sean concretos de una plataforma. Habrá que compilar/incluir los de cada plataforma target.
    -   No es sólo js. Mucho código nativo. "Chromium empotrado"
    -   autoactualización. https://www.electronjs.org/docs/tutorial/updates
    -   Menús nativos, TaskBar, ... Pero en lugar de proporcionar _widgets_ (JTextField, ...) proporciona un navegador sin ventanas para hacer la UI como una web

-   Un navegador sin botones, con algún detallito particular
    -   Cuidado con abrir tabs, ...
    -   APIs que pueden variar ligeramente, ...

## Arrancar

```
npm i -D electron@latest
# Editar package.json
# Editar main.js
electron main.js
```

O

```
# Trabajar normal
# Descargar los binarios compilados para la plataforma deseada
# Ajustar main.js
# y logos, ...
# hacer un zip
```

-   Ejemplo de main mínimo: https://github.com/electron/electron-quick-start/blob/master/main.js
-   Ejemplo de main lanzando un servidor Python: https://gitlab.com/icarto/aigar/-/blob/master/desktop/app/main.js

## Lo importante. Dos procesos

-   https://www.electronjs.org/docs/tutorial/application-architecture
-   Main (sòlo 1)
-   Renderer (tantos como BrowserWindow)

### Como se comunica el Renderer y el Main

-   ipcRenderer, ipcMain. API tipo Websockets para intercambiar mensajes en el Renderer y el Main. Más o menos bidireccional. Enviar Mensaje. .on("mensaje recibido", hacer_algo)
-   remote. Acceder desde el renderer a "cualquier" funcionalidad que haya en Main
-   Ejemplo de uso, crear un menú dinámicamente.
-   Estas dos apis al final te permiten hacer mil triquiñuelas y mierdear todo lo que quieras.
-   Nosotros evitamos estas cosas, porqué si no, no puedes hacer la aplicación web-servidor.
-   Como lo hacemos nosotros. Servidor en local y API Rest.
-   Cuidado con las nuevas APIs que enchufa electron en el navegador. Si no recuerdo mal, electron inyecta un `window.require` que es como accedes a las "apis extras". Y esto puede ser problemático. Ver `node-interacion.js` en utentes.

## Como tener una WDA

-   Servidor empotrado en el "zip" en la tecnología deseada
-   No usar "nada" electron. Sólo comunicación REST.
