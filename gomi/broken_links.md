# Enlaces rotos

Revisar los enlaces rotos (_broken links_) de una web no siempre es una tarea sencilla.

Una opción más o menos sencilla cuando se tiene la web en internet usar wget (Ver descargar_mirror_web_wget.md) para descargar la web y luego revisar el log para encontrar los problemas.

```
# Para localizar los problemas
grep -B3 -i "error" logfile.log | grep -o -E 'http.*$'


# Para cada enlace roto buscamos donde aparece en nuestra copia local de la web
grep -irnH 'broken-link' mywebsite
```

Este sistema tiene un par de posibles problemas:

-   En páginas estáticas no es capaz de revisar los enlaces en local a no ser que levantemos un servidor, ...
-   No es capaz de leer páginas "dinámicas", donde deberíamos usar algo como Selenium para renderizar el contenido.

## Herramientas

Hay herramientas específicas para abordar estas tareas. Aquí un listado de posibles herramientas interesantes:

-   https://github.com/ubalklen/Broken-Link-Finder
-   https://github.com/EndlessTrax/pyanchor
-   https://github.com/becheran/mlc
-   https://github.com/smallhadroncollider/brok
-   https://github.com/JustinBeckwith/linkinator
-   https://github.com/stevenvachon/broken-link-checker
-   https://github.com/filiph/linkcheck
-   https://github.com/siteinspector/siteinspector

Esta es una tarea lo bastante compleja y con bastantes herramientas como para que en principio no tenga sentido desarrollar una solución propia.