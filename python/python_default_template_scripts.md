# Python: default template for scripts

**Python Version**

-   El código python de iCarto será escrito para python3. Salvo necesidad expresa de lo contrario, en cuyo caso se tratará de escribir código compatible.

**Source File Encoding**

-   Todos los ficheros de código python en iCarto usarán UTF8
-   De [PEP8](https://www.python.org/dev/peps/pep-0008/#source-file-encoding): Files using ASCII (in Python 2) or UTF-8 (in Python 3) should not have an encoding declaration.
-   Por tanto los ficheros de código de python3 no necesitan una declaración de encoding. Sólo se añadirá cuando sea necesaria la compatibilidad entre versiones o cuando se trabaje con python2

**shebang**

-   Todos los scripts llevarán un [shebang](https://stackoverflow.com/questions/8967902)
-   El resto de código lo llevará cuando resulte útil
-   El shebang recomendado por defecto es `#!/usr/bin/env python3` o `#!/usr/bin/env python2`. Cuando sea, a propósito código compatible entre ambas versiones se usará `#!/usr/bin/env python`
-   Este modo de escribir el shebang sólo funcione para sistemas UNIX, pero funciona de modo correcto tanto dentro de un virtualenv como no.
-   https://stackoverflow.com/a/19305076/930271

**main**

-   Por orden, limpieza y reusabilidad, se tratará de usar funciones y clases pequeñas en los scripts, y no volcar todo el código directamente
-   Por sencillez de ejecución se usará el [python idiom de main](https://stackoverflow.com/questions/419163)
-   Debe valorarse en cada caso si `main` es un buen nombre para la función principal del script para que sea más legible cuando se importe desde otros módulos

```
# Error
from foo import main
from bar import main

# Queda raro
from foo import main as foo_main
from bar import main as bar_main

# Buena opción
from foo import main as foo
from bar import main as bar

# Buena opción
import foo
import bar

foo.main()
bar.main()

# Buena opción

from foo import do_something
from bar import do_other_thing
```

**Otros detalles**

-   Por defecto usar argparse. Ver `python_scripts_entrada_usuario_arguments`.
-   Por defecto configurar un logging básico

**Template for Python3**

```python
#!/usr/bin/env python3

import argparse
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main(foo, bar, kkk, jjj):
    pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("foo", help="")
    parser.add_argument("--bar", required=True, help="")
    parser.add_argument("--kkk", help="")
    parser.add_argument("--jjj", action="store_true", help="")
    args = parser.parse_args()
    main(args.foo, args.bar, args.kkk, args.jjj)
```

**Template for Python2**

```python
#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main(foo, bar, kkk, jjj):
    pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="")
    parser.add_argument("foo", help="")
    parser.add_argument("--bar", required=True, help="")
    parser.add_argument("--kkk", help="")
    parser.add_argument("--jjj", action="store_true", help="")
    args = parser.parse_args()
    main(args.foo, args.bar, args.kkk, args.jjj)
```
