# Hacer un mirror de una página web

Una forma sencilla de generar una versión offline de una página web (_mirror_) es usar `wget`

El comando a usar en general sería:

```shell
wget --recursive --page-requisites -N -o /tmp/wget_logfile.log -l inf <url>
```

## Otros parámetros recomendados

-   `--convert-links`: Intenta convertir los enlaces dentro de la página web para que funcionen offline. No funciona en todos los casos. Hay que probar con el parámetro y sin él.
-   `--wait 1 --random-wait`: Para ser _polite_ y evitar bloqueos podemos poner un tiempo de espera entre cada petición indicado en segundos. `--random-wait` modifica el tiempo que le pasemos por entre 0.5 y 1.5
-   `--adjust-extension`. No todos los navegadores gestionan correctamente webs offline cuya extensión no es .html. Este parámetro añade las extensiones correctas. El problema es que invalida opciones cómo `-N`, `--no-clover`

De este modo el comando quedaría como:

```shell
wget --recursive --page-requisites -N -o /tmp/wget_logfile.log -l inf --convert-links --wait 1 --random-wait --adjust-extension <url>
```

## Parámetros opcionales

-   `-e robots=off`. Si no queremos respetar el robots.txt
-   `--mirror`. Es equivalente a `-r -N -l inf --no-remove-listing`
-   `--spider`. No descargar realmente las páginas, sólo las revisa. Puede ser útil para generar el log y a partir de él extraer información como enlaces rotos.
-   `--limit-rate=200k`.
-   `--no-check-certificate`. Para páginas que den problemas con el certificado pero en las que confiemos
-   `--no-clover` y `-N`. La relación entre estos dos parámetros es confusa y conviene revisar la documentación.
-   `--no-parent`. En modo -r no asciende al directorio padre. Revisar la documentación porqué su uso no es sencillo.
-   `--domains=domain-list`. Especifica los dominios que pueden ser seguidos.
-   `-H`. Revisar documentación.
-   `--exclude-domains=domain-list`. Especifica los dominios que no deben ser seguidos.

## Explicación de otros parámetros

-   `--level inf`. Por defecto el `-r` sólo baja a 5 niveles de profundidad.
-   `--page-requisites`. Descarga no sólo el html si no todos los recursos necesarios. Imágenes, JS, adjuntos (.pdf, ...)
-   `--output-file=logfile`. Imprime la salida estándar y de error a fichero en lugar de pantalla
