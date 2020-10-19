---
title: "Licencias de Software Libre"
author:
    - iCarto
    - Pablo Sanxiao
date: 2020-10-05
license: CC BY-SA 4.0
---

# Licencias de Software Libre

Este documento trata de cubrir los aspectos básicos relacionados con las licencias de software, haciendo especial hincapié en el ámbito del software libre.

El objetivo es dar una visión general al mundo de las licencias de software, qué son, cómo se establecen, qué normativas hay que tener en cuenta... y al mismo tiempo que sirva de guía para todas las iCartians, a la hora de establecer la licencia del software y demás material que desarrollamos.

## Índice

-   ¿Qué es una licencia de software?
-   Normativa aplicable
-   ¿A quién pertenece el código que hago en iCarto?
-   ¿Qué son las licencias de software libre?
-   ¿Qué se debe tener en cuenta a la hora de establecer una licencia?
-   ¿Qué licencias de software libre usamos en iCarto?

## ¿Qué es una licencia de software?

De forma sencilla podemos decir que una licencia de software es un contrato, que se establece entre la persona o entidad creadora del mismo y quien lo usa. En este contrato se establecen todas las condiciones bajo las que se puede usar dicho software y qué se puede hacer con él y qué no.

No es un contrato al uso en el que las partes firman un mismo documento, sino que es un tipo de contrato que se acepta de forma tácita cuando usamos un determinado software. Normalmente la persona o entidad desarrolladora del mismo habrá establecido las condiciones del contrato en el propio software. En el caso del software libre suelen incluirse a través de ficheros que acompañan al código fuente, en cambio en el caso de software privativo lo habitual es que a la hora de instalar o ejecutar el software por primera vez nos aparezca algún tipo de aviso para que leamos y aceptemos las condiciones de uso, esto es, la licencia o contrato.

## Normativa aplicable

