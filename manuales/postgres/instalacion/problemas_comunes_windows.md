# Unable to write inside TEMP environment variable path

![Unable to write inside TEMP](/images/problemas_comunes_windows_images/unable_write_temp_path.jpg)

Este error se suele dar por problemas con la configuración de _Windows Script_. Las causas y por tanto las soluciones son variadas, se sugiere una lista de acciones a probar en orden.

#### Instalar la aplicación como administrador

Botón derecho sobre el ejecutable e _Instalar como administrador_

#### Deshabilitar temporalmente el antivirus

Algunos antivirus impiden escribir en ciertas carpetas, así que es mejor deshabilitarlos temporalmente

#### Asociar ficheros .vbs a Windows Script

WinKey -> Teclear: `regedit` -> Pulsar Intro -> Localizar en el árbol de la izquierda la clave `HKEY_CLASSES_ROOT` -> Localizar dentro de ese árbol la clave `.vbs`

En el panel de la derecha debería aparecer una entrada con `name=(Default)` y `Data=VBSFile` respetando mayúsculas y minúsculas. Si no es así editar para que tenga este aspecto.

![Asociar ficheros .vbs a Windows Script](/images/problemas_comunes_windows_images/damaged_vbs_fixed.png)

[Referencia](https://igordcard.blogspot.com.es/2012/03/unable-to-write-inside-temp-environment.html)

#### Habilitar Windows Script para el usuario actual

WinKey -> Teclear: `regedit` -> Pulsar Intro -> Buscar la clave `HKEY_CURRENT_USER\Software\Microsoft\Windows Script Host\Settings`

Seleccionar la entrada `Enabled` en el panel de la derecha. Si la entrada no existe, botón derecho sobre cualquier lugar del panel de la derecha y seleccionar `New` -> `DWORD Value`. Nombrar al valor como `Enabled`.

Botón derecho sobre `Enabled` y clicar en `Modify`

Cambiar el número de `Value` a `1`

[Referencia](https://in.answers.yahoo.com/question/index?qid=20110529123006AABGsYv)

#### Habilitar Windows Script para todos los usuarios

Repetir los pasos del punto anterior pero en lugar de usar la clave `HKEY_CURRENT_USER`, buscar la clave `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host\Settings`

#### Instalar wsh.inf

WinKey -> Run -> Teclear: `%windir%\inf\` -> Pulsar intro -> Botón derecho sobre `wsh.inf` y seleccionar instalar

[Referencia](https://www.postgresql.org/message-id/1351573815927-5730009.post%40n5.nabble.com)


## Referencias adicionales

* https://dba.stackexchange.com/questions/50273/error-unable-to-write-inside-temp-environment-variable-path
* https://1stopit.blogspot.com.es/2011/01/postgresql-83-and-84-fails-to-install.html
* https://stackoverflow.com/questions/5224042/postgresql-9-install-on-windows-unable-to-write-inside-temp-environment-path

# Failed to load sql modules into the database cluster

A veces aparece también como **Error running post install step. Installation may not complete correctly. Error reading C:/Program Files/PostgreSQL/9.4/postgresql.conf**

0. Poner el ejecutable del instalador en un sitio accesible como c:\
1. Crear en windows una nueva cuenta de usuario con permisos de administrador llamada `postgres`
2. Añadir la cuenta `postgres` a los grupos de `Administrators` y `Power Users`
3. Reiniciar el ordenador
4. WinKey -> Run -> Teclear: `runas /user:postgres cmd.exe`
5. Ir a la ruta donde esté el instalador desde la ventana de comandos `cd c:`
6. Ejecutar el instalador. Simplemente teclar su nombre (la tecla tab completa) y pulsar intro.
7. La cuenta de usuario de `postgres` puede ser eliminada


[Referencia](https://stackoverflow.com/questions/30689251/failed-to-load-sql-modules-into-the-database-cluster-during-postgresql-installat)


# An error ocurred executing the Microsoft VC++ runtime installer

![Error ocurred executing the Microsoft VC++ runtime installer](/images/problemas_comunes_windows_images/error_executing_microsoft_vc.png)

* Crear acceso directo al instalador de postgres
* Botón derecho sobre el acceso directo -> Propiedades
* Localizar el valor "Target Path" y añadir al final del valor: `--install_runtimes 0`
* Quedaría algo como `postgresql-9.3.1-1-windows-x64.exe --install_runtimes 0`

[Referencia](https://stackoverflow.com/questions/4288303/cant-install-postgresql-an-error-occurred-executing-the-microsoft-vc-runtime)

# get_locales.exe unknown signal

![getlocales.exe: child killed : unknown signal](/images/problemas_comunes_windows_images/get_locales_error.png)

## Referencias

* https://stackoverflow.com/questions/48938822/
* http://www.postgresql-archive.org/BUG-11039-installation-fails-when-trying-to-install-C-redistributable-td5813004.html
* https://postgresrocks.enterprisedb.com/t5/About-Postgres-Rocks/PostgreSQL-installation-issues/td-p/673
* https://www.postgresql.org/message-id/7517415E78F5E940BA56E54EFFAC7878011E3EFC%40exch1.domforestry.forestry.gov.uk


# Glosario

* WinKey: Pulsar la [tecla de windows del teclado](https://en.wikipedia.org/wiki/Windows_key) para que se abra el menú. También denominada Windows key, command key o home.
