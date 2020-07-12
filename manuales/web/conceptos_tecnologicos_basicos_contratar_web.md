# Conceptos tecnológicos básicos para la contratación de una página web

A la hora de implementar (o contratar la implementación) de una página web es interesante que el contratante tenga algunos conceptos tecnológicos básicos claros para poder decidir de forma más acertada que es lo que necesita.

Este documento está enfocado sobre todo a entidades con pocos recursos o con personal sin altas capacidades tecnológicas. Este documento no pretende ser "preciso" o "correcto" desde un punto de vista "informático", si no aportar una visión de alto nivel útil para quien realice la contratación. Se ha escrito a partir de experiencias reales que han sucedido a clientes y contrapartes.

**Aviso**. En este documento se mencionan proveedores, servicios y precios. iCarto no recomienda ni deja de recomendar a estos proveedores. Los precios se proporcionan sólo como referencia y pueden variar.

**Ìndice**

-   Tipos de páginas web. Donde se intentan explicar algunas opciones tecnológicas de como se puede implementar una web.
-   Dominio y https. Donde se explica que es el dominio o url de una web. Y porqué deberías usar https.
-   Hosting. Donde y como se puede alojar una web.
-   Cuanto cuesta hacer una web. Orientación sobre coste y tiempos de crear una web.
-   Contenido de la página
-   Recomendación.
-   Otras consideraciones.

## Tipos de páginas web

Básicamente podemos decir que en función del _software_ que se use para implementarla hay tres tipos de páginas web:

-   Dinámicas (con base de datos)
-   Estáticas (sin base de datos)
-   Híbridas o dinámicas sin base de datos

### Dinámicas (con base de datos)

