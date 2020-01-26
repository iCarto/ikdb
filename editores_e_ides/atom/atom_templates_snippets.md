# Templates y Snippets

En este contexto llamamos:

-   Template: A crear un nuevo fichero a partir de una plantilla. Por ejemplo, al crear un script de Python, el nuevo fichero ya consta de un método `main`, configurar el logger, ...
-   Snippet: A (generalmente) un cacho de código pequeño que se usa a menudo. Por ejemplo un bucle for donde ya se inicializan algunas variables, ...

La diferencia entre "template" y "snippet" en ocasiones puede ser "difusa".

Atom trae por defecto funcionalidades para trabajar con "snippets", y otros plugins pueden añadir snippets adicionales. Leer la documentación básica resulta de interés:

-   https://flight-manual.atom.io/using-atom/sections/snippets/
-   https://github.com/atom/snippets
-   https://www.hongkiat.com/blog/add-custom-code-snippets-atom/

## Algunas consideraciones

-   Es fácil que los snippets funcionen de forma "irregular". Al final se mezcla con los distintos plugins de autocompletado, emmet, ... por lo que puede resultar confuso lo que pasa al pulsar tab tras un determinado texto. Como se "lanza" el snippet puede verse afectado por la configuración del paquete "autocomplete-plus"
-   Los snippets son contextuales al tipo de fichero en el que se esté trabajando (.html, .py, ...).
-   Una forma "segura" de invocarlos es `Palette: "Snippets: Available"`. El diálogo admite "fuzzy search" y con seleccionar uno y darle a intro se inserta en el texto.
-   Al crear snippets propios, una forma sencilla para determinar el grammar es en un fichero cualquiera seleccionar en la barra inferior de status el tipo de fichero "GiHub Markdown", "Python", ... eso abre un diálogo a partir del cual podemos ver cual es el "grammar" deseado. Es **importante** fijarse en que `snippets.cson` los grammar empiezan por un `.` mientras que generalmente en el resto de Atom aparecen siempre sin el `.`. Es decir debemos usar '.source.python' y no 'source.python'
-   En el autocompletado el [símbolo de los snippets es una flecha verde](https://assets.hongkiat.com/uploads/add-custom-code-snippets-atom/html-builtins.jpg)

## Templates vs Snippets

Si bien los snippets se pueden usar muchas veces como templates, esto no resulta del todo cómodo:

-   Los snippets suelen definirse en un modo muy específico del editor. Lo que hace difícil reusarlos en el equipo
-   Generalmente están pensandos para "cosas pequeñas". En concreto en Atom en el momento en que metemos un par de snippets grandes, el fichero `snippets.cson` se vuelve complicado de manejar

Por ello suele ser de interés poder tener unos ficheros template en un repositorio de código y algún plugin para el editor con el que resulte cómodo actualizar los templates de tanto en tanto.

El plugin de plantillas que parece un poco mejor que el resto en Atom es [file-templates](https://atom.io/packages/file-templates)

## Templates iCarto

-   Scripts Python: `python_default_template_scripts.md`
