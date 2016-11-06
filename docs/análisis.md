# Análisis del proyecto

### Entrada

La entrada del programa será:

* La opción elegida por el usuario
* El nombre del jugador
* La palabra ingresada por el jugador

Otras entradas del programa, aunque ajenas al usuario, son:

* El archivo que contiene las palabras
* El archivo que almacena los puntajes

### Salida

La salida del programa será:

* El menú de opciones
* Mayores puntajes de un jugador
* Mayores puntajes en general
* Puntaje actual
* Palabra a adivinar
* Letra principal de la palabra a adivinar
* Promedio de puntajes del jugador actual

### *Units* a utilizar

Para éste proyecto se utilizarán las siguientes *units*:

* Crt:

  Ésta *unit* será utilizada para acomodar la salida del programa de manera que sea
  más amigable para el usuario.

* LinkedList:

  Se utilizará la *unit* LinkedList para el manejo de listas encadenadas. Ésta *unit*
  contiene el tipo TLinkedList, que define una lista encadenada, así como métodos para
  insertar, modificar o eliminar sus elementos entre otros.

  Algunas de los métodos de LinkedList son:
  * LL_Init - Inicializa una lista encadenada.
  * LL_Push - Inserta un elemento al final de la lista.
  * LL_Pop - Elimina un elemento del final de la lista.
  * LL_Get - Obtiene el elemento de la lista en la posición dada.
  * LL_Sort - Ordena los elementos de la lista.
  * LL_Dispose - Elimina la lista y libera la memoria.

* FileSystem:

  Ésta *unit* provee de métodos para facilitar el manejo de archivos.

  Algunos de los métodos de FileSystem son:
  * FS_Open - Abre un archivo para lectura o escritura, creando el archivo si no existe.
  * FS_Exists - Chequea si un registro existe en un archivo.
