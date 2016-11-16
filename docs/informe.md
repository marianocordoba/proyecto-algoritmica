### Estructura de directorios

Al comenzar a trabajar en el proyecto lo primero que se hace es definir la estructura
de directorios que tendrá el mismo.

Para una mejor organización de los archivos, todos los archivos que contienen código
son puestos dentro del directorio `src`. A su vez, las *units* son puestas dentro del
directorio `src/lib`.

En el directorio `docs` se almacenan los archivos que contienen documentación, por
ejemplo, el manual de usuario, convenciones de código, etc.

Finalmente, en el directorio `dist` se guardan los binarios compilados.

><center>
![Estructura de directorios](images/dirstruct.png)<br>
<sup><small>Estructura de directorios</small></sup>
</center>

### Compilación

Para compilar el proyecto respetando la estructura de directorios anteriormente mencionada, se debe ejecutar
el siguiente comando:

`fpc -Fu"src/lib/" -B "src/Pasapalabra.pas" -o"dist/Pasapalabra"`

O en su defecto ejecutar el script `build.sh`.

La bandera `-Fu` indica el directorio en el cual se encuentran las *units*, `-B` le dice al compilador
que compile todos los módulos (compila el programa y todas las *units*) y `-o` indica el archivo de
salida.

### Implementación

Lo primero que se hace es implementar una sencilla interfaz para que el usuario interactue
con el programa. Se crea una pantalla de bienvenida en la que se le solicita al usuario su
nombre y luego se le muestra un menú.

En un principio todo el código se escribe en el archivo principal, pero luego algunas acciones
que sirven para dibujar la interfaz son movidas a una nueva *unit* llamada `UI` para mantener
el código más ordenado. La acción que muestra el menú es mantenida en el archivo principal para
poder llamar a otras acciones desde dentro de dicha acción.

Para comenzar con el juego principal, se crea una acción que lea el archivo que contiene las
palabras y seleccioné 26 palabras para jugar. Dicha acción lee el archivo y recorre las palabras,
seleccionando una al azar para cada letra. Una vez seleccionada una palabra para una letra, se
convierte la palabra en una lista de caracteres. Luego se ocultan algunas letras y la palabra
se agrega a un arreglo para ser usada más tarde.

Para todo esto fue necesario implementar dos nuevas acciones: una que convierte la palabra en
una lista, y otra que se encarga de ocultar letras aleatoriamente. Será necesario modificar
esta última acción para adaptarse a distintos niveles de dificultad (del juego).

Nuevamente, para mantener el código limpio, se contempla la posibilidad de mover estas nuevas
acciones a una nueva *unit*, pero aún no se lleva a cabo dicha refactorización.

Al querer avanzar con el desarrollo, se encuentra el problema de que se necesitará un menú
en varias partes del programa (selección de dificultad, durante partida, etc.), por lo cual
se busca una forma de modularizar mejor la acción del menú para que se más independiente.

Luego de una breve investigación se modifica la acción para que reciba un arreglo de opciones,
cada una relaccionada con una acción que es pasada como parámetro para ser llamada dentr de
la acción que genera el menú. De esta manera se puede usar la acción para mostrar menus en
cualquier parte del programa sin reescribir código.

Habiendo completado el código que permite al usuario jugar, se debe pensar de qué manera
se va a guardar los datos y el puntaje del jugador.

Se decide crear una *unit* que permita guardar los puntajes del jugador, así como recuperar
el puntaje promedio y los puntajes más altos.
