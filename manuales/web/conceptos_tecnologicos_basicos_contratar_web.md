# Conceptos tecnológicos básicos para la contratación de una página web

A la hora de implementar (o contratar la implementación) de una página web es interesante que el contratante tenga algunos conceptos tecnológicos básicos claros para poder decidir de forma más acertada que es lo que necesita.

Este documento está enfocado sobre todo a entidades con pocos recursos o con personal sin altas capacidades tecnológicas. Este documento no pretende ser "preciso" o "correcto" desde un punto de vista formal, si no aportar una visión de alto nivel útil para quien realice la contratación.

**Aviso**. En este documento se mencionan proveedores, servicios y precios. iCarto no recomienda ni deja de recomendar a estos proveedores y los precios se proporcionan sólo como referencia que puede variar enormemente.

**Ìndice**

-   Tipos de páginas web. Donde se intentan explicar algunas opciones tecnológicas de como se puede implementar una web.
-   Dominio. Donde se explica que es el dominio o url de una web.
-   Hosting. Donde y como se puede alojar una web.
-   Cuanto cuesta hacer una web. Orientación sobre coste y tiempos de crear una web.
-   Recomendación.
-   Otras consideraciones.

## Tipos de páginas web

Básicamente podemos decir que en función del _software_ que se use para implementarla hay tres tipos de páginas web:

-   Dinámicas (con base de datos)
-   Estáticas (sin base de datos)
-   Híbridas o dinámicas sin base de datos

### Dinámicas (con base de datos)

