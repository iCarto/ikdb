# Fail2ban

[Github](https://github.com/fail2ban/fail2ban) · [Wiki](https://www.fail2ban.org/wiki/index.php/Main_Page)

## Características

---

- Cliente/Servidor.
- MultiThreading.
- Autodetección del formato de la fecha en los logs.
- Soporte para bastantes servicios como ssh o apache.
- Soporte para realizar acciones como iptables o envío de correos.
- Compatible con SystemD y SystemV.
- Usa una base de datos SQLite3 para guardar los baneos.

## Funcionamiento

---

Fail2ban es una herramienta que actua como _Sistema de Deteccion de intrusos (IDS o HIDS)_. Lo hace escaneando los ficheros de log de diferentes servicios utilizando reglas definidas mediante expresiones regulares (_filter-rules_).
Esto le permite detectar IPs que muestren un comportamiento malicioso como: multiples fallos de autenticación, escaneo de puertos, busqueda de exploits...

Tras detectar una direccion IP con un comportamiento sospechoso ejecutará una accion (_action_) sobre ella. Esta accion generalmente consiste en actualizar las reglas del Firewall (UFW, iptables, nftables...)
permitiendo rechazar las conexiones durante cierto periodo de tiempo. Ademas de esto tambien permite configurar acciones personalizadas, como el envio de mails.

La combinación de un filtro con una o más acciones se denomina _Jail_. En caso de que el _Jail_ esté activo se utilizaran las reglas y acciones que define para realizar la monitorización. Puede haber varios _Jails_ activos al mismo tiempo.

Tras la instalación, el programa puede acceder a ficheros de logs estandar como sshd o Apache, utilizando filtros y reglas predefinidas. Pero también es posible controlar logs de otros servicios definiendo filtros y acciones personalizadas.

## Dependencias

---

Los requisitos para su instalacion en su versión actual (1.0.2) son Python 2 (version>=2.6), Python 3 (version>=3.2) o PyPy.

### Instalación

---

En el caso de que existan paquetes en los repositorios de la distribucion se recomienda su uso. En caso contrario pueden compilarse las fuentes disponibles en el [repositorio oficial](https://github.com/fail2ban/fail2ban) , o descargar un paquete de instalación de la sección de [releases](https://github.com/fail2ban/fail2ban/releases).

Para instalar desde repositorio :

```shell
apt update
apt install fail2ban
```

### Servicios con los que trabaja

---

- SSH
- Servidores web lighttpd, nginx y Apache.
- Servidores ftp vsftpd, proftpd, pure-ftpd, wuftpd.
- Servidores de email Postfix, exim, squirrelmail, Courier, dovecot, sasl.
- Servicios de proxy como Squid.
- Otros servicios como Asterisk, FreeSWITCH, Drupal, WordPress.

Estos son algunos de los filtros preinstalados para estos servicios

    Apache    
    - apache-auth.conf, errores de autenticación de Apache
    - apache-badbots.conf, spam bots y bad web crawlers
    - apache-botsearch.conf, requests de urls que no existen
    - apache-fakegooglebot.conf, errores por intento de crawl de bots que utilizan un falso user agent de Googlebot
    - apache-modsecurity.conf, detecta avisos de modsecurity web application firewall
    - apache-nohome.conf, detecta errores en el acceso al directorio home
    - apache-noscript.conf, detecta busqueda oitebcuak de exploits y vulnerabilidades php
    - apache-overflows.conf, intento de realizar un ataque de overflow del buffer de Apache
    - apache-pass.conf,
    - apache-shellshock.conf, intento de explotar la vulnerabilidad shellshock

    SSH
    - sshd.conf, errores de inicio de sesión SSH

    Postfix
    - postfix.conf, errores de autenticación de Postfix SMTP y SASL

    NGINX
    - nginx-botsearch.conf, errores por peticiones de URLs que inexistentes
    - nginx-http-auth.conf, errores de autenticación
    - nginx-limit-req.conf, errores por limite procesamiento de peticiones de una IP

    (...)

Es posible configurar servicios personalizados utilizando filtros creados por la comunidad y organizaciones o crear filtros personalizados como se explica en la seccion **Configurar un servicio personalizado**.

### Configuración

---

Los ficheros de configuración de Fail2Ban se encuentran en la carpeta `/etc/fail2ban`:

- `filter.d`: Esta carpeta contiene archivos en los que se definen expresiones regulares para parsear los logs.

- `action.d`: Esta carpeta contiene archivos que defininen las acciones a realizar.

- `jail.d`: Esta carpeta contiene los diferentes _Jails_.

- `fail2ban.conf`: Dentro de este fichero se puede modificar el nivel de logging, ruta al log de la aplicacion, base de datos MySQL3 utilizada por fail2ban o tiempo que se almacena la información de los bans...

- `paths-xxx.conf`: Contienen las rutas a los logs y backends de los servicios. Existe una configuración _common_ generica, que se sobreescribe con las definiciones de la configuración especifica de la distribucion utilizada.

- `jail.local`: Donde se configuran los servicios a monitorizar.

Fuera de esta carpeta el fichero `/etc/default/fail2ban` se utiliza para definir opciones de linea de comandos para ejecutar el programa y el usuario por defecto .

### Jail.conf

---

En primer lugar es necesario realizar una copia del fichero `jail.conf` renombrandolo a `jail.local`. Ya que el original se sobreescribe durante las actualizaciones, y utilizarlo implica un riesgo de perder los cambios que hayamos realizado.

```shell
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

En este fichero y en los de la carpeta jail.d se encuentran las configuraciones de todos los _Jails_ que podemos usar. En un principio estan todos deshabilitados excepto el sshd.

En el apartado [DEFAULT] de este fichero se definen los valores predeterminados para la política fail2ban. Estas opciones pueden sobreescribirse en la sección de configuración de cada servicio individual, estas son algunas:

- `ignoreip`: Permite introducir IPs en un [whitelist](https://www.fail2ban.org/wiki/index.php/Whitelist) para evitar el baneo.
- `bantime`: El tiempo que dura el baneo en segundos, (-1 = permanente).
- `bantime.increment`: Define si se incrementa el tiempo de baneo al reincidir.
- `maxretry`: Numero de fallos antes del baneo.
- `findtime`: Tiempo en el que se contabilizan los fallos para un baneo en segundos

Aqui algunas de las que se utilizan para definir cada servicio:

- `enabled`: true o false. Activa o desactiva la protección para un determinado servicio
- `port`: puertos en los que trabaja el servicio que queremos proteger.
- `filter`: Nombre del filtro que usa el jail para detectar coincidencias. Cada coincidencia incremente el contador del jail.
- `logpath`: Ruta al fichero de logs que se le
  va a proporcionar al filtro (/var/log/messages).
- `action`: Define las acciones de bloqueo que se aplicarán en cada uno de los servicios.
- `usedns`: Utilizar IPs u obtener nombre de Host para realizar el baneo.
- `destemail`: Dirección a la que se enviarán las notificaciónes si se configura el envio de alertas por correo en las acciones.
- `sender`: Dirección con la que fail2ban enviará los emails.
- `sendername`: Nombre que aparecerá en los correos electrónicos de notificación generados.
- `banaction`: establece la acción que se usará cuando se alcance el umbral.
- `protocol`: Tipo de tráfico que se eliminará (TCP, UDP).
- `mta`: programa con el que se envia el mensaje (postfix, sendmail)
- `bantime`.
- `maxretry`.
- `findtime`.

### Configurar un servicio personalizado

---

En esta documento sobre el [desarrollo de filtros](https://fail2ban.readthedocs.io/en/latest/filters.html) se explica como crear un filtro personalizado. Es necesario asegurarse de que los servicios que van a ser monitorizados almacenen los logs mas severos con fallos de autenticación en su fichero log de errores. Tras eso se debe escoger las lineas que corresponden al error que nos interesa. La linea de log debe contener un time stamp y la ip que realiza la acción.

El desarrollo del filtro se realiza utilizando el formato de las expresiones regulares de Python. ([Python Docs](https://docs.python.org/2/library/re.html)) Para comprobar el funcionamiento de las expresiones regulares se utiliza el comando `fail2ban-regex --help`. Tras crear el filtro se añade al fichero `jail.conf`, se configura a la ruta a los logs, y se le asigna una acción.

### Configuración para Redmine

---

Los pasos a seguir para configurar un filtro para redmine están descritos en la [Wiki](https://www.redmine.org/projects/redmine/wiki/HowTo_Configure_Fail2ban_For_Redmine) de Redmine.

Pasan por crear un filtro en el fichero `/etc/fail2ban/filter.d/redmine.conf` con el siguiente contenido:

```conf
# redmine configuration file
#
# Author: David Siewert
#
# $Revision$
#
[INCLUDES]

# Read common prefixes. If any customizations available -- read them from
# common.local
before = common.conf

[Definition]

datepattern = %%Y-%%m-%%d %%H:%%M:%%S %%Z$
failregex = Failed [-/\w]+ for .* from <HOST>

# Option:  ignoreregex
# Notes.:  regex to ignore. If this regex matches, the line is ignored.
# Values:  TEXT
#
ignoreregex =

# Source:
#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8
```

y añadir al fichero `/etc/fail2ban/jail.conf` el siguiente codigo en la seccion de _Jails_:

```conf
[redmine]
enabled  = true
filter   = redmine
port     = 80,443
#backend  = polling
action   = iptables-allports[name=redmine]
logpath  = /var/log/redmine/default/production.log
maxretry = 5
findtime = 7320
bantime  = 7320
```

Reemplazando el `logpath` con la ruta que corresponda al log de tu instalación. Y si usas puertos distintos al 80 y 443 reemplazarlos.

y por último reiniciar el servicio `/etc/init.d/fail2ban restart`

### Configuración para Nextcloud

---

En la [Wiki](https://docs.nextcloud.com/server/19/admin_manual/installation/harden_server.html?highlight=fail2ban#setup-fail2ban) de Nextcloud explica como generar un filtro para banear usuarios que acceden desde dominios no seguros, fallen al autenticarse a través del interfaz de usuario o WebDAB.

Crear el fichero `/etc/fail2ban/filter.d/nextcloud.conf` que contenga:

```conf
[Definition]
_groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
            ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
```

Crear el fichero `/etc/fail2ban/jail.d/nextcloud.local` con el contenido:

```shell
[nextcloud]
backend = auto
enabled = true
port = 80,443
protocol = tcp
filter = nextcloud
maxretry = 3
bantime = 86400
findtime = 43200
logpath = /path/to/data/directory/nextcloud.log
```

Reemplazando el `logpath` con la ruta que corresponda nextcloud.log de tu instalación. Y si usas puertos distintos al 80 y 443 reemplazarlos.

y por último reiniciar el servicio `/etc/init.d/fail2ban restart`

### Configuración para PostgreSQL

---

En este caso es necesario modificar la información del logs de PostgreSQL añadiendo el Host ID. Editamos el fichero `/etc/postgresql/<VERSION>/main/postgresql.conf` y modificamos el parametro `log_line_prefix = '%h %m [%p] %q%u@%d '`.

Crear el filtro en el fichero `/etc/fail2ban/filter.d/custom-postgres.conf` con el contenido:

```conf
[Definition]
failregex = ^<HOST>.+FATAL: password authentication failed for user.+$
            ^<HOST>.+FATAL: no pg_hba.conf entry for host .+$
ignoreregex = duration:#
ignoreregex =
```

Configurarlo en el fichero `jail.conf`

```conf
[postgresql]
enabled = true
port    = 5432
protocol = tcp
filter = custom-postgresql
logpath = /var/log/postgresql/postgresql-12-main.log
maxretry = 3
```

Configurar el logpath y el puerto para que coincida con los de la instalación. Y por último reiniciar los servicios de fail2ban y postgresql.

### Comandos

---

#### fail2ban-server

Arranca en segundo plano automáticamente al instalarse Fail2Ban y es el proceso principal.

      Opciones disponibles:
      -b                   start in background
      -f                   start in foreground
      -s <FILE>            socket path
      -p <FILE>            pidfile path
      -x                   force execution of the server

#### fail2ban-client

Configura y controla el servidor

      Opciones disponibles
      ------------------------
      -c <DIR>                configuration directory
      -d                      dump configuration. For debugging
      -i                      interactive mode
      -v                      increase verbosity
      -q                      decrease verbosity
      -x                      force execution of the server

      Comandos básicos
      -----------------------
      reload                  reloads the configuration
      reload <JAIL>           reloads the jail <JAIL>
      stop                    stops all jails and terminate the server
      status                  gets the current status of the server
      ping                    tests if the server is alive

      Comandos de log
      -----------------------
      set loglevel <LEVEL>    sets logging level to <LEVEL>.
                              Levels: CRITICAL, ERROR, WARNING,
                              NOTICE, INFO, DEBUG

      get loglevel            gets the logging level

      set logtarget <TARGET>  sets logging target to <TARGET>.
                              Can be STDOUT, STDERR, SYSLOG or a
                              file

      get logtarget           gets logging target

      set syslogsocket auto|<SOCKET>  sets the syslog socket path to
                                      auto or <SOCKET>. Only used if
                                      logtarget is SYSLOG

      get syslogsocket        gets syslog socket path

      flushlogs               flushes the logtarget if a file
                              and reopens it. For log rotation.

      Comandos de BBDD
      ------------------------
      set dbfile <FILE>       set the location of fail2ban
                              persistent datastore. Set to
                              "None" to disable

      get dbfile              get the location of fail2ban
                              persistent datastore

      set dbpurgeage <SEC>    sets the max age in <SECONDS> that
                              history of bans will be kept

      get dbpurgeage          gets the max age in seconds that
                              history of bans will be kept

      Comandos Ban
      ------------------------
      set <Jail> banip <IP>   Banear IP
      set <Jail> unbanip <IP> Eliminar baneo

#### fail2ban-regex

Utilizado para comprobar las expresiones regulares que se van a utilizar en los filtros.

### Ejemplos de uso

---

Recargar la configuración tras realizar un cambio:

```shell
> fail2ban-client reload
```

Ver jails activados:

```shell
> fail2ban-client status
Status
|- Number of jail:  1
  - Jail list: sshd
```

Ver estado de un jail en particular:

```shell
# fail2ban-client status <JAIL>

> fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed:  0
|  |- Total failed:  0
|   - File list:  /var/log/auth.log
  - Actions
  |- Currently banned:  0
  |- Total banned:  0
    - Banned IP list:
```

Tras 5 intentos de autenticación fallida el resultado de el comando es:

```shell
  Status for the jail: sshd
  |- Filter
  |  |- Currently failed: 1
  |  |- Total failed: 5
  |   - File list:  /var/log/auth.log
   - Actions
    |- Currently banned: 1
    |- Total banned: 1
     - Banned IP list: 192.168.1.27
```

Ver reglas que introduce este bloqueo en IPtables:

```shell
> iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
f2b-sshd   tcp  --  anywhere             anywhere             multiport dports ssh

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain f2b-sshd (1 references)
target     prot opt source               destination         
REJECT     all  --  192.168.1.4          anywhere             reject-with icmp-port-unreachable
RETURN     all  --  anywhere             anywhere          
```

Obtener las acciones configuradas para un Jail:

```shell
# fail2ban-client get <JAIL> actions

> fail2ban-client get sshd actions
The jail sshd has the following actions:
iptables-multiport
```

Obtener las IPs bloqueadas por un Jail:

```shell
# fail2ban-client get <JAIL> banned

> fail2ban-client get sshd banned
['99.99.99.98', '99.99.99.99']
```

Comprobar si una o varias IPs han sido baneadas por un Jail, devuelve 1 si ha sido baneada:

```shell
# fail2ban-client get <JAIL> banned <IP> .. <IP>
> fail2ban-client get sshd banned 127.0.0.1
0
```

Bloquear IPs utilizando un Jail:

```shell
# fail2ban-client set <JAIL> banip <IP> ... <IP>
> fail2ban-client set sshd banip 99.99.99.98 99.99.99.99 
2
```

Comprobar IPs bloqueadas por un Jail:

```shell
# fail2ban-client get <JAIL> banip [<SEP>|--with-time]
> fail2ban-client get sshd banip
99.99.99.98 99.99.99.99

> fail2ban-client get sshd banip --with-time
99.99.99.98   2023-01-25 09:04:39 + 600 = 2023-01-25 09:14:39
99.99.99.99   2023-01-25 09:04:39 + 600 = 2023-01-25 09:14:39
```

Desbloquear IPs:

```shell
# set <JAIL> unbanip [--report-absent] <IP> ... <IP>
> fail2ban-client set sshd unbanip 99.99.99.98
1
```

Definir y obtener diferentes parámetros de configuración:

- ignoreip:

```shell
# fail2ban-client set <JAIL> addignoreip <IP> .. <IP>

> fail2ban-client set sshd addignoreip 99.99.99.98 99.99.99.97
These IP addresses/networks are ignored:
|- 99.99.99.98
`- 99.99.99.97
```

```shell
# fail2ban-client get <JAIL> ignoreip
> fail2ban-client get sshd ignoreip
No IP address/network is ignored
```

- findtime:

```shell
# fail2ban-client set <JAIL> findtime <TIME>
> fail2ban-client set sshd findtime 600
600
```

```shell
# fail2ban-client get <JAIL> findtime
> fail2ban-client get sshd findtime
600
```

- bantime:

```shell
# fail2ban-client set <JAIL> bantime <TIME>
> fail2ban-client set sshd bantime 600
600
```

```shell
# fail2ban-client get <JAIL> bantime
> fail2ban-client get sshd bantime
600
```

- logpath

```shell
> fail2ban-client set sshd dellogpath /var/log/auth.log
> fail2ban-client set sshd addlogpath /var/log/auth.log
``` 

### Limitaciones

---

El Daemon Syslog puede utilizar un buffer en sus salidas, dado que fail2ban parsea los logs que genera para detectar actividades sospechosas, esto puede tener un impacto negativo. Llevando a pasar por alto algunas amenazas. [Reaction Time](https://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Reaction_time).

Los ataques low-and-slow tienen un bajo volumen de trafico para intentar evitar la deteccion, en este caso es util modificar el parametro findtime para que se compute un periodo de tiempo mayor para los baneos. [Fail2Ban Vs Low and Slow Attacks](https://mb.com.ph/2023/01/02/fail2ban-vs-low-and-slow-attacks/).

## Alternativas

---

### SshGuard

Es la alternativa más clara a fail2ban.

- Licencia ISC.
- Compatible con la mayoria de sistemas Unix incluido BSD.
- Reconoce ataques sobre:
  OpenSSH, Sendmail, Exim, Dovecot, Cucipop, UWimap (imap, pop), vsftpd, Postfix, proftpd, pure-ftpd, FreeBSD, ftpd.
- Se integra con multiples firewalls:
  FirewallD, ipfw, IPFILTER, netfilter/iptables, netfilter/ipset, PF, tcpd's hosts.allow, IBM AIX's firewall
  [sshguard.net](https://www.sshguard.net/)

### CrowdSec

- Licencia MIT
- Detecta DDoS, abuso de recursos, ataques por fuerza bruta, escaneo de puertos, Escaneo de webs, Bot scraping ...
- Utiliza un motor de reputación de IPs compartidas por la comunidad.
- Dispone de una version comunnity.
[Github](https://github.com/crowdsecurity/crowdsec) · [Docs](https://docs.crowdsec.net/docs/intro)

### Suricata

- Desarrollado por la Open Information Security Foundation (OISF).
- Licencia GPLv2
- Linux/Mac/FreeBSD/UNIX/Windows
[Suricata.io](https://suricata.io/) · [Docs](https://suricata.readthedocs.io/en/suricata-6.0.9)

### Snort3

- Desarrollado por Cisco
- Licencia GPLv2
- Sin coste de instalación dispone de un _Community Ruleset_ para deteccion de amenazas gratuito y otro de pago mediante subscripción anual.
  [Website](https://www.snort.org/) · [Github](https://github.com/snort3/snort3)

### R-FX Brute force Detection

[Web](https://www.rfxn.com/projects/brute-force-detection/)

## Referencias

---

- [Linode: Using Fail2ban to Secure Your Server](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial)
- [Digital Ocean: How To Protect SSH with Fail2Ban on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-20-04)
- [Fail2ban 0.8 Manual](https://www.fail2ban.org/wiki/index.php/MANUAL_0_8)
- [Integración con wordpress](https://blog.shadypixel.com/spam-log-plugin/)
- [Intrusion Detection Systems Explained: 14 Best IDS Software Tools Reviewed](https://www.comparitech.com/net-admin/network-intrusion-detection-tools/)
- [Fail2ban archLinux Wiki](https://wiki.archlinux.org/title/Fail2ban_(Espa%C3%B1ol))
