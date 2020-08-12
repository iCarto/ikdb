# Formatters para Python

Las tres librerías más extendidas para el formateado de código Python son:

-   [autopep8](https://github.com/hhatto/autopep8). No reformatea todo el código, si no unicamente aquello que `pycodestyle` considera un error.
-   [yapf](https://github.com/google/yapf). Reescribe todo código. Trae 4 estilos por defecto (google, chromium, pep8, facebook) y muchas opciones de configuración.
-   [black](https://github.com/ambv/black). Reescribe todo el código. Es opinativo y sólo deja configurar un par de parámetros. Sólo corre bajo Python 3.6+ aunque formatea código de Python 2.7

A mayores existe `isort`, que puede combinarse con alguna de las anteriores (aunque debería ser ejecutada en último lugar):

-   [isort](https://github.com/timothycrosley/isort). Sólo reformatea los import de los ficheros Python, dando bastantes opciones de cual debe ser el resultado final, y tratando de ser conforme a pep8.

# autopep8

Permite corregir bastantes de los errores de estilo que detecta `pycodestyle`, como cambiar tabuladores por espacios, usar los espacios de la forma recomendada por pep8 alrededor de paréntesis y operadores, cortar líneas al llegar al máximo de caracteres indentándolas bastante bien, ... Es una buena herramienta para quien prefiera que el auto-formateado de código esté acotado.

En algunas ocasiones, la selección/exclusión de ficheros no funciona del todo bien. Hay una [issue abierta](https://github.com/hhatto/autopep8/issues/246) al respecto. Generalmente con `autopep8 --recursive .` no hay sorpresas pero si no se puede optar por ejecutarlo dos veces con un glob distinto

```bash
autopep8 --in-place --recursive **/*.py  # Selecciona todos los .py excepto los del directorio actual
autopep8 --in-place --recursive *.py  # Selecciona los .py del directorio actual
```

Por defecto no intenta corregir, todas las situaciones si no sólo algunas. La configuración por defecto es bastante segura, en caso de querer que sea más agresivo conviene consultar la documentación. En caso de pasar la herramienta sobre un proyecto legacy, se puede pasar la herramienta una vez en modo no agresivo, hacer commit para poder ver los cambios de la siguiente pasada, seleccionar más opciones `autopep8 --in-place --recursive --select E,W .`, volver a hacer commit e iterar hasta usar

```bash
autopep8 --in-place --recursive --select E,F,W,C --aggressive --aggressive --experimental --max-line-length=119 .
```

En este modo no todas las correcciones que hace van a tener sentido para un proyecto y estilo determinado, pero puede dar ideas de mejoras aunque luego se apliquen a mano. En mi código no he encontrado una situación en el que el doble aggressive o experimental arregle más errores que un sólo aggressive. Pero aggressive si que arregla algunas cosas que flake8 (pyflakes) no considera error sin plugins como usar `except:` en lugar de `except BaseException:`

Como sucede con pycodestyle, ignorar el error de máximo número de caracteres por línea (`--ignore=E501`), no siempre funciona correctamente por lo es recomendable usar `--max-line-length=1000`. El motivo es que no quiero que introduzca saltos de línea por mi. Una línea demasiado larga debería ser en general refactorizada y no simplemente retocar donde se corta la línea. Este sucede con más "errores", por tanto si se está usando la herramienta sobre un proyecto digamos "legacy", el resultado sólo debería usarse como una base. Algunos errores será mejor corregirlos a mano aprovechando para refactorizar.

El otro caso en el que esta herramienta tiene sentido es como un [beautifier](https://github.com/Glavin001/atom-beautify#beautifiers) con sólo algunos errores seleccionados.

# yapf

La descripción de [yapf](https://github.com/google/yapf) es muy clara en cuanto a su objetivo:

> Most of the current formatters for Python e.g., autopep8, are made to remove lint errors from code.
> This has some obvious limitations. For instance, code that conforms to the PEP 8 guidelines may
> not be reformatted. But it doesn't mean that the code looks good.
>
> YAPF takes a different approach. The algorithm takes the code and reformats it to the best formatting
> that conforms to the style guide, even if the original code didn't violate the style guide. The idea is
> also similar to the 'gofmt' tool for the Go programming language: end all holy wars about formatting
> If the whole codebase of a project is simply piped through YAPF whenever modifications are made,
> the style remains consistent throughout the project and there's no point arguing about style in every
> code review.

Trae 4 estilos por defecto (google, chromium, pep8, facebook), cuya configuración y opciones adicionales se pueden consultar en el fichero [style.py del código fuente](https://github.com/google/yapf/blob/master/yapf/yapflib/style.py)

Para reformatear una base de código podemos usarlo de este modo:

```bash
yapf --in-place --recursive --style pep8 .
```

Para probar como pueden afectar distintas opciones de configuración podemos pasarle un estilo a través de la línea de comandos:

    yapf --diff --style='{based_on_style: chromium, indent_width: 4, column_limit: 79}' myfile.py

Como sucede con todas las herramientas de este tipo, la salida puede [no ser exactamente la esperada](https://github.com/google/yapf/issues/561), y es necesario alguna iteración hasta encontrar la configuración que más se adapte. En el caso de yapf esto es especialmente cierto puesto que algunas de las decisiones que toma el algoritmo se basan en _pesos_ introducidos en la configuración. Por ejemplo la de [pep8 usa un peso de 80](https://github.com/google/yapf/blob/master/yapf/yapflib/style.py#L304) para decidir si hay que introducir un salto de línea en una comprenhension list mientras que [la de google usa un 2100](https://github.com/google/yapf/blob/master/yapf/yapflib/style.py#L326). Ajustar esos valores puede ser muy complicado, por lo que probablemente es mejor escoger un estilo base y no tocar los pesos si no el resto de opciones.

## Integración

En teoría, tiene buena integración con los editores:

-   Atom. [python-yapf](https://atom.io/packages/python-yapf), [ide-python](https://atom.io/packages/ide-python), [atom-beautify](https://atom.io/packages/atom-beautify)
-   Emacs. [py-yapf.el](https://github.com/paetzke/py-yapf.el), [Yapfify](https://github.com/JorisE/yapfify), [elpy](https://github.com/jorgenschaefer/elpy)

pero, en la práctica la mayoría de plugins (para Atom) está desactualizados y atom-beautify es bastante _buggy_ [1](https://github.com/Glavin001/atom-beautify/pull/856), [2](https://github.com/Glavin001/atom-beautify/issues/786). beautify trabaja haciendo una copia del fichero a uno temporal y lanzando un comando de la consola contra él, como el fichero ya no está en el path normal, no hay forma de pasarle la configuración buena, y por tanto beautify/yapf ignoran las settings de setup.cfg, ... el workaroud es crear un fichero ~/config/yapf/style que sea una copia del setup.cfg

## Configuración para yapf

Después de jugar un poco, queda claro que encontrar la combinación "ideal" es complicado, por bugs, configuraciones que se pegan con otras, ... Esta sería una posible configuración a meter en `setup.cfg`:

-   Nótese que cuando se quiere una lista, diccionario, etc, parámetros, ... que aparezcan uno por línea en lugar de seguidos se usa el truco de poner una "," después del último


    [yapf]

    # Usamos pep8 como configuración base
    based_on_style = pep8
    column_limit = 88

    # Estos coinciden con pep8. Los fijamos para pruebas o para hacer hacer
    # explícita la decisión
    indent_width = 4
    split_before_bitwise_operator = true
    split_before_logical_operator = true
    allow_split_before_dict_value = true
    split_all_comma_separated_values = false
    coalesce_brackets = false
    continuation_align_style = space
    split_before_expression_after_opening_paren = false

    # Excepto en los siguientes casos, donde claramente es mejor otra configuración
    indent_dictionary_value = true
    join_multiple_lines = false

    # y en los siguientes casos, donde en realidad es un poco indiferente
    # pero usamos otra configuración al menos temporalmente para luego decidir
    blank_line_before_nested_class_or_def = true
    split_complex_comprehension = true
    split_before_dot = true
    split_before_first_argument = true # hay que verlo en conjunto con otros
    split_arguments_when_comma_terminated = true
    dedent_closing_brackets = true

    # en este caso es con la idea de que salte E124 y tocar las otras opciones para
    # que en realidad nunca se de.
    align_closing_bracket_with_visual_indent = false

# Otras herramientas

-   <https://github.com/guyskk/pybeautifier>. Es un servicio tcp a montar en local con autopep8 y/o yapf y/o isort. La idea es que los plugins para los editores en ocasiones se vuelven muy lentos, entre otras cosas porqué levanta un proceso cada vez que formatean. La idea aquí es mantener el proceso abierto a la espera de texto que reformatear. No es mala idea.
-   <https://github.com/paluh/code-formatter>. Último commit de 2014
-   Hay bastantes proyectos que podrían ser mejores que isort pero tienen menos tracción.
    -   <https://github.com/asottile/reorder_python_imports>
    -   <https://github.com/asottile/aspy.refactor_imports>
-   Mucho menos conozida que isort es [zimports](https://github.com/sqlalchemyorg/zimports/) del creador de SQLAlchemy. Una de las cosas buenas es que se lleva bien con `flake8-import-order` y borra imports no usados. No estaría de más probarla.

# black

[black](https://github.com/python/black) es un formateador de código opinativo. Sus únicas opciones son el máximo de línea y si debe convertir todas las quotes a dobles o no debe hacer esa conversión. El estilo de código que propone es compatible con PEP8 tomando decisiones más "estrictas" en los puntos abiertos del PEP.

A pesar de que puede formatear código de python 2.7, sólo corre sobre la 3.6+ y es capaz de lidiar con Python tipado, f-strings, ...

Tiene plugins para la mayoría de editores, soporte para [Language Server Protocol](https://langserver.org/)

El que sólo corra bajo la 3.6 puede ser un poco problemático en código legacy, dado que correr las herramientas (linting, ...) con la misma versión que el código acaba dando menos problemas, pero funciona correctamente.

Lo mejor de `black` es que toma las decisiones por ti, y es el formateador más usado en el momento. Así que si muchos equipos lo usan, es probable que a ti también te valga, aunque no te guste como queda exactamente todo. Recuerda: legible es distinto de bonito.

## Instalación y configuración

`black` requiere Python 3.6+ para correr. Si el proyecto está en esa versión de Python lo mejor es añadirlo a `requirements-dev.txt` y ejecutarlo dentro de un `virtualenv`.

Se puede configurar a través de un fichero [pyproject.toml](https://www.python.org/dev/peps/pep-0518/).

**Algunos problemas**

-   [Se está trabajando en ello](https://github.com/python/black/issues/475) pero por defecto no ignora los patrones definidos en `.gitignore`. Por lo que deben añadirse a mano al `exclude`.
-   El formato de `exclude` es horrible. También hay issues abiertas para permitir un formato como el de `.gitignore`


    #pyproject.toml

    [tool.black]
    line-length = 88
    # Mejor ser explícitos con la versión de python y los strings
    target-version = ['py36']
    skip-string-normalization = false

    # Ajustar en cada proyecto
    exclude = '''
    /(
        \.eggs
      | \.git
      | \.mypy_cache
      | \.tox
      | \.venv
      | _build
      | buck-out
      | build
      | dist
      | __pycache__

      | \.egg-info
      | node_modules
      | \.idea
      | \.vscode
      | \.vagrant
    )/
    '''

black también formatea los imports pero no los reordena. En el README de black se incluye una configuración compatible para isort.

Se puede ejecutar con `black .`

# isort

isort es una herramienta que permite "reordenar y formatear" los imports de un fichero python. Tiene [plugins para la mayoría de editores](https://github.com/timothycrosley/isort/wiki/isort-Plugins), [hooks para git](https://github.com/timothycrosley/isort#git-hook) y [precommit](https://github.com/pre-commit/mirrors-isort).

Provee de otras funcionalidades además de ordenar y formatear, como borrar/añadir imports a varios ficheros a la vez.

Desde la línea de comandos la forma más fácil de correrlo es con:

```bash
isort -rc .
```

que modifica los ficheros .py "in place" de forma recursiva.

## Instalación y configuración

Si el proyecto está en esa versión de Python lo mejor es añadirlo a `requirements-dev.txt` y ejecutarlo dentro de un `virtualenv`.

Se puede configurar a través de un fichero [pyproject.toml](https://www.python.org/dev/peps/pep-0518/).

    #pyproject.toml
    [tool.isort]
    line_length = 88
    atomic = true # `true` cuando la versión de python target y que corre isort es la misma
    include_trailing_comma = true
    multi_line_output = 3 # El 5 ahorra espacio, pero para evitar rewrites de la salida de black
    force_grid_wrap = 0
    lines_after_imports = 2
    use_parentheses = true
    filter_files = true # No documentado. Fuerza que se cumpla skip y skip_glob aunque se le pase el fichero por línea de parámetros. Útil para hooks
    skip_glob = ["*.egg", "*.egg-info", "__pycache__", "build/", "node_modules"] # Ajustar en cada proyecto
    combine_as_imports = false # Revisar
    known_third_party = ["bcrypt", "pyramid", "sqlalchemy", "geoalchemy2", "django", "requests"]
    known_first_party = ["mypackage"] # Ajustar en cada proyecto

Para determinar si un paquete es `third party` o `first party` parece ser que isort lo importa realmente, esto puede dar lugar a resultados extraños [#725](https://github.com/timothycrosley/isort/issues/725), [#704](https://github.com/timothycrosley/isort/issues/704), [#498](https://github.com/timothycrosley/isort/issues/498), sobre todo en entornos de `ci`. Lo más sencillo seguramente es añadir a mano paquetes a
`known_third_party` y `known_first_party` cuando se detecta un problema. La herramienta [seed-isort-config](https://github.com/asottile/seed-isort-config) podría usarse para modificar el valor de estas opciones, pero tampoco se ha comportado a prueba de balas en las pruebas realizadas así que no la usamos.

**Algunos problemas**

-   Como sucede con `black` por defecto no ignora los patrones de .gitignore y hay que configurarlos a mano mediante `skip`, `skip_glob` y/o `filter-files`

# Configuración iCarto

En iCarto usamos black + isort. Estás herramientas se lanzan con [pre-commit](https://pre-commit.com/) y se configuran en `pyproyect.toml`. En cada repositorio se configura el `target-version` de black y los `known_third_party`, `known_first_party` de isort.

Incluimos un script en `package.json` con como se lanzaría para ejecutarlos sobre todo el repositorio: `npm run pretty:python`

```json
"scripts": {
    "pretty:python": "black . && isort -rc ."
},
```

Cada persona del equipo decide si usa un plugin para el editor o no.
