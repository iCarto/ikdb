# Django y jQuery

Django Admin usa jQuery e incluye una copia local actualizada entre sus assets estáticos.

Si necesitamos jQuery en nuestro frontend podemos optar por cargar la versión incluída en Django Admin en lugar de una propia.

-   Para usar jQuery en el Admin no es necesario cargarlo de nuevo, sólo tenemos que hacer uso de la variable `django.jQuery` en lugar de `$`, teniendo la precaución de que se haya cargado correctamente. Ver ejemplo al final de este artículo.
-   Para poder usarlo fuera del Admin tendremos que tener `django.contrib.admin` en `INSTALLED_APPS` y haber ejecutado `collectstatic`

Ejemplo de como escribir código JavaScript usable tanto en en el Admin como en el resto de la aplicación.

```javascript
// Django Admin loads a version of jQuery and puts it under django.jQuery name, but
// script load times can make that our code tries to use django.jQuery before it's loaded
// so we use `load` event to wait for other scripts to load.
// We use the IIFE to pass as `$` as parameter as is less "hacky" that redefine
// variables. So we can use the code in Django Admin or other pages.
// In this case, the `$.ready` is not needed as we already wait for `load`, but it's
// here for demonstration purposes.
window.addEventListener("load", function() {
    (function($) {
        $(document).ready(function() {
            $("#id_level0").change(function() {
                const url = $("[data-level1-url]").attr("data-level1-url");
                const level0Id = $(this).val();
                $.ajax({
                    url: url,
                    data: {
                        level0_id: level0Id,
                    },
                    success: function(response) {
                        $("#id_level1").html(response);
                    },
                });
            }
        });
    })(window.$ || django.jQuery);
});
```

## TODO

-   Combinar el jQuery del Admin con el toolchain de JS, para concatenar assets, ...
-   Explicar como cargarlo en Widgets, con "load static", y el tema del init para simplificar el código. https://docs.djangoproject.com/en/3.2/ref/contrib/admin/#contrib-admin-jquery

## Referencias

-   https://stackoverflow.com/questions/58087470/django-jquery-is-not-a-function-message
-   https://github.com/django/django/tree/main/django/contrib/admin/static/admin/js/vendor/jquery
-   https://github.com/django/django/blob/main/django/contrib/admin/static/admin/js/jquery.init.js
