# Configuración iCarto

En este apartado presentamos algunas decisiones que tomamos respecto a las herramientas de linting y formatting.

-   Las herramientas se instalan "dentro" del proyecto.

    -   Es decir viven dentro del `virtualenv` o del node_modules del proyecto. Las herramientas de Python se indican a través del fichero `requirements-dev.txt` y las de JavaScript a través del `package.json` de la raíz. Las dependencias en sí del backend se especifican en `pyproject.toml` o en `front/package.json`
        -   La excepción es `shfmt`y `shellcheck` que se instalan de forma global en el equipo.
    -   Cuando se usa `vscode` se lanza con el virtualenv activo desde la raíz del proyecto con `code .`. Esto hace que "todo funcione". Coge adecuadamente la configuración de las herramientas, usa las herramientas locales, ...
    -   Del mismo modo en pre-commit usamos las herramientas locales
    -   Esto nos permite tener las versiones pineadas para los distintos proyectos, usar la misma configuración en pre-commit que en el IDE, ...

-   Usamos pyproject.toml para la configuración de black e isort. Usamos setup.cfg para la configuración de flake8/wemake-python-styleguide. Dado que es bastante texto preferimos no mezclarlo en pyproject.toml

-   Las herramientas se lanzan con pre-commit. Cada persona decide si también las usa en su IDE.

## Herramientas que usamos:

-   pre-commit
-   black
-   isort
    -   En cada projecto es necesario ajustar `py_version`, `known_third_party`, `known_first_party`
-   wemake-python-styleguide

## Legacy

### Scripts en `package.json`

Durante algún tiempo incluíamos scripts en `package.json` como estos:

```
"scripts": {
    "pretty:python": "black . && isort .",
    "pretty:css": "npx stylelint --fix --ignore-path .ignore  '**/*.{vue,htm,html,css,sss,less,scss,sass,mak,jinja2}'",
    "pretty:js": "npx prettier --ignore-path '.ignore' --write '**/*.js'",
    "pretty:bash": "shfmt -l -w -i 4 -bn -sr -ci $(shfmt -f . | grep -v node_modules/)",
    "pretty:others": "npx prettier --ignore-path '.ignore' --write '**/*.{md,yml,yaml,json}'",
    "lint:bash": "git ls-files -c -o --exclude-from=.ignore '**.sh' | xargs shellcheck"
},
```

que se podían ejecutar para formatear o lintear todo el repositorio: `npm run pretty:python`

Eliminamos esta configuración porqué no se estaba usando y se puede usar pre-commit para ello:

```
# Todas las herramientas
pre-commit run --all-files

# Una herramienta
pre-commit run black
```
