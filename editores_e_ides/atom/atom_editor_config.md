# EditorConfig - Atom

_(Actualizado a Agosto/2017. v2.2.2)_

El [plugin](https://atom.io/packages/editorconfig) se instala como cualquier otro de Atom, pero para evitar incompatibilidades con otros plugins se suele recomendar:

-   Deshabilitar el plugin de whitespace
-   Poner "Tab type = auto" en los settings de Atom. En este caso, si tienes un fichero que mezcle tabs y espacios, puede ser que acabe ignorando el setting de EditorConfig. En este caso habría que poner a mano (al menos temporalmente) el valor deseado y formatear correctamente el fichero antes de volver a `auto`.

El plugin tiene algunas particularidades y comportamientos que pueden resultar extraños y que se deben tener en cuenta.

-   `EditorConfig: Fix File` sólo arregla el `indent_style` (espacios por tabs o viceversa) y el `end_of_line` (`crlf` por `lf` o viceversa)
-   Al guardar arregla automáticamente el `insert_final_newline` (una y sólo una línea al final, si está a true o eliminando todas si está a false) y el `trim_trailing_whitespace` si está a true.
-   Respeta la indentación de la línea actual. Es decir, si estamos en una línea con indentación a 4 y editorconfig marca 2, al hacer intro la indentación de la siguiente línea será 4. Si hacemos intro desde una línea no indentada (y toca indentar) si hará 2. [#200](https://github.com/sindresorhus/atom-editorconfig/issues/200)
-   El plugin de [wrap-guide](https://github.com/atom/wrap-guide) y el de EditorConfig "no se hablan entre sí" (ver bugs [#69](https://github.com/atom/wrap-guide/issues/69) y [#190](https://github.com/sindresorhus/atom-editorconfig/issues/190)), de modo que wrap-guide ignora las configuraciones de EditorConfig. Hay que setear a mano el `Preferred Line Length` ya sea en las settings del Editor, o del package correspondiente al lenguaje que estemos usando. Esto es una verdadera pena, porque permitiría "implementar" las sugerencias de algunos proyectos que dicen que las líneas no deberían pasar de 80 caracteres y nunca más de 100. El wrap-guide se podría fijar a 80 y el linter a 100.
-   Si `Soft Wrap` y `Soft Wrap At Preferred Line Length` están ambos activados (en las settings del Editor o del package del lenguaje que toque), Atom hará un "salto blando" de línea en `max_line_length` en lugar de en `Preferred Line Lengh`. Si `Soft Wrap` y `Soft Wrap At Preferred Line Length` están activados únicamente en las settings del plugin de Atom de EditorConfig, el "salto blando" es ignorado.

El sistema de plugins de Atom y orden en que se aplican las configuraciones es en general inconsistente y difícil de entender. En Settings -> Editor se pueden configurar de forma global aspectos como el tamaño del indentado. Pero para cada lenguaje, Atom tiene un plugin `language-xxx`. Accediendo a las preferencias del plugin desde el menú de packages la mayoría de los lenguajes nos vuelven a permitir configurar los mismos settings pero para un lenguaje en particular. Atom guarda esas configuraciones en un archivo `config.cson` que no tiene porque contener todas las opciones, si no dependiendo del plugin sólo las que hayan variado respecto al valor por defecto. Así, que en principio las settings del language tienen prioridad sobre las generales pero se pueden darse casos extraños.

Por ejemplo no es lo mismo que un checkbox esté desmarcado y que en el `config.cson` no aparezca ese valor, a que esté desmarcado y aparezca en el `config.cson` un false. Si nos fijamos en el caso de `Soft Wrap` para un fichero Python. Con la siguiente configuración (y soft wrap desmarcado en el paquete del lenguaje):

    editor:
        softWrap: true
        softWrapAtPreferredLineLength: true
    ".python.source":
      editor:
        softWrap: false
        softWrapAtPreferredLineLength: false
        autoIndentOnPaste: true
        tabLength: 4

No se activará el soft wrap. Pero manteniendo soft wrap desmarcado en el lenguage y esta configuración:

    editor:
        softWrap: true
        softWrapAtPreferredLineLength: true
    ".python.source":
      editor:
        autoIndentOnPaste: true
        tabLength: 4

si que se hará el soft wrap.
