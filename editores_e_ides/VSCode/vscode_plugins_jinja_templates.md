# VSCode - Jinja2 Template Engine

Por defecto VSCode no tiene syntax highlighting, ni snippets para los templates de Jinja2

# Better Jinja

-   https://marketplace.visualstudio.com/items?itemName=samuelcolvin.jinjahtml

Proporciona syntax highlighting tanto para las "macros" como `{% for user in users %} ... {% endfor %}`, como el lenguaje para el que se esté escribiendo el template `html`, `json`, ... La relación entre lenguajes y extensiones de fichero que interpreta están en la documentación del plugin. Aunque se pueden asociar nuevas extensions editando el `settings.json`

Algunas asociaciones serían:

| extensión | nombre del language grammar | lenguaje |
| .jinja | Jinja Raw | - |
| .jinja2, .html.j2 | Jinja HTML | html |
| .sql.jinja2 | Jinja SQL | sql |

En caso de que no lo asocie correctamente se puede asociar manualmente [de la forma habitual en VSCode](https://code.visualstudio.com/docs/languages/overview#_changing-the-language-for-the-selected-file) y tras la primera asocación parece recordar y funcionar todo correctamente.

# Otros

https://marketplace.visualstudio.com/items?itemName=RickyWhite.python-template-snippets
Hay al menos otro plugin que proporciona snippets para las "macros", pero no lo hemos probado: https://marketplace.visualstudio.com/items?itemName=WyattFerguson.jinja2-snippet-kit y en caso de necesitarlo se puede probar este otro que también los proporcionar para Django:

# Descartados

-   Hay otro plugin que proporciona resaltado de sintaxis pero está desactualizado: https://marketplace.visualstudio.com/items?itemName=wholroyd.jinja
