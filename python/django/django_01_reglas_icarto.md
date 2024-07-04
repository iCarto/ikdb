# Algunas reglas sobre proyectos Django en iCarto

-   Llamamos `back` al proyecto y `app` a la aplicación principal. Ver [django_project_vs_app](./django_project_vs_app.md)

## Modelos

-   Todos los modelos deben definir un `__str__` significativo. En general:

    -   No se deben referenciar campos de relaciones para evitar queries innecesarias.
    -   No se debe definir en un modelo _base_ porqué complica la detección de [DJ008](https://docs.astral.sh/ruff/rules/django-model-without-dunder-str/) y en el modelo base es difícil que `__str__` realmente tenga significado.

### Choices

Cuando definimos `Choices` usamos específicamos tanto el `value` como el `label` y ponemos en general el `value` igual al `label`.

-   Explícito mejor que implícito en este caso. Es fácil confundir el name (`DRAFT`), el value (`DF`), con el label (`Draft`), así que ponemos los tres.
-   A pesar de que en los tutoriales se suele un nombre corto para el value y un nombre largo para el label, hay pocos motivos para ello. ¿Quien prefiere ver en la base de datos un `DF` en lugar de un `Draft`?
-   Un motivo razonable para no hacerlo es cuando hagamos i18n `DRAFT = 'DF', _('Draft')`
-   En general no usaremos `choices` si no tablas en base de datos que podamos referenciar mediante FK.

```
# No
class Status(models.TextChoices):
    DRAFT = 'DF', 'Draft'
    PUBLISHED = 'PB', 'Published'

# Sí
class Status(models.TextChoices):
    DRAFT = 'Draft', 'Draft'
    PUBLISHED = 'Published', 'Published'
```
