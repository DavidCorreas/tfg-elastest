# TFG-ELASTEST
Trabajo de fin de grado hecho por David Correas Oliver. Contiene una aplicación hecha con el stack MEAN y pruebas
automáticas end-to-end sobre esta aplicación.

## Clonado del projecto
Como este proyecto cuenta con númerosos submódulos, el proyecto ha de clonarse con el siguiente comando:
`git clone --recurse-submodules -j8 https://github.com/DavidCorreas/tfg-elastest.git`

Es necesario usar `--recurse-submodules` para descargar también todos los repositorios anidados. El argumento `-j8`
es para que se descargue de una forma más rápida con versión de Git _1.9 - 2.12_, y `-j` con versión superior a _2.8_. 

## Setup


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



## Despliegues automáticos
Para lidiar con la complejidad de este repositorio, se han añadido una serie de scripts que ejecutan las funcionalidades
y muestran los objetivos en una única linea de comandos. Los únicos requisitos son que se cuente con una terminal bash,
con acceso a docker.

### EMULADOR + SELENIUM GRID
#### Requisitos
- (WSL2): Ejecutar con [custom kernel](https://github.com/DavidCorreas/tfg-elastest-wsl2/blob/29071b02f25162500bb35e660d0610a8fb347fba/README.md) con virtualización anidada.