Las dinámicas (con base de datos) se construyen mediante aplicaciones como [Wordpress](https://wordpress.org/), [Joomla](https://www.joomla.org/) o [Drupal](https://www.drupal.org/). Estas aplicaciones se "personalizan" mediante plugins y temas para que la página web tenga la apariencia final deseada. La información en sí se almacena en una base de datos (habitualmente MySQL) en un servidor.

Entre las aspectos positivos de este tipo de tecnología está:

-   Es "fácil" para los usuarios modificar contenido existente o crear nuevo contenido. Por ejemplo nuevas secciones de la página o actualizar un blog.
-   Permiten tener un sistema de usuarios y permisos.
-   Existen muchos plugins para añadir funcionalidades extra.
-   La mayoría de empresas usan estas aplicaciones para crear páginas web por lo que es fácil encontrar o cambiar de proveedor.

Entre los aspectos negativos:

-   Igual que sucede con un programa instalado en la computadora o el sistema operativo, es necesario mantener el software de la web actualizado para evitar "virus" y otros problemas de seguridad. Es decir requieren cierto grado de mantenimiento.
-   Hacer una copia de seguridad (y restaurar la copia) requiere más conocimientos y trabajo que con otras opciones.
-   A pesar de que es sencillo añadir contenido, el hecho concreto de maquetar un artículo o página fuera de lo predefinido inicialmente se le puede hacer un poco complicado a una persona con pocos conocimientos.
-   Este tipo de páginas siempre van a requerir de algún tipo de servidor (_hosting_) o servicio de pago. Hay excepciones, pero si queremos cierto grado de personalización, podemos asumir que siempre requerirán algún tipo de pago.

### Estáticas (sin base de datos)

Las webs hechas de este modo no usan ninguna "aplicación" para mostrar el contenido. La funcionalidad, información y maquetación se implementa directamente mediante tecnologías web de cliente (javascript, css y html). Se podría decir que no necesitan un servidor que procese información, si no sólo un "disco duro conectado a internet" por decirlo de algún modo (no hay que entenderlo al pie de la letra) donde alojar el contenido.

Crear nuevo contenido, modificar el existente o cambiar la maquetación requiere de conocimientos (al menos básicos) de html y css. Es decir que queda fuera del alcance de la mayoría de las personas. Por eso son llamadas estáticas, una vez que la creas, dependerás de ayuda externa para cualquier modificación.

Pero también tienen puntos positivos:

-   Existen opciones de almacenamiento (_hosting_) gratuito para este tipo de páginas. Por ejemplo en repositorios de código como [GitHub](https://github.com/) o [GitLab](https://gitlab.com/)
-   No es necesario actualizar ningún software. Por tanto el mantenimiento que requieren es 0.

### Híbridas

En este artículo llamamos híbridas o dinámicas sin base de datos a un tipo de páginas web que ha surgido en los últimos años, a las que en el "mundillo" se las suele denominar como [static site generator](https://www.staticgen.com/) o [Jamstack](https://jamstack.org/).

El contenido se escribe en general mediante documentos de texto simples en [formato markdown](https://www.markdownguide.org/). Es decir que no requieren de una base de datos. La maquetación y otras funcionalidades es una mezcla de plugins, html, css y javascript. Una aplicación software se encarga de "compilar" el contenido original a una página web de tipo estático.

Entre los software más habituales para realizar este tipo de páginas se encuentra [Jekyll](https://jekyllrb.com/).

En cierto modo estás aplicaciones tienen los mismos problemas y ventajas que las webs estáticas. No es lo más habitual de todas formas encontrar proveedores que ofrezcan realizar una web mediante este tipo de software.

### Recomendación

Si estás leyendo este documento nuestra recomendación genérica sería que optaras por una web estática alojada en GitHub/GitLab y con un Dominio comprado a un proveedor del país donde opere la entidad.

Sí, sabemos que quieres que la gente deje comentarios y poder actualizar y crear contenido. Pero valora el coste que tiene esto. Cuantas horas tienes reservadas para llevar a cabo esta actividad cada mes. Si ya tienes una web cuanto la has actualizado en el último año. Se realista sobre cual es el objetivo y cuales son tus recursos.

## Dominio

[Dominio](https://es.wikipedia.org/wiki/Dominio_de_Internet) o "Domain Name" es el "nombre único que identifica a un sitio en internet". Es decir sería lo que tecleamos en el navegador para acceder a una determinada página, por ejemplo: `icarto.es`.

Un dominio personalizado para nuestra entidad (por ejemplo: `mientidad.org`) siempre debe ser contratado a un proveedor de dominios. Algunos servicios dan la opción de poder usar "subdominios" de forma gratuita. Por ejemplo un servicio como [github.io](https://github.io/) nos puede dar un subdominio como `mientidad.github.io` de forma gratuita.

En caso de contratarlo lo habitual es hacerlo con el mismo proveedor donde se contrate el hosting.

Ejemplos de proveedores y precios:

-   En [Dreamhost](https://www.dreamhost.com/domains/) un proveedor americano, un dominio `.com` o `.org` sale por unos 16\$/año.
-   En [Dinahosting](https://dinahosting.com/) una empresa gallega un `.com`, `.org` o `.es` sale por unos 14€/año.
-   En [MozDomains](https://www.mozdomains.com/) una empresa de Mozambique, un `.com` sale por 12\$, un `.org` por 17$ y un `.co.mz` (dominio propio de Mozambique) por 45$.
-   En [Gandi](https://www.gandi.net) uno de los mayores proveedores del mundo, originalmente francés. Un `com` o `.es` sale por unos 15€, y un `.org` por unos 18€.

### HTTPS

Sin entrar en detalles llega decir que [https](https://es.wordpress.org/support/article/why-should-i-use-https/) es una forma más segura y rápida de conectarse a una web que http. Cuando un usuario entra a nuestra página web, esta debería por defecto funcionar en modo https.

A día de hoy es fácil y gratuito (si no tienes necesidades espaciales) servir una página web bajo https. Pon por escrito en el contrato o TdR que la página debe "Usar la versión más segura posible del protocolo https sin perjuicio de uso para la gran mayoría de navegadores sin coste adicional. Los certificados deben ser renovados automáticamente."

-   La frase de "versión más seguro posible" y "sin perjuicio de uso" está un poco vacía de significado. Lo único que tienes que saber es que bajo las siglas https, se esconden otro montón de tecnologías que se van quedando obsoletas con el paso del tiempo o pasan a considerarse menos seguras, así que te curas en salud para reclamar, si hacen una configuración claramente mala.
-   Los certificados son parte de la magía de https. Es una "clave" que intercambian servidor y navegador para que un tercero no pueda usurpar la identidad de nuestro servidor o leer los datos intercambiados. Un certificado debe ser avalado por una entidad de certificación. La autoridad de certificación gratuita más popular, [Let's Encrypt](https://letsencrypt.org/), sólo proporciona el aval para un máximo de tres meses, pero así mismo proporciona mecanismos para que la renovación del certificado pueda ser automática.

## Hosting

Se llama "hosting" ("alojamiento") al servidor donde "vivirá" la página web. Según porqué tecnología empleemos para la página este "hosting" puede ser algo así como simplemente "un disco duro conectado a internet" hasta algo mucho más complejo con base de datos, intérprete para el lenguaje que se use en el servidor, ...

Y hay muchas opciones:

-   En un servidor propio. Se trataría de tener un servidor en la propia oficina que sirva la página web. Si estás leyendo este documento problemente esta no es una buena idea. Un servidor requiere bastante mantenimiento, flujo continuo de electricidad y buen acceso a internet lo que no se da en muchos contextos.
-   En un servidor (VPS o similar) contratado en la nube. En lugar de tener el servidor en la oficina lo contratas a un proveedor. Evitas los problemas de conectividad, apagaones, ... pero sigue requiriendo de bastante mantenimiento y conocimientos de informática.
-   En un proveedor de hosting "típico". Está sería la opción recomendada si vas a usar una web dinámica y tal vez también en caso de optar por una estática. Estos proveedores se encargan de la parte "dura" por ti, y sólo hay que preocuparse del mantenimiento específico de la aplicación web. Habitualmente estos proveedores dan más opciones (por el mismo precio) que sólo el hosting como por ejemplo correo-e corporativo, ...
-   Si optas por una web estática hay opciones como usar el servicio gratuito de GitHub o GitLab.
-   Algunas empresas ofrecen alojar la página web como un servicio en sí. El mantenimiento del software lo realiza la propia empresa que te da el servicio por lo que te puedes olvidar de esa parte. Uno de los servicios más populares de este tipo es [WordPress.com](https://es.wordpress.com/pricing/) que admite webs de WordPress con plantillas personalizadas, plugins, etc... por 25€/mes aunque tienen opciones más económicas.

Ejemplos de proveedores y precios de lo que hemos llamado "hosting típico":

-   En DreamHost desde 3\$/mes
-   En DinaHosting desde 4.5€/mes
-   En MozDomains desde 6\$/mes
-   En Gandi desde 7€/mes

## Cuanto cuesta hacer una web

Cualquier respuesta a esta pregunta será en general mala. El coste "final" de contratar una web varía enormemente entre el contratista escogido, el pais donde se contrate, el tipo y tamaño de la web que se vaya a realizar, si se mezcla con temas de identidad corporativa y recursos adicionales (logo, colores corporativos, ...)

Sólo como orientación muy general una web como la de icarto.es contratada a una agencia española puede estar entre 500€ y 4000€ dependiendo de los factores mencionados antes.

El tiempo de entrega puede estar entre un par de semanas y un par de meses. Pero en gran medida dependerá más del propio cliente que del contratista, que debe tomar decisiones, entregar textos, ... en los plazos convenidos. El coste y tiempos internos de la entidad no debe ser nunca despreciado. Si la nueva web viene acompañada de una reflexión sobre lo que se quiere transmitir, redactar los textos, escoger imágenes, ... debe preveerse que pueden ser decenas de horas.

En ocasiones la entidad que quiere una nueva web decide contratar por separado el contenido (textos, ...) de la web en sí. Generalmente esto es una mala idea. Nadie va a poder definir la entidad mejor que uno mismo, y meter a otro intermediario complicará la coordinación. Si se necesita ayuda para la redacción, preparar las imágenes, depurar lo que se quiere contar, ... es conveniente que la propia empresa contratada para montar la web pueda prestar esta ayuda.

## Contenido y maquetación de la página

-   El contrato debe reflejar que la web debe ser "responsive" esto es verse correctamente tanto en pantallas pequeñas como un móvil como en pantallas grandes
-   No se deben incluír "iconos" de redes sociales como Twitter, Facebook, etc... que la entidad no tenga en ese momento. Y no se recomienda crear cuentas "por qué sí" sin que haya una políca de comunicación preparada para usar esos servicios
-   En general, debe revisarse que no hay enlaces que apunten a ningún sitio. Por ejemplo que el logo de un financiador parezca "clickable" pero en realidad el enlace no apunte a ningún sitio o apunte a un sitio incorrecto.
-   Según como sea la página, que servicios de terceros use, cual sea el país donde esté registrada la organización, ... puede haber una serie de aspectos legales que la página debe cumplir. Como proponer al usuario aceptar las cookies, incluír un texto sobre la privacidad o las condiciones de uso, ... Especifica en el contrato que la empresa que haga la web debe proporcionar los textos base e informar a la entidad contrante sobre los aspectos legales que se puedan aplicar.

## Otras consideraciones

-   Forma de pago. Muchos proveedores de hosting y sericios relacionados únicamente admiten el pago mediante tarjeta de crédito. Esto es un problema para muchas entidades en algunos contextos. Antes de escoger un servicio en particular investiga lo relacionado con forma de pago, tasas, ...
-   Cuando se deja de pagar el hosting, y tras un periodo de gracia, la empresa de hosting elimina totalmente los contenidos. Volver a montar la web sale más caro que pagar en el plazo correcto, así que este gasto debe ser priorizado
-   La mayoría de proveedores de hosting admiten el pago de varios años de servicio en un sólo ingreso, lo que además puede tener descuentos. Especialmente si se está aprovechando algún tipo de financiación externa que lo permita y el proveedor es de confianza, aprovecha para hacer un ingreso que cubra varios años.
-   Mantenimiento externo. Muchas empresas ofrecen el mantenimiento básico de la web. Esto puede incluir (o no) el subir nueva información que proporcione el cliente. Es una opción válida que debe considerarse con cuidado puesto que suele tener un precio elevado. En algunos países debe además dejarse claro a quien pertenece la web y pedir copias periódicos del software, contenido y claves de acceso para que si en algún momento se quiere cambiar de proveedor este no "secuestre" la web.
-   Cuando la web esté disponible pide una copia de seguridad de todos los ficheros y de la base de datos si hay una. Hay que intentar probar que esa copia de seguridad realmente se puede restaurar y la web es igual a la desplegada. En el caso de páginas web dinámicas, tipo Wordpress, deberías solicitar que se configurara algún tipo de copia de seguridad automática. La periodicidad de esta copia puede ir en función de lo que se actualizen contenidos. Si es frecuente una vez al mes puede estar bien, si es más ocasional cada seis meses es suficiente. Además se debe revisar que esa copia se está realizando y es restaurable.
-   En el caso de webs dinámicas define desde el principio quien va a ser la persona encargada de actualizar el software y cada cuanto lo va a hacer.
-   Exige por contrato que no se modifique directamente el software que se use para crear la web. Especialmente en el caso de webs dinámicas como Wordpress, cualquier funcionalidad que no venga por defecto, o cambios de aspecto debe ser incluída a través de plugins o temas derivados. De lo contrario mantener el softare actualizado puede ser muy complicado. Por ejemplo: "No se deben realizar directamente modificaciones en el core o los temas del software que se use para crear la web. Debe trabajar con temas derivados, incluyendo plugins o creando nuevos plugins, prefiriendo siempre la reutilización de código ya existente"
-   Pide que incluyan algún servicio de estadísticas de uso de la página. Algunos hostings proporcionan herramientas muy básicas para esto. Puedes evaluar con el proveedor si son suficientes. En general deberás usar un servicio proporciona por un tercero. Lo más habitual es Google Analytics. Es muy completo y gratuito. Las funcionalidades básicas son sencillas de interpretar, aunque un uso avanzado es bastante complejo. Si se prefiere prescindir de Google servicios como [Clicky](https://clicky.com/) o [StatCounter](https://statcounter.com/) tienen una capa gratuita suficiente. Si prefieres software libre la mejor opción es [Matomo](https://matomo.org/) pero el servicio alojado no tiene capa gratuita y empieza en 19€/mes.
-   Cuando sea necesario registrar una cuenta en un servicio, el hosting, el servicio de estadísticas, ... pide que la cuenta primaria sea una dirección de correo asociada a la entidad. Y recuerda pedir el usuario y contraseña de todo. Acceso al hosting, estadísticas, acceso al dominio si está registrado por separado, servicios de comentarios, control de spam, ... si se están usando, ...

## Checklist

Son muchos los aspectos a tener en cuenta si quieres contratar una web de la forma correcta, así que aquí un resumen de lo que deberías incluir en los TdR o validar en la entrega:

-   Tecnologías con las que se va a crear la web. Háblalo antes de contratar
-   Que dominio se va a usar si se va a crear uno nuevo, el coste anual, y donde se va a contratar
-   Habilitar https por defecto y redireccionar las conexiones http a https
-   En que proveedor de hosting se va a alojar la web y coste anual
-   Revisar la forma de pago y tasas de los distintos servicios (hosting, estadísticas, ...) que se contraten
-   Página web _responsive_ y no modificar el código del core o del tema. Usar plugins y temas derivados.
-   Pedir la copia de seguridad del despliegue inicial y las contraseñas de todo
-   Inclusión de un servicio de estadísticas
