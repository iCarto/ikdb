# Como redireccionar en apache todas las peticiones a https://ejemplo.com

Teniendo en cuenta el número de ejemplos distintos y preguntas que hay en Internet al respecto no hay una respuesta definitiva al respecto. En este artículo presentamos una que funciona correctamente para la mayoría de los casos.

No debe aplicarse esta regla cuando:

-   El apache sirva más de una página web o aplicación
-   No se esté definiendo el `VirtualHost` como `<VirtualHost *:80>` si no especificando un dominio o ip en lugar del `*`

La definición de VirtualHost que se presenta en la siguiente sección tiene el siguiente comportamiento:

-   Redirecciona `http://ip` a `https://dominio`
-   Redirecciona `http://dominio` a `https://dominio`
-   **No** redirecciona `https://ip` a `https://dominio`

y tiene en cuenta el puerto, `path` y `query_string`

-   `http://ip/foo/bar?q=search` será redireccionado a `https://domain/foo/bar?q=search`
-   `http://ip:80/foo/bar?q=search` será redireccionado a `https://domain/foo/bar?q=search`
-   `https://domain:443/foo/bar?q=search` será redireccionado a `https://domain/foo/bar?q=search`

## La definición de site a usar

```
<VirtualHost *:80>

  # Estas líneas comentadas pueden eliminarse
  # ServerName dominio # Ver notas
  # ServerAdmin webmaster@localhost # Ajustar
  # DocumentRoot /var/www/html Sólo lo usamos para redireccionar

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

  RewriteEngine On
  # Cuando se use http y no https, ya sea accediendo por ip o dominio
  RewriteCond %{HTTPS} off
  # redirecciona el navegador al dominio deseado con https
  RewriteRule ^(.*)$ https://dominio$1 [R=301,END,NE]

</VirtualHost>
```

-   El módulo de rewrite debe estar habilitado `a2enmod rewrite`
-   Si se ha usado `certbot` para instalar un certificado de Let's Encrypt se pueden substituir las reglas de redirección que pone `certbot` y cambiar por estas.

## Explicación de la redirección anterior

-   Se puede usar SERVER_NAME

```
# https://httpd.apache.org/docs/current/mod/core.html#servername
RewriteRule ^(.*) https://%{SERVER_NAME}$1 [R,L]
```

-   Cuando en el texto anterior se usa `dominio` se pueden emplear también subdominios como `icarto.es` o `foo.icarto.es`

*   `^(.*)$`. Dentro de un `VirtualHost` lo que viene a continuación de `RewriteRule` se usa para emparejar el _path_ y el _query string_, no afecta al matcheo de puerto, dominio protocolo. E incluye el matcheo de la `/`. Hay otras opciones de escribirlo pero esta parece la más clara. Y debería respetar que se use `/` o no al final del dominio sin nada más, pero cuando se usa la ip la redirección está metiendo `//` cuando no hay _path_. Es un _bug_ no grave a investigar.
*   `/$1`. `$1` es el primer grupo que emparejamos en la expresión regular. Como estamos buscando explícitamente la `/` y dejándola fuera del grupo tenemos que escribirla al construir la url a la que redireccionamos.
*   `END`. No apliques más reglas de redirección estén donde estén.
*   `NE`. No conviertas caracteres como `#` a su código hexadecimal cuando redirecciones.
*   [R=301] fuerza la redirección externa de forma permanente.
*   Cuidado con poner los comentarios en la misma línea que la expresión porqué puede dar problemas

## Redireccionar https://ip a https://dominio

En este punto se explica porqué una redirección de este tipo no funciona correctamente.

```
<VirtualHost *:80>
  RewriteEngine On
  # Cuando se use http y no https, o
  RewriteCond %{HTTPS} off [OR]
  # el dominio no sea el indicado porqué se usa la ip
  RewriteCond %{HTTP_HOST} !=dominio
  # redirecciona el navegador al dominio deseado con https
  RewriteRule ^(.*)$ https://dominio$1 [R=301,END,NE]
</VirtualHost>
```

-   -   [OR]. Las `RewriteCond` en lineas distintas se interpretan como un `AND`. Con este flag se interpretan como `OR`
-   `!dominio` entraría a funcionar cuando el acceso esa https//ip, y sería una regla válida porqué hemos asumido que hay sólo una web en el apache
-   No funciona porqué los certificados, al menos los de Let's Encrypt, no se conceden a ips. La evaluación del certificado se produce antes de la redirección, saldrá el mensaje de certificado inválido y aunque sea aceptado, el navegador no está aceptando la redirección.
-   No parece haber una forma de poder conseguir este tipo de redirección sin obtener un certificado para la ip.

## Referencias

-   https://stackoverflow.com/questions/24542680/how-to-redirect-http-to-https-for-ip-and-domain-on-apache2
-   https://stackoverflow.com/questions/11649944/apache-httpd-conf-for-redirecting-ip-to-hostname
-   https://httpd.apache.org/docs/current/mod/mod_rewrite.html
-   https://www.digitalocean.com/community/questions/how-to-redirect-https-ip-to-https-domain
-   https://serverfault.com/questions/837867/http-to-https-redirect-even-for-ip
-   https://serverfault.com/questions/43804/make-ip-address-redirect-to-real-name-with-apache#comment1186945_43811
-   https://serverfault.com/questions/993925/redirect-ip-address-to-domain-name-on-apache
-   https://www.cloudsavvyit.com/4967/how-to-redirect-your-ip-address-to-your-domain-name/
