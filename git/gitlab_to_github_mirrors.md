Los repositorios de iCarto están en [GitLab](https://gitlab.com/icarto) pero se mantienen mirrors de sólo lectura en [GitHub](https://github.com/iCarto) dado que esta plataforma sigue siendo la mayoritaria a la hora de evaluar contribuciones públicas de código.

GitLab da la opción de hacer [push automático a modo de mirror](https://gitlab.com/help/workflow/repository_mirroring#pushing-to-a-remote-repository) a un repositorio remoto. Pero en ocasiones puede interesar hacerlo de forma manual a través de un servidor intermedio. Así es como lo estamos haciendo en iCarto.


**Eliminamos el permiso de escritura en GitHub**

Todo el equipo está en la sección *People* de la organización *iCarto* en GitHub, pero los *Repository permissions* de los *Organizations members* se ponen a *None*. De este modo sólo el usuario *icarto* puede escribir en los repositorios.


**Preparamos los repos en un servidor intermedio**

En un servidor interno descargamos los repositorios preparados para hacer de puente entre ambos servicios. Para un conjunto de respositorios se puede usar un script como este, que descarga los repositorios [en modo mirror desde gitlab y habilita como remote github]((https://help.github.com/articles/duplicating-a-repository/#mirroring-a-repository-in-another-location)):

```bash
REPOS="/home/mirrors/"
cd "${REPOS}"

HUB_USER="github_user:github_pass"
LAB_USER="gitlab_user:gitlab_pass"

DIRS=(utentes-api.git extELLE.git vial.git repo_xyz.git)

for DIR in ${DIRS[*]}; do
    echo "Procesando ${DIR}..."
    git clone --mirror https://${LAB_USER}@gitlab.com/icarto/${DIR}
    cd "${DIR}"
    git remote set-url --push origin https://${HUB_USER}@github.com/iCarto/${DIR}
    cd ..
done
```

Por simplicidad y porque el servidor es *seguro* usamos basic auth. En otras situaciones sería recomendable usar ssh.


**Creamos un script para el fetch && push**

```bash
#!/bin/bash

# mirror_gitlab_to_github
# Don't use extension for the filename,
# or problems with cron could arise

REPOS="/home/mirrors/"

for i in `/bin/ls ${REPOS}` ; do
    DIR="${REPOS}${i}"
    cd "${DIR}"
    git fetch -p origin && git push --mirror
done
```

El parámetro `fetch -p` [elimina en el repositorio local las referencias a ramas borradas en el remoto]((http://blog.plataformatec.com.br/2013/05/how-to-properly-mirror-a-git-repository/).


**Programos un evento en cron**

En nuestro caso lo estamos ejecutando de forma semanal

```bash
cp mirror_gitlab_to_github /etc/cron.weekly
chmod 755 /etc/cron.weekly/mirror_gitlab_to_github
```



## Referencias

* [Two way mirror](https://stendhalgame.org/wiki/Two_way_git_mirror)
