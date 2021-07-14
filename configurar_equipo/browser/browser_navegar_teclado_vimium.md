# Usar el teclado para navegar por páginas web

Disminuir el uso del ratón al usar el ordenador tiene efectos beneficiosos para la salud y la productividad.

Una de las situaciones donde habitualmente se usa más el ratón es al navegar por páginas web. Pero hay _plugins_ para el navegador que nos ayudan a evitarlo.

Nuestro preferido es [Vimium](https://vimium.github.io/), un plugin para Firefox, Chrome y familia que permite usar las teclas de Vim para navegar. Tiene millones de opciones avanzadas pero las básicas y en general suficientes son:

-   `j` y `k` para desplazarse arriba y abajo en la página
-   `f` o `F` (de _follow_). Activa lo que llaman _hint mode_. Detecta todos los enlaces de la página y los marca con unas letras amarillas al lado. Al pulsar la secuencia de letras sigue el enlace. En la misma pestaña si se ha usado `f`, en otra pestaña si se ha pulsado `F`, o se teclea la secuencia en mayúsculas. Se puede usar `Escape` para desactivar los _hints_. Nuestras teclas preferidas de largo. Según como esté construida la página esta opción funciona también para aceptar avisos de cookies, ...
-   `b` para abrir un enlace que tengamos en los marcadores en la pestaña actual. Con `B` lo abrimos en otra pestaña.
-   `x` para cerrar la pestaña actual. Y `X` para abrir la última pestaña cerrada
-   `o` para abrir un enlace en la pestaña actual. Con `O` lo abrimos en otra pestaña
-   `shift + t` para abrir un listado de los tabs abiertos
-   `yy` copiar la url actual al portapapeles

En la web de Vimium hay un _cheatsheet_

## Limitaciones

Hay algunas páginas con las que no se lleva nada bien, como Gmail, y tampoco funciona cuando se abre una nueva pestaña en blanco.

## Referencias

-   https://github.com/brookhong/Surfingkeys
-   https://github.com/ueokande/vim-vixen
-   https://github.com/philc/vimium
-   https://pakstech.com/blog/browse-web-with-keyboard/
