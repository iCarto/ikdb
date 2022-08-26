# Generación de Esquemas OpenAPI y Documentación de API REST desde Django Rest Framework

Para diseñar, documentar o incluso codificar una _HTTP API_ (o sus clientes) hay especificaciones y herramientas que hacen el trabajo mucho más sencillo y bajo estándares comunes.

_Nota: En este documento usamos de forma indistinta los términos `HTTP API`, `REST API` y similares por simplificar._

En este artículo presentamos:

-   **OpenAPI**: La especificación más popular para _HTTP APIs_.
-   **drf-spectacular**: Una herramienta que permite generar esquemas OpenAPI a partir de Django Rest Framework.
-   Otras herramientas relacionadas como generadores de código de cliente, y de documentación de la API

## OpenAPI Specification (OAS)

[OpenAPI](https://www.openapis.org/) es el claro ganador de la guerra de formatos para especificar APIs. Además es bastante compatible con [JSON Schema](https://json-schema.org/), y en teoría se podría combinar con [JSON:API](https://jsonapi.org/)

Por el camino se quedaron otras especificaciones como [RAML](https://raml.org/), [API Blueprint](https://apiblueprint.org/), [oData](https://www.odata.org/)

Un _OpenAPI schema_ es un documento YAML (o JSON) que describe la API usando el formato (_keys_, _values_, ...) que indica la _OpenAPI Specification_.

El [ecosistema](https://github.com/OAI/OpenAPI-Specification/blob/main/IMPLEMENTATIONS.md) generado en torno a OpenAPI es enorme:

-   Herramientas gráficas para diseñar APIs que generan el esquema y editores (o plugins para editores)
-   Interfaces de usuario que a partir del esquema generan páginas web interactivas, con la opción de ejecutar peticiones a la API
-   Generación de código automática para cliente y servidor a partir del esquema
-   Generación automática de los esquemas a partir del código del _backend_
-   Herramientas para _mock_ y _testing_
-   ...

### Historia

[Swagger comenzó en 2010](https://en.wikipedia.org/wiki/OpenAPI_Specification) como iniciativa de una empresa para proveer de una especificación para API REST y una plataforma o conjunto de herramientas que explotaran esa especificación. En 2015 la empresa propietaria de la especificación la donó a una fundación específica patrocinada por la Linux Foundation y otras (Google, IBM, Microsoft, ...). En 2017, se publicó la primera versión de OpenAPI, aunque en realidad se paso de Swagger 2.0 a OpenAPI 3.0. En 2021 se publico OpenAPI 3.1.

Por tanto OpenAPI es la especificación abierta y sobre la que hay construidas un montón de herramientas por distintos proveedores libres y privativos, y [Swagger](https://swagger.io/) es una de las principales empresas (o marcas) en proveer herramientas sobre OpenAPI (algunas libres y gratuitas mientras que otras privativas y de pago)

### JSON Schema vs OpenAPI vs JSON:API

JSON Schema habla más de los datos en sí y su validación. OpenAPI se dedica más al servicio (REST), endpoints, como usar la API. JSON:API es una propuesta de como diseñar APIs, que podrían ser descritas con OpenAPI y/o JSON Schema.

[JSON API, OpenAPI and JSON Schema Working in Harmony](https://apisyouwonthate.com/blog/json-api-openapi-and-json-schema) es un artículo recomendable al respecto.

## Documentación e Interfaz de Usuario

Hay herramientas que leen el esquema OpenAPI (en YAML o JSON) y a partir de él generan páginas web que sirven a modo de documentación de la API y cómo entorno de prueba para ejecutar peticiones.

Las dos más populares son:

-   [Swagger UI](https://swagger.io/tools/swagger-ui/). html/js/css
-   [ReDoc](https://github.com/Redocly/redoc). Basado en React.

## Generación de Código de Cliente

Hay una gama de herramientas que a partir del esquema permiten generar código en distintos lenguajes para interactuar con la API a modo de SDK o desde nuestra propia SPA.

[Django and OpenAPI: Front end the better way](https://www.saaspegasus.com/guides/modern-javascript-for-django-developers/apis) es un artículo **muy recomendable** al respecto.

Entre las herramientas más conocidas están:

-   https://github.com/swagger-api/swagger-codegen
-   https://openapi-generator.tech/

## Generación de esquemas OpenAPI

La mayoría de frameworks web tienen funcionalidades en el core o a través de plugins para la generación de los esquemas OpenAPI.

En el caso de Django tanto [django-ninja](https://github.com/vitalik/django-ninja) (un paquete estilo FastAPI para Django), como Django Rest Framework lo tienen.

### Django Rest Framework

DRF permite _out of the box_ la [generación de esquemas OpenAPI](https://www.django-rest-framework.org/api-guide/schemas/), y con [poco esfuerzo extra](https://www.django-rest-framework.org/topics/documenting-your-api/) se puede usar SwaggerUI o Redoc para generar la documentación:

Pero la opción por defecto tiene algunas limitaciones y hay dos paquetes que proporcionan características extra:

-   [drf-yasg](https://github.com/axnsan12/drf-yasg) El más popular. Pero no tiene (ni preveé tener) soporte para OpenAPI 3.0. Sólo soporta la versión 2.
-   [drf-spectacular](https://github.com/tfranzel/drf-spectacular/). Con soporte para 3.0 pero [no para 3.1](https://github.com/tfranzel/drf-spectacular/issues/378). Muy similar en funcionalidad a drf-yasg.

Tanto drf-yasg como drf-spectacular permiten generar un esquema OpenAPI a partir del código escrito sobre DRF y ajustarlo mediante hooks (código específico), configuración, decoradores, ...

También permiten generar vistas de Django desde la que servir el propio esquema, o la documentación con Redoc o SwaggerUI.

## Conclusiones

-   Investigar OpenAPI y su ecosistema merece la pena aunque no tengas necesidad de publicar APIs.
-   drf-spectacular es el camino a seguir si quieres documentar una API escrita con DRF.
-   Investigar con más detalle los casos de uso de las herramientas para generar código y documentar la API es interesante si tienes necesidades específicas. Si no, cualquiera de ella te valdrá.
