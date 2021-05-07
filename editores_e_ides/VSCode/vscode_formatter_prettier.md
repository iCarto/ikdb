# VSCode - Formatter - Prettier

La extensión a instalar para usar Prettier en VSCode es:

-   [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

No debería ser necesario configurar nada. Por defecto usa el binario instalado localmente (una `devDependencies` en `package.json`) y respeta los ficheros de configuración de prettier (`prettier.config.js`)

Si hay más de un formatter para un tipo de fichero podemos necesitar configurarlo a mano:

```
// activarlo como formato por defecto para todo lo que soporte prettier cuando haya más de un formatter
"editor.defaultFormatter": "esbenp.prettier-vscode",
// activarlo específicamente como formato por defecto para JavaScript
"[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

El uso de Prettier + Linters está bajo discusión.

Como especificar sobre que ficheros debería trabajar esta extensión, sobre todo en el `formatOnSave` está bajo discusión. Un caso habitual es que esté habilitado el formato automático para html, pero que un fichero .html sea en realidad un template de plantillas y se formatee de forma incorrecta.
