# Actualizar node y npm

Las distribuciones de Linux suelen tener versiones bastante antiguas de `nodejs` y `npm` en los repositorios de paquetes. Es importante tratar de mantener estas aplicaciones _up-to-date_.

Lo más sencillo es, instalar desde paquetes `nodejs` y `npm` la primera vez. A continuación para mantenerlos actualizados instalamos el paquete `n`

```shell
sudo apt-get install nodejs npm
sudo npm cache clean -f
sudo npm install -g n
```

Una vez instalado cada vez que queramos actualizar:

```shell
sudo n stable
sudo npm i -g npm
sudo npm i -g npx
npm -v
node -v
```

Instalamos también [npx](https://www.npmjs.com/package/npx) de modo global dado que es una herramienta útil y que en iCarto usamos en las configuraciones de pre-commit en local.

## Otras opciones

En caso de hacer mucho desarrollo con node, es conveniente instalar un gestor de versiones de node al estilo de `pyenv` llamado `nvm`.

## En caso de problemas.

Si se producen incompatibilidades entre versiones en medio del proceso de actualización, una opción es

-   Descargar el tar de la web de node
-   tar -xf node-vxxx-linux-x64.tar.xz
-   cd node-vxxx-linux-x64.tar.xz/bin
-   sudo ./node npm cache clean -f
-   sudo ./node npm install -g n
-   sudo ./n stable
-   Ejecutar las instrucciones normales, porque con este workaround node estará actualizado a nivel global, pero el paquete/binario n sólo de forma local
-   rm -rf /tmp/node-vxxx-linux-x64.tar.xz /tmp/node-vxxx-linux-x64

## Referencias

-   https://stackoverflow.com/questions/5123533/how-can-i-uninstall-or-upgrade-my-old-node-js-version
-   https://codewithintent.com/how-to-install-update-and-remove-node-js-from-linux-or-ubuntu/
-   https://askubuntu.com/questions/426750/how-can-i-update-my-nodejs-to-the-latest-version
-   https://askubuntu.com/questions/562417/how-do-you-update-npm-to-the-latest-version
-   https://askubuntu.com/questions/594656/how-to-install-the-latest-versions-of-nodejs-and-npm