En España, todo lo relativo a las licencias de software se encuentra regulado en la [Ley de Propiedad Intelectual](https://www.boe.es/buscar/act.php?id=BOE-A-1996-8930). Esta ley es de aplicación sobre cualquier *obra literaria, artística o científica* que puede aparecer como *libros, escritos, composiciones musicales, obras, coreografías, obras audiovisuales, esculturas, obras pictóricas, planos, maquetas, mapas, fotografías, programas de ordenador y bases de datos*.

Sin entrar en detalles técnicos de la ley, sí es importante conocer que los denominados derechos de autor, que regula esta ley, se dividen en derechos morales y derechos patrimoniales. Como normal general la autora de una obra es la poseedora de ambos derechos.

-   **Derechos Morales**: Es el derecho de la autora a ser reconocida como creadora de una obra, son irrenunciables y no se pierden nunca.

-   **Derechos Patrimoniales**: Es el derecho a explotar comercialmente una obra y decidir qué se puede hacer con la misma. Estos derechos pueden ser cedidos a terceros y tienen una duración determinada, toda la vida de la autora y hasta 70 años después de su muerte. Es mediante la posesión de estos derechos, a través de los cuales se pueden establecer las licencias.

Ahora que sabemos que existen los derechos patrimoniales y que se pueden ceder a terceros, podemos redefinir mejor que es una licencia de software, diciendo que es un contrato de cesión de derechos. Es el mecanismo a través del cual, la persona o entidad poseedora de los mismos decide que se puede hacer con la obra. Existen diferentes tipos de derechos patrimoniales, y la poseedora de los mismos puede decidir si los cede todos en conjunto, o solo algunos de ellos.

Un ejemplo típico de cesión de derechos patrimoniales es el contrato entre una escritora y una editorial, donde la primera, autora de la obra, cede todos o alguno de los derechos patrimoniales a la editorial para que esta se encargue de la distribución y comercialización de la obra.

Una licencia de software también sería un caso de contrato de cesión de derechos, donde la autora o en su defecto la poseedora de los mismos, a su vez cede todos o alguno de esos derechos a las usuarias. El hecho de que se cedan más o menos derechos tendrá incidencia directa para denominar al software como libre o privativo. 

## ¿A quién pertenece el código que hago en iCarto?

La ley establece algunos casos particulares de cesiones tácitas de derechos. Es el caso por ejemplo de las personas trabajadoras por cuenta ajena. Se entiende que los derechos patrimoniales de una obra que se realiza como parte del trabajo que se desempeña por cuenta ajena, pertenecen a la entidad empleadora. Sin embargo se siguen manteniendo el reconocimiento de la autoría a la empleada o empleadas.

## ¿Qué son las licencias de software libre?

El software libre se define como aquel que cumple cuatro libertades: Usar el software para cualquier propósito, poder redistribuirlo, poder modificarlo y poder redistribuir las modificaciones. Ahora que sabemos como funcionan los derechos de autor, podemos decir que esto sería una cesión de todos los derechos patrimoniales. Para llevarlo a cabo, como hemos visto, esto se hace a través de un contrato, que sería la propia licencia de software.

Las licencias de software libre son contratos estándar, que diferentes organizaciones han creado para facilitar la cesión de derechos por parte de las autoras de software. Todas sirven para ceder los derechos a las usuarias, cumpliendo así con las 4 libertades, pero cada una tiene algunas particularidades.

## ¿Qué se debe tener en cuenta a la hora de establecer una licencia?

En cuanto a las licencias en sí, existen dos grandes tipos, las denominadas víricas y las permisivas.

- Las **licencias víricas** son aquellas que obligan a que las modificaciones que se hagan sobre un software se tengan que redistribuir obligatoriamente bajo la misma licencia. Esto surge como un medio de protección, para asegurar que el software seguirá siendo siempre software libre.

- Las **licencias permisivas** por contra, permiten relicenciar las modificaciones, de forma que se pueda usar software libre como base, modificarlo y crear con él un producto privativo.

Por tanto, una de las primeras cosas a tener en cuenta a la hora de establecer una licencia es decidir bajo cual de estos grandes tipos queremos posicionarnos.

Otro de los aspectos principales a considerar, es que el software normalmente no se crea completamente desde cero, sino que se utilizan diferentes piezas que ya existen. Estas piezas de software que usamos, como las librerías de software, tienen su licencia. Como hemos comentado antes, no todas las licencias de software libre son iguales, sino que tienen diferencias entre ellas. Estas diferencias hacen que algunas veces sean incompatibles entre sí. Por tanto, a la hora de elegir la licencia global para un software, habrá que considerar todas las diferentes licencias de cada una de las dependencias que utilizamos para su creación. Eso nos dará un subconjunto de las licencias que podremos escoger como licencia global para todo el software.

## ¿Qué licencias de software libre usamos en iCarto?

Como norma general, en iCarto intentamos usar licencias víricas, de manera que el software que publicamos como software libre, se mantenga así tras su reutilización y modificación por parte de terceros.

Así, elegimos la familia de licencias de la [Free Software Foundation](https://www.fsf.org/es/), siempre que nos sea posible, tras el análisis de dependencias, para nuestro software:

-   [General Public License](https://www.gnu.org/licenses/gpl-3.0.html), GPL, para las aplicaciones en general.
-   [Affero General Public License](https://www.gnu.org/licenses/agpl-3.0.html), AGPL, para las aplicaciones web.

Para el resto de material que publicamos, utilizamos las licencias [Creative Commons](https://creativecommons.org), orientadas a publicar de forma libre obras que no sean software. Estas licencias tienen una serie de cláusulas que se pueden añadir a la licencia base. En nuestro caso utilizamos dos de ellas (CC BY-SA):

-   **BY**: Que obliga a hacer mención siempre al autor original.
-   **SA**: Que obliga a que los trabajos derivados se distribuyan bajo la misma licencia.
