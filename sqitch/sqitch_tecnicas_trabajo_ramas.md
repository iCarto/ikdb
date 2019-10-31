# Técnicas para trabajar con Sqitch con distintas ramas de git

Este documento recoge algunas técnicas (ideas) a la hora de desarrollar varias funcionalidades en ramas separadas que impliquen tocar el sqitch.

## Estoy desarrollando una funcionalidad en una rama y la acabo o salto a otra funcionalidad

**Solución**

Antes de cambiar de rama, se hace un `revert` hasta el punto en que se está en master. Se podría desarrollar un comando "complicado" para hacerlo de forma automática. La forma sencilla es ver cuando commits hay en `sqitch.plan` que hay en esta rama y que no hay en `master` y se hacen tantos reverts como sean necesarios:

```
sqitch revert --to=@HEAD^ # Revert de un sólo commit, se puede ir ejecutando varias veces
sqitch revert --to=@HEAD^^^ # Revert de tres commits
```

**Comentarios**

Esta forma de trabajo es la ideal. Pero sucede a menudo que te olvidas de hacer el `revert` y hay que buscar workaround que serán comentados en otros puntos.

## Voy a traerme los cambios remotos que hay en una rama en la que he trabajado o estoy trabajando

**Solución**

Como en el caso anterior lo ideal es hacer el `revert` antes de tocar el `git`

Si tengo cambios en la base de datos aplicados de esa rama, lo ideal antes de traerse los cambios es hacer un `revert` de Sqitch hasta lo que haya en `master`. Actualizar la rama y volver a aplicar los cambios.
