# Convenciones de código

Para facilitar la legibilidad del código, así como el entendimiento por parte
de terceros que tengan acceso a el, se definen las siguientes convenciones:

* Los nombres de las variables deben ser claros y usar notación camelCase.

```pascal
var quantity: integer;
var firstName: string;
```

* Los nombres de las constantes deben ser claros y estar en mayúscula.

* Los nombre de las acciones y funciones deben ser claros y usar notación PascalCase.

```pascal
procedure DoSomething();
```

* Los nombres de variables, acciones, funciones y unidades deben estar en inglés.

* Las palabras reservadas de Pascal (`var`, `string`, `while`, etc.) deben estar en minúscula.

* Las acciones y funciones deben tener un encabezado en el que se detallen los
datos que recibe y devuelve, así como una breve descripción de su función.

```pascal
{
  Función DoSomething: integer

  Dato someCoolVar: integer
  Dato anotherCoolVar: string

  Ésta función hace algo.
}
function DoSomething(someCoolVar: integer; anotherCoolVar: string): integer;
begin
  // Implementación.
end;
```

* Todos los archivos deben tener un encabezado con una breve explicación de lo
que hacen.

```pascal
{
  Ésta unidad contiene la definición de una lista simplemente encadenada
  y funciones para su manejo.
}
unit LinkedList;
```

* Los nombres de constantes, acciones y funciones visibles de una *unit* deben tener un prefijo.

```pascal
procedure LL_Show(var list: TLinkedList); // Acción perteneciente a LinkedList.
```

* Las palabras `begin` y `end` siempre deben ir en una línea aparte.

* Se deben usar líneas en blanco para separar porciones de código.

* Los tipos y registros deben estar escritos en PascalCase y deben llevar una T al
inicio del nombre.

```pascal
type
  TPerson = record
    firstName: string;
    lastName: string;
  end;
```

* Se deben dejar espacios en las asignaciones, declaraciones de tipo, estructuras de control, etc.

```pascal
var quantity: integer;
quantity := 0;
if (quantity = 10) then ...
```

* El código debe ser comentado siempre que sea necesario. Evitar comentarios triviales o redundantes.
