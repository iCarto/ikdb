# Acceso a un servidor a través de otro intermedio (_jump server_)

En ocasiones el acceso por SSH a un servidor (llamémoslo _target server_) está restringido y es necesario usar una máquina intermedia para conectar. A este servidor intermedio se le suele denominar _jump server_, _bridge_, _proxy server_, _bastion host_ o _intermediate server_.

Asumiendo que no hay disponible una VPN, lo habitual es conectarse de forma interactiva al _jump server_ y de ahí establecer una nueva conexión al _target_

```shell
local$ ssh jumpserver
jumpserver$ ssh targetserver
```

Esto funciona bien hasta que queremos ir un poco más allá:

-   El _jump server_ es "compartido" así que no queremos dejar claves SSH en él. De modo que el acceso al target acaba siendo únicamente mediante usuario y contraseña.
-   Queremos automatizar o lanzar scripts en el target.
-   Hacer túneles, _port forwarding_, `scp` o `rsync` acaba siendo incómodo, complicado o "imposible".
-   Cambiar a un usuario distinto al de login con `su` o `sudo`

OpenSSH a partir de la versión 7.3 hace esto bastante sencillo. Veamos algunos ejemplos.

**Conectar al servidor objetivo a través del JumpServer especificando (casi) todos los parámetros**. Este comando nos preguntará la contraseña de ambos servidores si es necesario o delegará en él `ssh agent` de la máquina desde la que se ejecuta ssh en caso de acceso por clave ssh. Podemos especificar la clave con `-i ~/.ssh/my_private_key`.

```shell
ssh -J jump_user@jump_server:jump_port target_user@target_server:target_port

# O saltando a través de multiples jump servers
ssh -J jump_user@jump_server:jump_port, jump_user2@jump_server2:jump_port2 target_user@target_server:target_port
```

En los ejemplos siguientes no mostraremos usuario, puerto, ... pero todos los comandos lo admitirían. Al final veremos como simplificarlo más mediante configuración.

**Ejecutar un comando o un script**

```
ssh -J jump_server target_server "hostname"
ssh -J jump_server target_server "~/scripts/myscript.sh"
```

**Rsync**

```
# De local a remoto
rsync -avz -e 'ssh -J jump_server' /mi/path/local/ target_server:/mi/path/remoto/

# De remoto a local
rsync -avz -e 'ssh -J jump_server' target_server:/mi/path/remoto/ /mi/path/local/
```

**scp**

```
scp -J jump_server myfile target_server:/mi/path/remoto/
```

**Configuración de ssh**

Podemos usar `~/.ssh/config` para simplificar los comandos:

```
Host jumpserver
   Hostname jump_server_ip
   User jump_user
   Port jump_port
   Preferredauthentications publickey
   IdentityFile ~/.ssh/jump_private_key

Host target_server
     HostName target_server_ip
     User target_user
     Port target_port
     Preferredauthentications publickey
     IdentityFile ~/.ssh/jump_private_key
     ProxyJump jumpserver
```

Con lo que llegaría con:

```
ssh target_server
scp myfile target_server:/mi/path/remoto/
```

**Redirección de puertos**

_TODO_

# Referencias

-   https://www.ssh.com/academy/iam/jump-server
-   https://www.simplified.guide/ssh/jump-host
-   https://tailscale.com/learn/access-remote-server-jump-host/
-   https://unix.stackexchange.com/questions/234903/correct-ssh-config-file-settings-to-tunnel-to-a-3rd-machine
-   https://unix.stackexchange.com/questions/215986/ssh-login-with-a-tunnel-through-intermediate-server-in-a-single-command
-   https://superuser.com/questions/1115715/rsync-files-via-intermediate-host
