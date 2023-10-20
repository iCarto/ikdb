## Django: Project vs App

Una duda habitual en Django es que es un proyecto y que es una aplicación.

El problema empieza cuando buscamos el nombre el proyecto y esa primera aplicación, y sigue por cómo estructurar el proyecto:

-   ¿Varias aplicaciones?
-   ¿Una aplicación y diferentes paquetes?
-   Dónde meto mi código, carpetas, un sólo módulo, ...
-   Donde meto `date_utils.py`, `base_models.py`, ...

Es una decisión que cada equipo debe adoptar teniendo en cuenta su contexto. En iCarto no hemos encontrado todavía la organización ideal pero esto es lo que hacemos actualmente:

-   No hacemos DDD, ni usamos alguna variante de Clean Architecture.
-   Nuestros proyectos siguen una estructura monorepo, donde en la raíz están las carpetas
    -   `back`. Backend en Django (API REST) y _back office_ con Django Admin.
    -   `front`. SPA en React
    -   `server`, `scripts`, ...
-   La carpeta `back` es el `project` de Django, y por tanto en `back/back/` irían módulos como `settings.py`
-   Usamos Django Admin para temas de administración, reporting, ... Esté código va en `back` a pesar de contener un _front_. A estas funcionalidades las llamamos _back office_ de modo que la nomenclatura queda más o menos consistente.
-   El código principal del backend estaría en una única _app_ llamada `app` (carpeta `back/app`). Sólo extraemos nuevas _apps_ cuando consideramos que es código reutilizable. Por ejemplo una app _documents_ que contenga código que se use para gestionar ficheros adjuntos y sea bastante común a varios proyectos.
-   Valoramos otros nombres en lugar de `app` como `application`, `main`, `core`, `principal`. No hay ninguno perfecto. Sólo hay que tener la precaución de editar `app/apps.py` para evitar nombres confusos.
-   Valoramos prescindir de la aplicación principal y usar directamente `back`. Lo descartamos porqué en esta carpeta mantenemos código común entre proyectos que no queremos convertir a librería. Es más sencillo hacer copy&paste y ajustar ligeramente que otras estrategias.

En pseudo código

```
cd "${MY_REPO}"
django-admin startproject back back
cd back
python manage.py startapp app
```

### A tener en cuenta

Uno de los conceptos más importante a tener en cuenta al hablar de _apps_ en Django, es que [las migraciones se gestionan por separado para cada _app_](https://doordash.news/company/tips-for-building-high-quality-django-apps-at-scale/). En casos complejos las claves foráneas entre modelos en distintas aplicaciones pueden dar problemas.

### Referencias

-   https://stackoverflow.com/questions/19350785/what-s-the-difference-between-a-project-and-an-app-in-django-world
-   https://docs.djangoproject.com/en/dev/ref/applications/#projects-and-applications
-   https://forum.djangoproject.com/t/why-do-we-need-apps/827
-   https://www.mattlayman.com/understand-django/anatomy-of-an-application/

### TODO

-   Una alternativa sobre la que no nos hemos decidido es usar `back/config` en lugar de `back/back` como nombre y poner el código común _vendorizado_ en otro paquete.