Las dinámicas (con base de datos) se construyen mediante aplicaciones software como [Wordpress](https://wordpress.org/), [Joomla](https://www.joomla.org/) o [Drupal](https://www.drupal.org/). Estas aplicaciones se "personalizan" mediante plugins y temas para que la página web tenga la apariencia final deseada. La información en sí se almacena en aplicaciones de bases de datos (habitualmente MySQL).

Entre las aspectos positivos de este tipo de tecnología está:

-   Es "fácil" para los usuarios modificar contenido existente o crear nuevo contenido. Por ejemplo nuevas secciones de la página o actualizar un blog.
-   Permiten tener un sistema de usuarios y permisos.
-   Existen muchos plugins para añadir funcionalidades extra.
-   La mayoría de empresas usan estas aplicaciones para crear páginas web por lo que es fácil encontrar o cambiar de proveedor.

Entre los aspectos negativos:

-   Este tipo de páginas usan "aplicaciones sofware". Al igual que una aplicación software instalada en el PC, es necesaria mantenerla actualizada para evitar "virus" y otros problemas de seguridad. Es decir requieren cierto grado de mantenimiento.
-   Hacer una copia de seguridad de la información y la página (o restaurar las copias) requiere más conocimientos y trabajo que con otras opciones.
-   A pesar de que es sencillo añadir contenido, el hecho concreto de maquetar un artículo o página fuera de lo predefinido incialmente se le puede hacer un poco complicado a una persona con pocos conocimientos.
-   Este tipo de páginas siempre van a requerir de algún tipo de servidor (_hosting_) o servicio de pago. Habría alguna excepción, pero si queremos cierto grado de personalización, podemos asumir que siempre requerirán algún tipo de pago.

### Estáticas (sin base de datos)

Las webs hechas de este modo no usan ninguna "aplicación" para mostrar el contenido. La funcionalidad, información y maquetación se implemente directamente mediante tecnologías web de cliente (javascript, css y html). Se podría decir que no necesitan un servidor que procese información, si no sólo un "disco duro conectado a internet" por decirlo de algún modo (no hay que entenderlo al pie de la letra) donde alojar el contenido.

Crear nuevo contenido, modificar el existente o cambiar la maquetación requiere de conocimientos (al menos básicos) de html y css. Es decir que queda fuera del alcance de la mayoría de las personas. Por eso son llamadas estáticas, una vez que la creas, dependerás de ayuda externa para cualquier modificación.

Pero también tienen puntos positivos:

-   Existen opciones de almacenamiento (_hosting_) gratuito para este tipo de páginas. Por ejemplo en repositorios de código como [GitHub](https://github.com/) o [GitLab](https://gitlab.com/)
-   No es necesario actualizar ningún software. Por tanto el mantenimiento que requieren es 0.

### Híbridas

Llamamos híbridas o dinámicas sin base de datos a un tipo de páginas web que ha surgido en los últimos años. El contenido se escribe en general mediante documentos de texto simples en [formato markdown](https://www.markdownguide.org/). Es decir que no requieren de una base de datos. La maquetación y otras funcionalidades es una mezcla de plugins, html, css y javascript. Una aplicación software se encarga de "compilar" el contenido original a una página web de tipo estático.

Entre los software más habituales para realizar este tipo de páginas se encuentra [Jekyll](https://jekyllrb.com/).

En cierto modo estás aplicaciones tienen los mismos problemas y ventajas que las webs estáticas. No es muy habitual de todas formas encontrar proveedores que ofrezcan realizar una web mediante este tipo de software.

## Dominio

[Dominio](https://es.wikipedia.org/wiki/Dominio_de_Internet) o "Domain Name" es el "nombre único que identifica a un sitio en internet". Es decir sería lo que tecleamos en el navegador para acceder a una determinada página, por ejemplo: `icarto.es`.

Un dominio personalizado para nuestra entidad (por ejemplo: `mientidad.org`) siempre debe ser contratado a un proveedor de dominios. Algunos servicios dan la opción de poder usar "subdominios" de forma gratuita. Por ejemplo un servicio como [github.io](https://github.io/) nos puede dar un subdominio como `mientidad.github.io` de forma gratuita.

En caso de contratarlo lo habitual es hacerlo con el mismo proveedor donde se contrate el hosting.

Ejemplos de proveedores y precios:

-   En [Dreamhost](https://www.dreamhost.com/domains/) un proveedor americano, un dominio `.com` o `.org` sale por unos 16\$/año.
-   En [Dinahosting](https://dinahosting.com/) una empresa gallega un `.com`, `.org` o `.es` sale por unos 14€/año.
-   En [MozDomains](https://www.mozdomains.com/) una empresa de Mozambique, un `.com` sale por 12\$, un `.org` por 17$ y un `.co.mz` (dominio propio de Mozambique) por 45$.
-   En [Gandi](https://www.gandi.net) uno de los mayores proveedores del mundo, originalmente francés. Un `com` o `.es` sale por unos 15€, y un `.org` por unos 18€.

## Hosting

Se llama "hosting" ("alojamiento") al servidor donde "vivirá" la página web. Según porqué tecnología empleemos para la página este "hosting" puede ser algo así como simplemente "un disco duro conectado a internet" hasta algo mucho más complejo con base de datos, intérprete para el lenguaje que se use en el servidor, ...

Y hay muchas opciones:

-   En un servidor propio. Se trataría de tener un servidor en la propia oficina que sirva la página web. Si estás leyendo este documento problemente esta no es una buena idea. Un servidor requiere bastante mantenimiento, y flujo continuo de electricidad y acceso a internet lo que no se da en muchos contextos.
-   En un servidor (VPS o similar) contratado en la nube. En lugar de tener el servidor en la oficina lo contratas a un proveedor. De nuevo requiere bastante mantenimiento y preocuparte de cosas como actualizar el sistema operativo.
-   En un proveedor de hosting "típico". Está sería la opción recomendada si vas a usar una web dinámica y tal vez también en caso de optar por una estática. Estos proveedores se encargan de la parte "dura" por ti, y sólo hay que preocuparse del mantenimiento específico de la aplicación web. Habitualmente estos proveedores dan más opciones (por el mismo precio) que sólo el hosting como por ejemplo correo-e corporativo, ...
-   Si optas por una web estática hay opciones como usar el servicio gratuito de GitHub o GitLab.
-   Algunas empresas ofrecen alojar la página web como un servicio en sí. El mantenimiento del software lo realiza la propia empresa que te da el servicio por lo que te puedes olvidar de esa parte. Uno de los servicios más populares de este tipo es [WordPress.com](https://es.wordpress.com/pricing/) que admite webs de WordPress con plantillas personalizadas, plugins, etc... por 25€/mes aunque tienen opciones más económicas.

Ejemplos de proveedores y precios:

-   En DreamHost desde 3\$/mes
-   En DinaHosting desde 4.5€/mes
-   En MozDomains desde 6\$/mes
-   En Gandi desde 7€/mes

## Cuanto cuesta hacer una web

Cualquier respuesta a esta pregunta será en general mala. El coste "final" de contratar una web varía enormemente entre el contratista escogido, el pais donde se contrate, el tipo y tamaño de la web que se vaya a realizar, si se mezcla con temas de identidad corporativa y recursos adicionales (logo, colores corporativos, ...)

Sólo como orientación muy general una web como la de icarto.es contratada a una agencia española puede estar entre 500€ y 4000€ dependiendo de los factores mencionados antes.

El tiempo de entrega puede estar entre un par de semanas y un par de meses. Pero el tiempo dependerá en gran medida más del cliente que del contratista. El coste y tiempos internos del cliente no debe ser nunca despreciado. Si la nueva web viene acompañada de una reflexión sobre lo que se quiere transmitir, redactar los textos, escoger imágenes, ... debe preveerse que pueden ser decenas de horas.

## Recomendación

Si estás leyendo este documento nuestra recomendación genérica sería que optaras por una web estática alojada en GitHub/GitLab y con un Dominio comprado a un proveedor de tu pais. Y que pidas a quien te haga la web el código de la misma cuando la haga.

Sí, sabemos que quieres poder actualizar y crear contenido. Pero valora el coste que tiene esto. Cuantas horas tienes reservadas para llevar a cabo esta actividad cada mes. Si ya tienes una web cuanto la has actualizado en el último año. Se realista sobre cual es el objetivo y cuales son tus recursos.

## Otras consideraciones

-   Forma de pago. Muchos proveedores únicamente admiten el pago mediante tarjeta de crédito. Esto es un problema para muchas entidades en algunos contextos.
-   Mantenimiento externo. Muchas empresas ofrecen el mantenimiento básico de la web. Esto puede incluir (o no) el subir nueva información que proporcione el cliente. Es una opción válida que debe considerarse con cuidado puesto que suele tener un precio elevado. En algunos países debe además dejarse claro a quien pertenece la web y pedir copias periódicos del software, contenido y claves de acceso para que si en algún momento se quiere cambiar de proveedor este no "secuestre" la web.
-
