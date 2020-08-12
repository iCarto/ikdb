# Spell Check de páginas web

En este apartado comentamos algunas estrategias enfocadas en la validación de la _prosa_ de páginas y aplicaciones web.

## Linters online

Hay servicios online a los que se les puede pasar una url o dominio y _escrapean_ toda la web o una página concreta en busca de problemas. Las soluciones gratuitas que se han probado no funcionan demasiado bien. Tiene problemas como fallar al detectar el idioma de la página, malos resultados en general, complejidad para excluir palabras o visualizar los resultados.

Además por su propia naturaleza sólo funcionarán con páginas web públicas y no durante el desarrollo o que tengan control de acceso.

Algunos ejemplos de este tipo de servicios:

-   https://datayze.com/website-spell-checker
-   https://typosaur.us/
-   https://www.powermapper.com/products/sortsite/checks/website-spell-checker/

También hay servicios de pago que no hemos probado pero que seguramente funcionen mejor:

-   https://www.inspyder.com/products/InSite
-   https://checkdog.com/

## Otras cosas

-   Las extensiones de los navegadores tampoco funcionan demasiado bien

-   Para corregir una falta en varios ficheros `sed` es nuestro amigo: `sed -i 's/Correjir/Corregir/' *.html`
-   Para ver los cambios `word-diff` es nuestro amigo:

-   Una opción que funciona, aunque tal vez no muy cómoda es marcar (con javascript) toda la página como editable y checkeable. En Chrome hay que ir clicando bloque a bloque para que se active el corrector, pero en Firefox no es necesario.

```
document.body.contentEditable = true;
document.designMode = 'on';
document.getElementsByTagName('html')[0].spellcheck = true;
```

-   Una opción que podría funcionar bien es scrappear la página y pasarle por un corrector como hunspell
    https://stackoverflow.com/questions/585583/how-do-you-spell-check-a-website

-   Para páginas "estáticas" una combinación de comandos de shell puede ser suficiente, para casos básicos. Pero aún así es algo tedioso.

(cat ignore_words ; lynx -dump --nolist http://fonsagua.github.io/fonsagua/) | hunspell -a -d es_ES | grep .

Empezando por el final:

-   `grep .`: Elimina las líneas vacias de la salida para evitar ruido
-   `hunspell -a -d es_ES`: Pasamos a hunspell el diccionario que queremos usar y le decimos que parsee la entrada (que en este caso viene por la entrada estándar del pipe) en modo 'a'. En este modo, las líneas de la entrada que vengan con una serie de prefijos serán tratadas de forma especial. Por ejemplo las líneas estilo `@PALABRA` harán que _PALABRA_ (coincidiendo mayúsculas, ...) sea considerada una palabra válida.

Usaremos @ para nombres propios o palabras que queremos que ignore exactamente sin variaciones
Usaremos \* para que ignore varicaciones de la palabra (mayúsculas, ...)

-   Usamos una subshell `( command1 ; command2 )` y `;` para agrupar todo el resultado de la salida de los comandos que hay dentro en un único texto antes de pasárselo a hunspell
-   Usamos lynx para generar una representación de texto de la página de interés sin los links al final
-   _ignore_words_ será un fichero con las palabras que nos interese ignorar (el fichero debe acabar con una línea en blanco):

Una de las opciones interesantes de lynx es que podemos usarlo para ficheros locales

(cat ignore_words ; lynx -dump --nolist \*.html) | hunspell -a -d es_ES | grep .

En realidad en este caso podemos simplificarlo porque hunspell es capaz (o al menos eso parece) de leer correctamente html

cat ignore_words \*.html | hunspell -H -a -d es_ES | grep .

Por último podemos definir varios diccionarios de control para hunspell, por ejemplo uno de palabras comunes y otro de específicas para el projecto

(cat common_ignore_words ignore_words ; lynx -dump --nolist index.html) | hunspell -a -d es_ES | grep .

```
@ISF
@gvSIG
@JavaScript
@Fonsagua
@Marcovia
@Coray
@GPS
@logo
@NASMAR
@AJAHSA
@PGIRH
@AECID
@CORDES
*pdf
!

```

```
@iCarto
@Cartolab

```

(cat common*ignore_words ignore_words ; lynx -dump --nolist *.html) | hunspell -a -d es*ES | grep .
sed -i 's/Correjir/Corregir/' *.html
git diff --word-diff
git add -u
