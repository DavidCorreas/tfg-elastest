# TFG-ELASTEST
Trabajo de fin de grado hecho por David Correas Oliver. Contiene una aplicación hecha con el stack MEAN y pruebas
automáticas end-to-end sobre esta aplicación.

---
## Clonado del proyecto
Como este proyecto cuenta con númerosos submódulos, el proyecto ha de clonarse con el siguiente comando:
```sh
$ git clone --recurse-submodules -j8 https://github.com/DavidCorreas/tfg-elastest.git
```

Es necesario usar `--recurse-submodules` para descargar también todos los repositorios anidados. El argumento `-j8`
es para que se descargue de una forma más rápida con versión de Git _1.9 - 2.12_, y `-j` con versión superior a _2.8_. 

---
## Requisitos del proyecto
Los únicos requisitos que se necesitan para este proyecto es poder ejecutar **docker** y **docker-compose**. 

Para que el emulador dockerizado
funcione, también se necesita que la máquina donde se ejecuta tenga habilitado **KVM**. Más información sobre los requisitos del emulador en su [repositorio](https://github.com/google/android-emulator-container-scripts).

- Para la ejecucion de este proyecto en **Windows**, es necesario seguir las instrucciones de [tfg-elastest-wsl2](https://github.com/DavidCorreas/tfg-elastest-wsl2).

---
## Setup
Para que el proyecto funcione correctamente, hay que hacer una serie de pasos para configurar la máquina donde se vaya a ejecutar. 
Toda la configuración del proyecto se hace con un único script: 
```sh
$ cd tfg-elastest
$ ./setup-emulator.sh
```

Lo que realiza este script es lo siguiente:
- Configura el emulador en docker deseado para poder ejecutar la aplicación y las pruebas. El emulador recomendado para este proyecto es (27) `28 P google_apis_playstore (x86_64)` como imagen del sistema y (1) `EMU stable 30.1.5` como emulador.
- Configura las claves en `~/.android` para que todos los servicios se puedan comunicar con el emulador.

---
## Componentes
Cada repositorio y cada componenete cuentan con un README.md contando sus objetivos y la forma de ejecutarlos/desplegarlos.
Si se necesita más información sobre cualquiera de los repositorios anidados, contienen una descripción más detallada
en cada uno de ellos.


### TFG-ELASTEST-DOCKER_RESOURCES
Repsitorio externo con el objetivo de mostrar los recursos consumidos y disponibles de docker. Los contenedores 
generados y usados por este repositorio pueden ser muy exigente en cuanto recursos de CPU y RAM, sobre todo los 
relacionados con el emulado android dockerizado.
Por ello se ha tenido que hacer un seguimiento y una medición para fijar requisitos mínimos de la máquina donde se
ejecuten estos contenedores. 

Para desplegarlo, únicamente hay que ejecutar `docker-compose up` dentro de su directorio.


### TFG-ELASTEST-EMULATOR
Repositorio externo hecho por Google para poder contar con emuladores android dockerizados. 

Se hará uso de este componente para desplegar en estos emuladores la aplicación android generado con Cordova a partir
de la aplicación web hecha con Angular. También se usarán para realizar testing automático end-to-end con Appium.


### TFG-ELASTEST-SUT
Repositorio que contiene la aplicación hecha con el stack MEAN y sobre la que se harán pruebas end-to-end. El nombre de 
sut proviene del termino en inglés _Software Under Test_ ya que el objetivo de esta aplicación es servir de una 
aplicación a la que realizar las pruebas.

Se trata de una aplicación web con un backend hecho con NodeJS y Express y con una base de datos MongoDB. El frontend está 
hecho con Angular.
Además de poder ejecutarse en la web, se ha generado una aplicación móvil con el framework de Cordova, a partir de la
aplicación Angular. Esta aplicación tiene algunas limitaciones en cuanto al despliegue, que se detallan dentro del
repositorio, debido a que su objetivo principal es ser el _SUT_ para el testing end-to-end.


### TFG-ELASTEST-TEST
Repositorio donde contiene todo lo relacionado con las pruebas end-to-end realizadas contra la aplicación MEAN de 
TFG-ELASTEST-SUT. Estos test se han realizado con el framework RobotFramework hecho en Python.

Además de los propios test realizados con este framework, cuenta con soporte para ejecutar estos test en remoto, gracias
a la docker. Dentro del repositorio se encuentran jobs y pipelines de Jenkins para poder integrarlo con este servicio.


### TFG-ELASTEST-WSL2
Repositorio de apoyo para lidiar con algunas limitaciones que aún tiene WSL2. Este proyecto se ha desarrollado casi por
completo sobre una máquina Windows, por eso se ha tenido que hacer uso de este Linux. Gracias a haber desarrollado
este proyecto en Windows es que puede ser también ejecutado en este SO con ayuda de WSL2.

Por ello, no tiene ningún fin como utilidad para el proyecto, sino que sirve como medio para el desarrollo y 
despliegue de dicho proyecto en Windows.

Se han solventado las siguientes limitaciones
- Inaccesibilidad del subsistema Linux por el resto de equipos de la red local.
- Incapacidad de virtualización en el kernel por defecto de WSL2.

---
## TESTS
Se han facilitado unos scripts para hacer test sobre la aplicación. Estos scripts dejan todo preparado para la ejecución de las pruebas, por
lo que solo habrá que tener los [requisitos del proyecto](##-Requisitos-del-proyecto) para que funcionen los test.

#### Ver resultados de los test
Todos los resultados del test se guardan en la raíz del proyecto, en la carpeta `test-results`. Se puede visualizar el contenido desde un navegador.
Por ejemplo, se puede copiar en la barra de búsqueda el fichero `./test-results/log.html` para visualizar el log.

### TEST WEB
Ejecuta test sobre la aplicación web hecha con Angular. Cuando este test es desplegado, la página únicamente es accesible a través de [Selenoid](http://localhost:9090) ya que no se mapean los puertos con la máquina host.

Test suites creados para web:
- W_login.robot
- W_posts.robot

### Ejecución
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./test-web.sh [<test>.robot (Opcional: solo si la suite tiene tests web. W_posts.robot por defecto)]
```

### TEST MÓVIL
Ejecuta test sobre la aplicación android, hecha con Cordova a partir de la aplicación Angular. Para ver el proceso del test, se puede acceder al emulador
a través del siguiente [enlace](http://localhost).

Test suites creados para web:
- M_login.robot
- M_posts.robot

### Ejecución
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./test-movil.sh [<test>.robot (Opcional: solo si la suite tiene tests web. M_posts.robot por defecto)]
```

### TEST WEB Y MÓVIL
Ejecuta test híbridos, tanto en la aplicación android, hecha con Cordova como en la aplicación web. La idea es que interaccionen ambas interfaces y que responda el backend, dando igual de donde provengan las peticiones. El test puede seguirse tanto la parte web en [Selenoid UI](http://localhost:9090), como la parte movil en el [emulador](http://localhost).

Test suites creados para web:
- W_M_login.robot

### Ejecución
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./test-hibrid.sh 
```

---
## DESPLIEGUES AUTOMÁTICOS
Para lidiar con la complejidad de este repositorio, se han añadido una serie de scripts que ejecutan las funcionalidades
y muestran los objetivos en una única linea de comandos. Los únicos requisitos son que se cuente con una terminal bash,
con acceso a docker.

### SUT (Aplicación MEAN, parte web)
Aplicación web hecha con Angular, NodeJS, Express y MongoDB. Más información en [tfg-elastest-sut](https://github.com/DavidCorreas/tfg-elastest-sut.git).

#### Requisitos
- Poder ejecutar **docker** y **docker-compose**.

#### Despliegue
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./sut-web.sh
```

#### Acceso
- Aplicación web (Angular): [http://localhost:4200/](http://localhost:4200/)

#### Parar
Para parar todos los servicios ejecutar:
```sh
$ cd tfg-elastest
$ ./sut-web.sh down
```

### SUT + SELENOID
Consiste del sut mencionado en la sección anterior y Selenoid y Selenoid UI. El sut deja de estar disponible a través de localhost y únicamente se puede vez a través de la interfaz de Selenoid. Su propósito principal es servir de punto de acceso para los test.

#### Requisitos
- Poder ejecutar **docker** y **docker-compose**.

#### Despliegue
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./selenoid-sut.sh
```

#### Acceso
- Selenoid UI: [http://localhost:9090](http://localhost:9090)

#### Parar
Para parar todos los servicios ejecutar:
```sh
$ cd tfg-elastest
$ ./selenoid-sut.sh down
```

### EMULADOR + SELENIUM HUB
Emulador android dockerizado, conectado con Appium a Selenium Hub, para realizar pruebas.

#### Requisitos
- Poder ejecutar docker y docker-compose.
- Configurar el emulador. Más información en los [requisitos](##-Requisitos-del-proyecto) del proyecto.

#### Despliegue
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./emulator-grid.sh
```

#### Acceso
- Emulador (aceptar sitio no seguro), acceso con usuario `tfg-elastest` y contraseña `hello` (se pueden cambiar y añadir usuarios en `/tfg-setup/entrypoint.sh`): [http://localhost/](http://localhost/)
- Consola Selenium Hub: [http://localhost:4444/grid/console](http://localhost:4444/grid/console)

#### Parar
Para parar todos los servicios ejecutar:
```sh
$ cd tfg-elastest
$ ./emulator-grid.sh down
```

### EMULADOR + SELENIUM GRID + SUT
Emulador android dockerizado, conectado con Appium a Selenium Hub, para realizar pruebas.
Aplicación MEAN, parte web y móvil (instalado en el emulador).

#### Requisitos
- Poder ejecutar docker y docker-compose.
- Configurar el emulador. Más información en los [requisitos](##-Requisitos-del-proyecto) del proyecto.

#### Despliegue
Se debe ejecutar el siguiente comando:
```sh
$ cd tfg-elastest
$ ./emulator-grid-sut.sh
```

#### Acceso
- Emulador con la aplicación (aceptar sitio no seguro), acceso con usuario `tfg-elastest` y contraseña `hello` (se pueden cambiar y añadir usuarios en `/tfg-setup/entrypoint.sh`): [http://localhost/](http://localhost/)
- Consola Selenium Hub: [http://localhost:4444/grid/console](http://localhost:4444/grid/console)
- Aplicación web (Angular): [http://localhost:4200/](http://localhost:4200/)

#### Parar
Para parar todos los servicios ejecutar:
```sh
$ cd tfg-elastest
$ ./emulator-grid-sut.sh down
```
