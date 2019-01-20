# Python: default template for scripts

**Python Version**

* El código python de iCarto será escrito para python3. Salvo necesidad expresa de lo contrario, en cuyo caso se tratará de escribir código compatible.

**Source File Encoding**

* Todos los ficheros de código python en iCarto usarán UTF8
* De [PEP8](https://www.python.org/dev/peps/pep-0008/#source-file-encoding): Files using ASCII (in Python 2) or UTF-8 (in Python 3) should not have an encoding declaration.
* Por tanto los ficheros de código de python3 no necesitan una declaración de encoding. Sólo se añadirá cuando sea necesaria la compatibilidad entre versiones o cuando se trabaje con python2


**shebang**

* Todos los scripts llevarán un [shebang](https://stackoverflow.com/questions/8967902)
* El resto de código lo llevará cuando resulte útil
* El shebang recomendado por defecto es `#!/usr/bin/env python3` o `#!/usr/bin/env python2`. Cuando sea, a propósito código compatible entre ambas versiones se usará `#!/usr/bin/env python`
* Se recomienda especificar la versión en el shebang como una forma sencilla de saber para que versión de python está el script preparado.
* Este modo de escribir el shebang sólo funcione para sistemas UNIX, pero funciona de modo correcto tanto dentro de un virtualenv como no.
* https://stackoverflow.com/a/19305076/930271

**main**

* Por orden, limpieza y reusabilidad, se tratará de usar funciones y clases pequeñas en los scripts, y no volcar todo el código directamente
* Por sencillez de ejecución se usará el [python idiom de main](https://stackoverflow.com/questions/419163)

**Parámetros de consola**

* El paso de parámetros de la forma especificada en los siguientes ejemplos no tiene porqué ser respetada

**Template for Python3**

```python
#!/usr/bin/env python3

import sys

def main(argv):
    pass

if __name__ == "__main__":
    main(sys.argv[1:])
```


**Template for Python2**
```python

#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys

def main(argv):
    pass

if __name__ == "__main__":
    main(sys.argv[1:])
```

