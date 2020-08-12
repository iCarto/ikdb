# Configurar Atom con plugins para linting

Para usar _linters_ en Atom hay que instalar dos plugins base más [otros específicos](https://atomlinter.github.io/).

### linter

[linter](https://atom.io/packages/linter) es el plugin base para todo el resto de plugins de Atom que proveen capacidades de linting. Tras instalar este hay que instalar los [específicos del lenguaje que interese](http://atomlinter.github.io/). A no ser que vayas a desarrollar plugins para Atom no hay que saber nada más de este plugin.

### linter-ui-default

Si linter provee una API para los linters específicos, [linter-ui-default](https://atom.io/packages/linter-ui-default) es el plugin que realmente marca en el editor las líneas con problemas. Si se desactiva no se verán los errores. Conviene repasar su configuración y [leer como funciona](http://steelbrain.me/2017/03/13/linter-v2-released.html) para ajustarlo a nuestro gusto

Los comandos disponibles para el plugin en el [command palette](http://flight-manual.atom.io/getting-started/sections/atom-basics/#command-palette), están bajo la categoría 'linter-ui-default' y permiten asociar teclas a acciones como mostrar el panel con los errores, ir al siguiente/anterior error, ...

Una opción cómoda es mapear `ctrl-.` y `ctrl-,` a ir al siguiente/anterior error (`linter-ui-default:next` / `linter-ui-default:previous`), que es la misma configuración que se usa en Eclipse. Estás teclas están asociadas por defecto al `key-binding-resolver` y a mostrar las preferencias. Si no se usan a menudo se pueden eliminar esos atajos para asociarlos al linter. Las teclas que se usan por defecto en PyCharm para estas acciones (F2 / Shift-F2) en Atom están asociados a Siguiente/Anterior Bookmark. También puede ser una buena combinación si no usas los bookmarks o no usas estás acciones muy a menudo.

Algo que podía resultar molesto en en el plugin en versiones anteriores a la 1.6.3 (donde se introducen los cambios discutidos en [#330](https://github.com/steelbrain/linter-ui-default/issues/330), era que el tooltip con el error apareciera continuamente al escribir en una línea marcada (tooltip follows keyboard). Y tener que usar el ratón para mostrar el tooltip era molesto en ocasiones,

Configurándolo como:

```
"linter-ui-default":
    showPanel: true
    showProviderName: true
    tooltipFollows: "Mouse"
    ...
```

Se podía ver en el panel los errores y este desaparecía automáticamente al solucionarlos.

Con versiones más actuales, el tooltip desaparece automáticamente al comenzar a escribir, lo que parece un comportamiento adecuado, sobre todo si se juega con el tiempo que tarda el linter en hacer el chequeo.

Una posible configuración:

```
  "linter-ui-default":
    decorateOnTreeView: "Files and Directories"
    hidePanelWhenEmpty: false
    panelHeight: 220
    showPanel: false
    showProviderName: true
    statusBarRepresents: "Current File"
    tooltipFollows: "Both"
```

```
'.platform-linux':
  'ctrl-.': 'linter-ui-default:next'
  'ctrl-,': 'linter-ui-default:previous'
```

## Plugins específicos

### shellcheck

Se usa [linter-shellcheck](https://atom.io/packages/linter-shellcheck) con la configuración por defecto

```
"linter-shellcheck":
    enableNotice: true
```
