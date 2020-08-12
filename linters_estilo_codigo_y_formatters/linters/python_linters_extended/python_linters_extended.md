# Algunos comentarios sobre reglas que usamos en los linters


## Regla CCE001 sobre el orden de los atributos

* https://github.com/best-doctor/flake8-class-attributes-order

> ¿Merece la pena configurar esta extensión, hacerle caso o ignorar los avisos?

Mantenemos el plugin configurado por defecto

* Por defecto para no tener que andar con configuraciones que siempre es más lio (por ejemplo al actualizar versión). 
* Poner `class Meta` arriba en lugar de abajo, o las fk abajo en lugar de arriba no son decisiones que afecten a la legibilidad, son decisiones estéticas. A alguien le gustará más de una forma que otra. Pero que esté ordenado de una manera consistente si que afecta a la legibilidad.

# Regla WPS331 Found variables that are only used for return statements

> Tener un return a veces mejora la legibilidad del código.

Dudoso.

* Por un lado crear la variable y luego meter el return ayuda a depurar. Pero suena a usar `print` en lugar del debugger.
* El nombre de la variable ayuda a saber que se devuelve. Pero si se necesita ese nombre de variable para saber lo que está devolviendo la función, es que la función está mal escrita.