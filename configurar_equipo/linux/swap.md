# Swap

Hay un par de cuestiones que salen con regularidad cuando se configura un equipo nuevo relativas a la _swap_

-   Es necesario usar swap
-   Tengo que cifrar la partición de swap
-   Va a matar la swap mi disco SSD
-   Puedo optimizar su uso

Situemos el escenario para responder a estas preguntas:

-   Se va a cambiar de equipo en cuatros años
-   Ubuntu 18.04 o superior (o sistemas operativos de la misma fecha)
-   16GB de RAM y SSD. Tal vez también un HDD

Para mi la primera regla es **evitar microptimizaciones**. Si vas a pasar más tiempo configurando el equipo que la ganancia de rendimiento que vas a obtener, la comodidad que vas a perder o el dinero que vas a ahorrar evítalo.

Algunos conceptos de base, sin profundizar en detalles:

-   Los SSD "se estropean" con cada escritura a disco, y usar la swap escribe mucho a disco. Pero en equipos modernos el SSD debería durar sin problemas bastante más de 4 años.
-   Ubuntu ya ha hecho una selección por nosotros [a partir de Ubuntu 18.04](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes#Other_base_system_changes_since_16.04_LTS) se usa un fichero de swap en lugar de una partición de swap. En un disco sin cifrado [no hay diferencias significativas de rendimiento](https://serverfault.com/questions/25653/swap-partition-vs-file-for-performance). Y este fichero lo creo por defecto.
-   Por defecto Ubuntu no usa la swap cuando se queda sin RAM si no mucho antes. Lo agresivo que es el kernel para mover los procesos de RAM a Swap se controla mediante el parámetro `swappiness` que por defecto está a 60 (`cat /proc/sys/vm/swappiness`) y puede valer entre 0 y 100.

**Recomendaciones**

-   Durante la instalación de Ubuntu escoge el SSD como disco principal
-   Cifra el disco con la configuración por defecto de Ubuntu
-   Acepta la configuración por defecto de Ubuntu en cuanto a particiones, swap, ...
-   Disminuye el valor `swappiness`. El número concreto varía según la guía. La única forma de obtenerlo es probar. Yo lo pongo a 15.

```bash
# Editar /etc/sysctl.conf y añadir/editar `m.swappiness=20`
echo -e "vm.swappiness=15" | sudo tee -a /etc/sysctl.conf

# O en lugar de eso se puede crear un fichero propio de configuraciones
echo -e "vm.swappiness=15" | sudo tee -a /etc/sysctl.d/60-custom
```

## Referencias

-   https://askubuntu.com/questions/1100534/it-is-safe-to-have-a-swap-partition-on-the-ssd
-   https://askubuntu.com/questions/652337/why-no-swap-partitions-on-ssd-drives
-   https://superuser.com/questions/764655/is-it-insecure-to-use-a-swap-file-that-multiple-systems-can-read
-   https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption
-   https://askubuntu.com/questions/313564/why-encrypt-the-swap-partition
-   https://ubuntuforums.org/showthread.php?t=2397034
-   https://help.ubuntu.com/community/SwapFaq

## Investigaciones futuras

-   Relación entre swap, TRIM, SSD y cifrar el disco.
-   Se asume que hibernar no es algo que se vaya a usar. Por lo general yo sólo suspendo.
-   Hay alguna diferencia de rendimiento significativa entre usar una partición swap cifrada y un fichero swap en un disco cifrado
-   ¿Merece la pena tocar `vfs_cache_pressure`?
    -   https://doc.opensuse.org/documentation/leap/tuning/html/book.sle.tuning/cha.tuning.memory.html
    -   http://hackingthesystem4fun.blogspot.com/2012/06/reducir-el-io-de-disco-para-escrituras.html
    -   https://www.linuxadictos.com/cache-pressure-optimiza-el-rendimiento-de-linux.html
-   ¿Merece la pena tocar `dirty_writeback_centisecs`?
    -   http://systemadmin.es/2009/09/el-proceso-pdflush
    -   https://wiki.ubuntu.com/ReducedPowerUsage
