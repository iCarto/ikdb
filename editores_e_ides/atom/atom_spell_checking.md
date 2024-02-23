# Spell Checking en Atom

Atom instala por defecto el plugin [spell-check](https://github.com/atom/spell-check) para hacer corrección ortográfica.

## Diccionarios

El plugin usa los diccionarios definidos a nivel sistema operativo. En Ubuntu podemos añadir nuevos diccionarios a través de `Configuración -> Región e Idioma`.

Por defecto, el plugin sólo usa el idioma (locale) "primario". Si queremos que use más diccionarios (de los instalados en el sistema), sólo tenemos que añadir los identificadores en la sección de `Locales` de la configuración de `spell-check`. Por ejemplo para castellano, inglés, portugués y gallego quedaría así:

```
es-ES, en-US, pt-PT, gl-ES
```

El soporte multi idioma funciona bastante bien y reconoce distintos idiomas en el mismo documento.

En la documentación del plugin hay instrucciones de como instalar diccionarios extras.

Por defecto está activado para unos pocos tipos de ficheros ([scopes](https://flight-manual.atom.io/behind-atom/sections/scoped-settings-scopes-and-scope-descriptors/) como (txt, markdown, ...). Pero es fácil [activarlo por defecto para más scopes](https://discuss.atom.io/t/how-to-enable-spell-checking-for-another-language/4895)

El problema de activarlo para un scope de código como puede ser html, es que el plugin intenta corregir no sólo los strings o los comentarios si no también las etiquetas y el código en sí. Y a Agosto de 2018 no parece haber una solución en el roadmap. [#19](https://github.com/atom/spell-check/issues/19), [#118](https://github.com/atom/spell-check/issues/118).

## Spell Checking de código con linter-spell

_spell-check_ es poco usable con código fuente, pero **en teoría** [atom linter](https://atomlinter.github.io/) proporciona plugins específicos para revisar la ortografía como si fuera un linter más gestionando adecuadamente la gramática de cada lenguaje.

Para usarlo además de instalar [linter](https://atom.io/packages/linter) el plugin base de todos los linter hay que instalar [linter-spell](https://atom.io/packages/linter-spell), plugin base para los distintos lenguajes de programación para los que queramos hacer la corrección ortográfica, y los plugins para los lenguajes concretos que vayamos a usar como [linter-spell-html](https://atom.io/packages/linter-spell-html). Por desgracia no hay plugin para python.

```
apm install linter intentions linter-spell linter‑spell‑html linter‑spell‑javascript linter‑spell‑shellscript
```

Por defecto _linter-spell_ soporta más o menos los mismos lenguajes (scopes) que _spell-check_ (texto plano, rst, markdown, ...). Además ambos plugins _se llevan mal_ por lo que sólo podemos tener habilitado uno de ellos.

Para hacer la corrección usa las librerías que tengamos instaladas en el sistema (Hunspell o GNU Aspell). No sólo es necesario tener los diccionarios como sucede con spell-check si no también el ejecutable `apt install hunspell`

Cuidado al usar estos plugins. Tanto _linter‑spell‑javascript_ como _linter‑spell‑html_ son bastante lentos. Pueden tardar segundos en un fichero algo grade.

**En la práctica no he sido capaz de configurarlos para que funcionen adecuadamente**. No logro que ignoren las palabras específicas del lenguaje, son lentos, ...

## Tips

-   `spell-check` se puede [desactivar temporalmente](https://superuser.com/a/1003636) con `Spell Check: Toggle`.

-   Con `spell-check` se puede auto-corregir una palabra con `Spell Check: Correct Misspelling` o `Ctrl+Shift+;`

-   Tanto [spell-check](https://atom.io/packages/spell-check-project) como [linter-spell](https://atom.io/packages/linter-spell-project) tienen plugins que permiten crear diccionarios específicos para un proyecto.

-   Para que las opciones de corrección salgan en el menú contextual al hacer click con el botón derecho en una palabra es necesario tener instalado el plugin de [intentions](https://atom.io/packages/intentions)

-   En Ubuntu Podemos listar los diccionarios instalados para hunspell con `apt list --installed 'hunspell*'`.

## Conclusión

En atom la revisión ortográfico para ficheros de "texto" funciona correctamente con el plugin por defecto pero no hay buenas alternativas para revisar "código".
