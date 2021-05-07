# VSCode - Editor Config

El soporte para EditorConfig en VSCode se proporciona a través de un [plugin](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig).

Lo único que hay que hacer para que empiece a funcionar es instalarlo.

Se recomienda desactivar que la generación de ficheros .editorconfig inferidos a partir del proyecto:

```
"editorconfig.generateAuto": false,
```

En caso de problemas se puede instalar globalmente a nivel sistema el paquete `editorconfig` con `npm -g editorconfig` pero no debería ser necesario.

Las funcionalidades asociadas al `onSave` como `trim_trailing_whitespace` pueden necesitar configurar:

```
{
   "editor.formatOnSave": true
}
```

Pero en realidad para estas características es mejor generalmente delegar a los formatters específicos, `prettier`, `black`, ...

## Referencias

-   [Como funciona EditorConfig en Visual Studio](https://docs.microsoft.com/en-us/visualstudio/ide/create-portable-custom-editor-options) No en VSCode
-   [Plugin de EditorConfig de Microsoft](https://github.com/Microsoft/vscode-editorconfig) Este _deprecated_ en favor de la versión que mantiene la propia organización de EditorConfig
