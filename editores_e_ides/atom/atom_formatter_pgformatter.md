# Atom - Formatter - pgFormatter

_(Actualizado a Octubre/2019. prettier-atom v0.0.1)_

En Atom no hay demasiadas opciones para el formateo de código SQL:

-   [atom-pg-formatter](https://atom.io/packages/pg-formatter). La última actualización es de 2017. Usa `pgFormatter`

-   [atom-beautify](https://github.com/Glavin001/atom-beautify). Intenta ser el plugin para aunar todos los formatters para Atom. El mantenedor principal [está trabajando en una versión disinta](https://unibeautify.com/) por lo que ya apenas tiene mantenimiento. Es útil si no se quieren instalar muchos plugins. Por desgracia es fácil que un determinado formatter tenga bugs no resueltos, y el intentar aunarlos a todos introduce otros problemas. En nuestra experiencia suele ser mejor usar plugins concretos para el formatter que interese. Soporta `sqlparse`.

## atom-pg-formatter

[atom-pg-formatter](https://atom.io/packages/pg-formatter) se instala de la forma normal y requiere que el binario de `pg_format` esté en el path

A pesar de que está desactualizado tiene la mayoría de opciones útiles. Y entre lo más interesante está que permite formatear sólo el código seleccionado en el editor. Para SQL esto es muy útil, puesto que nos permite darle un primer formato y luego ajustar a mano.

Nuestra configuración con explicaciones:

```
"pg-formatter":
    editorOptions:
      formatOnSave: false  // El formateo automático de SQL nunca va a ser lo deseado
```

pg-formatter necesita trabajo para actualizarlo. estaría chulo hacer un par de pr o hacer uno nuevo, revisando antes los más típicos y siguiendo la misma estructura.
