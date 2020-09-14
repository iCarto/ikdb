---
title: "Replicación multi fuente en PostgreSQL"
author:
    - iCarto
    - Francisco Puga
date: 2020-06-20
license: CC BY-SA 4.0
---

# Replicación multi fuente en PostgreSQL

Este documento describe algunas de las opciones disponibles para configurar [source source replication](https://en.wikipedia.org/wiki/Multi-master_replication) en PostgreSQL. A este concepto también se le denomina "master master", "multi active", "source source", "active active", ...

En este documento nos referimos unicamente a un caso de uso de la `replicación multi-source`: dos o más servidores PostgreSQL que se comunican entre sí, para que las operaciones de escritura que se hagan en uno de los servidores se hagan también en el otro. Fundamentalmente esto responde a la situación de organizaciones con varias "oficinas", donde la comunicación entre las mismas no es demasiado rápida y se requiere ubicar un servidor en cada de las "redes/oficinas" que se mantengan sincronizados. A esto se lo denomina a veces "geographically distributed problem".

No contemplamos casos de uso más relacionados con Alta Disponibilidad, Balanceo de Carga o Recuperación de Desastres. Asimismo sacrificamos algo de precisión técnica, a cambio de hacer el texto más comprensible.

Para la problemática que queremos resolver en este caso hay varias cosas más a tener en cuenta:

-   El caso principal es del aplicaciones GIS de Escritorio que se conectarán directamente a uno de los servidores.
-   No es necesario replicar sentencias DDL o que soporte la sincronización de usuarios. En nuestro caso las migraciones de la base de datos se gestionan durante el despliegue, y los usuarios mediante una interfaz web que se encarga de replicarlos a ambos servidores, asignar los roles, adecuados, ...
-   Comunicación asíncrona
-   Debe soportarse que alguno de los servidores esté off-line y sincronice más tarde
-   Buen funcionamiento en una red lenta
-   Las escrituras son escasas y suelen corresponder a "elementos" distintos, por lo que es poco habitual que se produzca un conflicto y una estrategia _last wins_ es suficiente
-   No es necesario sincronizar toda la base de datos si no únicamente algunas tablas.
-   La solución debe ser software libre y gratuita

## Opciones

En PostgreSQL la replicación source-target está disponible en distintas modalidades en el core desde hace tiempo. La replicación _multi source_ todavía [no está totalmente resuelta en el core](https://www.postgresql.org/message-id/flat/CAJvJg-Sc5QpoTqjqxwa05%2B4YkUZn3DWvgL8WOGpkZEMkKtePfw%40mail.gmail.com#903a650ea79ea6aa8911ae715692f231), pero existen extensiones y herramientas para implementarla.

La propia documentación de PostgreSQL mantiene una buena lista de opciones y definiciones que pueden completarse con algunos artículos:

-   [PostgreSQL High Availability](https://www.postgresql.org/docs/current/high-availability.html)
-   PosgreSQL Wiki. [Replication, Clustering and Connection_Pooling](https://wiki.postgresql.org/wiki/Replication,_Clustering,_and_Connection_Pooling)
-   [Análisis de soluciones](https://severalnines.com/database-blog/top-pg-clustering-high-availability-ha-solutions-postgresql) en el blog de SeveralNines, otra empresa de referencia en PostgreSQL
-   [Multi-Master Replication Solutions for PostgreSQL](https://www.percona.com/blog/2020/06/09/multi-master-replication-solutions-for-postgresql/)

En el siguiente listado presentamos algunas de las opciones. Algunas claramente no encajan en nuestros requisitos pero las presentamos porqué aparecen habitualmente entre estas soluciones:

-   [BDR3](https://www.2ndquadrant.com/en/resources/postgres-bdr-2ndquadrant/) y [EPRS](https://www.enterprisedb.com/enterprise-postgres/edb-postgres-replication-server). Buenas opciones de pago con soporte de empresas de primera línea de la comunidad PostgreSQL como 2ndQuadrant y EnterpriseDB. Ambas de pago.
-   [Postgres-XL](https://en.wikipedia.org/wiki/Postgres-XL) y [Citus](https://www.citusdata.com/product). Están enfocados a arquitecturas distribuidas (_clusters_) que necesitan Alta Disponibilidad. No tiene interés para el caso de uso que se expone aquí.
-   [Pgpool-II](https://www.pgpool.net/mediawiki/index.php/Main_Page). Es básicamente un middleware para gestionar un pool de conexiones con muchos extras. Permite por ejemplo, que el cliente se conecte al pool, y las queries sean enviadas a todos los servidores. No cumple bien con los requisitos de asincronía, ni de servidores off-line.
-   [Slony-I](https://slony.info/), Streaming Replication, ... son soluciones enfocadas a source-target que no funcionan en multi source.
-   [rubyrep]. Una solución similar a Bucardo, asíncrona, escrita en Ruby y basada en triggers con posibilidad de sincronizar bases de datos distintas (PostgreSQL, MySQL, ...). -Es- Era, una solución muy interesante pero [no se actualiza desde 2017](https://github.com/rubyrep/rubyrep/issues/72).
-   Logical Replication. Es una funcionalidad incluida en el core, que permite "enviar a un susbscriptor" los cambios "persistidos" con un formato de mensajes "similar a SQL"
-   [Bucardo](https://wiki.postgresql.org/wiki/Bucardo). Asíncrono, basado en triggers y escrito en Perl. Su desarrollo estuvo parado un tiempo, pero vuelve a tener bastante actividad. Una de las mejores opciones para replicación source-source y para nuestro caso de uso. Las últimas versiones parece soportar sincronizar entre distintas bases de datos.
-   [SymmetricDS](https://en.wikipedia.org/wiki/SymmetricDS). Una solución similar a Bucardo. Asíncrona, basada en triggers y escrita en Java, con lo que puede sincronizar bases de datos de distintos tipos a través de JDBC. No es una de las opciones más conocidas pero está bien mantenida.

### BDR

Bi-Directional Multi-Master Replication (BDR) for PostgreSQL

2ndQuadrant la compañía detrás de BDR lleva mucho tiempo añadiendo parches a PostgreSQL para tener replicación a nivel core. Gracias a ellos tenemos _logical replication_ entre otras funcionalidades.

Las versiones 1 y 2 de BDR son software libre y gratuitas, pero ya no tienen soporte y sólo funcionan con PostgreSQL v9.4 y v9.6 respectivamente. Para la versión 3 de BDR, 2ndQuadrant optó por un modelo de negocio distinto. BDR3 no es software libre ni gratuita.

-   [Hilo de correo donde se clarifica la situación de BDR](https://www.postgresql.org/message-id/flat/6b663aec-7827-998b-bdfd-b9946b002b09%40a-kretschmer.de#2e7146d219d493b028e6b8dfe23f451b)
-   [Repositorio antiguo](https://github.com/2ndQuadrant/bdr)
-   [Página de 2ndQuadrant sobre BDR](https://www.2ndquadrant.com/en/resources/postgres-bdr-2ndquadrant/)

### Logical Replication

No es objeto de este artículo explicar los conceptos de [WAL](https://www.postgresql.org/docs/current/wal.html), [Streaming Replication](https://www.postgresql.org/docs/current/warm-standby.html), [Logical Replication](https://www.postgresql.org/docs/current/logical-replication.html) y [Logical Decoding](https://www.postgresql.org/docs/current/logicaldecoding.html). La documentación de PostgreSQL lo explica y estos artículos valen a modo de resumen:

-   [An Overview of Logical Replication in PostgreSQL](https://www.highgo.ca/2019/08/22/an-overview-of-logical-replication-in-postgresql/)
-   [Replication Topologies in PostgreSQL](https://www.opsdash.com/blog/postgresql-replication-topologies.html)
-   [Replication Between PostgreSQL Versions Using Logical Replication](https://www.percona.com/blog/2019/04/04/replication-between-postgresql-versions-using-logical-replication/)
-   [Using PostgreSQL Logical Replication to Maintain an Always Up-to-Date Read/Write TEST Server](https://severalnines.com/database-blog/using-postgresql-logical-replication-maintain-always-date-readwrite-test-server)

#### Pros

-   El mayor pro de este sistema es que está incluido en el propio core y no es necesario instalar nada adicional, aunque una extensión como [pglogical](https://github.com/2ndQuadrant/pglogical) puede ser de ayuda para obtener funcionalidad adicional
-   Mayor rendimiento en general superior a los sistemas basados en triggers como Bucardo.

#### Contras

-   Uno de los mayores contras es que a pesar de que con _logical replication_ se puede implementar una configuración multi-source y [hay quien lo recomienda](https://www.postgresql.org/message-id/flat/CANmF5MBBG1CmZN2Pp%2BsOK%2BPg7HhoBHasfCnhcbH%3D2ukmHR5_GQ%40mail.gmail.com), hay muy poca documentación que cubra este caso y sigue habiendo recomendaciones recientes de [usar otros sistemas](https://thebuild.com/blog/2018/01/02/a-replication-cheat-sheat/).
-   A pesar de que pglogical está disponible a partir de la v9.4, en el core sólo está incluido a partir de la v10. Por tanto no podemos usarlo con versiones antiguas de PostgreSQL.
-   En caso de conflicto [la replicación se para](https://www.digitalocean.com/community/tutorials/how-to-set-up-logical-replication-with-postgresql-10-on-ubuntu-18-04#step-5-%E2%80%94-testing-and-troubleshooting) hasta que sea resuelta a mano.

### SymmetricDS

[SymmetricDS](https://www.symmetricds.org/) es Software Libre (GPL v3) y gratuito con una [versión pro de pago](https://www.jumpmind.com/products/symmetricds/editions). Está escrito en Java y puede ser desplegado en modo standalone, como un war en un servidor de aplicaciones o empotrado en una aplicación (por ejemplo para dispositivos móviles). Usa JDBC por lo que soporta la replicación entre distintos sistemas de bases de datos, y la comunicación se produce a través de http(s) para reducir problemas de puertos, firewalls, ...

Es asíncrona y funciona basada en triggers, y un demonio externo. Tiene capacidades de ETL y distintas opciones como remapeado de tablas y columnas. Está preparado para situaciones de ancho de banda baja, o que las replicas no estén disponibles, intentando "resincronizar" de forma periódica.

A pesar de que no es una de las opciones habitualmente recomendada en PostgreSQL está por ejemplo [referenciada por Crunchy Data](https://info.crunchydata.com/blog/a-guide-to-building-an-active-active-postgresql-cluster)

#### Pros

-   Es una solución muy flexible en todos los aspectos, tanto de casos de uso como de configuración
-   Buena documentación

#### Contras

-   No está integrado en el core si no que requiere la instalación de al menos Java 8.

### Bucardo

[Bucardo](http://bucardo.org/wiki/Bucardo) es lo que en la [terminología](https://www.postgresql.org/docs/current/different-replication-solutions.html) PostgreSQL denominan "Asynchronous Multimaster Replication". Es Software Libre (BSD 2-clause) y gratuita.

Es asíncrona y está basado en triggers con un demonio en Perl que escucha los eventos `NOTIFY`. Requiere de una base de datos donde se realiza toda la configuración de replicación, que puede estar en un servidor distinto al de las bases de datos a replicar. En cada uno de los nodos creará un esquema bucardo donde gestiona información sobre los cambios que deben sincronizarse. El demonio sólo es necesario en el servidor central.

Se puede configurar mediante CLI o manipulando directamente la base de datos de configuración.

Las últimas versiones parece poder sincronizar entre distintas bases de datos, pero la de configuración debe ser PostgreSQL. No hay mucha documentación de su uso en bd que no sean PostgreSQL.

#### Pros

-   La solución gratuita más usada en PostgreSQL
-   Funciona

#### Contras

-   No está instalado en el core, y requiere Perl
-   No tiene muy buena documentación
-   La versión de los repositorios está desactualizada y hay que instalarlo desde fuentes.

## Conclusiones

Las tres opciones _logical replication_ (con o sin pglogical), Bucardo y SymmetricDS parecen cumplir con su cometido para configuraciones multi-source. Escoger una sobre otra depende de preferencias, como el uso de Java sobre Perl, o de las posibilidades de existencia de un conflicto y el tiempo de resolución manual del mismo.

En iCarto llevamos bastante tiempo usando Bucardo en producción en configuraciones multi-source y lo encontramos lo suficientemente válido para nuestros casos de uso. Si no se tiene experiencia con ninguna de las herramientas, y los casos de uso son los que se describen en este artículo, SymmetricDS también parece una buena opción y está mejor documentado que Bucardo.
