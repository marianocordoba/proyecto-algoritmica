{
  Ésta unidad contiene la definición de una lista simplemente encadenada
  y funciones para su manejo.
}

unit LinkedList;

interface

  type
    // TElement debe ser modificado para adaptarse al caso de uso.
    TElement = record
      id: integer;
    end;

    TNode = record
      data: TElement;
      next: ^TNode;
    end;

    TLinkedList = record
      head: ^TNode;
      count: integer;
    end;

    TOrder = (Asc, Desc);

  procedure LL_Init(var list: TLinkedList);
  procedure LL_Push(var list: TLinkedList; elem: TElement);
  procedure LL_Pop(var list: TLinkedList);
  procedure LL_Shift(var list: TLinkedList; elem: TElement);
  procedure LL_Unshift(var list: TLinkedList);
  procedure LL_Insert(var list: TLinkedList; elem: TElement; pos: integer);
  procedure LL_Remove(var list: TLinkedList; pos: integer);
  procedure LL_Set(list: TLinkedList; elem: TElement; pos: integer);
  procedure LL_Clear(list: TLinkedList);
  procedure LL_Dispose(var list: TLinkedList);
  procedure LL_Show(list: TLinkedList);
  procedure LL_Swap(list: TLinkedList; pos1, pos2: integer);
  procedure LL_Sort(list: TLinkedList; order: TOrder);
  function LL_Get(list: TLinkedList; pos: integer): TElement;
  function LL_Count(list: TLinkedList): integer;

implementation

  {
    Acción LL_Init

    Dato-resultado list: TLinkedList

    Inicializa la lista.
  }
  procedure LL_Init(var list: TLinkedList);
  var
    nodeptr: ^TNode;
  begin
    New(nodeptr);

    nodeptr^.next := nil;
    list.head := nodeptr;
    list.count := 0;
  end;

  {
    Acción LL_Push

    Dato-resultado list: TLinkedList
    Dato elem: TElement

    Inserta un elemento al final de la lista.
  }
  procedure LL_Push(var list: TLinkedList; elem: TElement);
  begin
    LL_insert(list, elem, LL_Count(list));
  end;

  {
    Acción LL_Pop

    Dato-resultado list: TLinkedList

    Elimina un elemento del final de la lista.
  }
  procedure LL_Pop(var list: TLinkedList);
  begin
    LL_remove(list, LL_Count(list) - 1);
  end;

  {
    Acción LL_Shift

    Dato-resultado list: TLinkedList
    Dato elem: TElement

    Inserta un elemento al inicio de la lista.
  }
  procedure LL_Shift(var list: TLinkedList; elem: TElement);
  begin
    LL_insert(list, elem, 0);
  end;

  {
    Acción LL_Unshift

    Dato-resultado list: TLinkedList

    Elimina un elemento del inicio de la lista.
  }
  procedure LL_Unshift(var list: TLinkedList);
  begin
    LL_remove(list, 0);
  end;

  {
    Acción LL_Insert

    Dato-resultado list: TLinkedList
    Dato elem: TElement
    Dato pos: Integer

    Inserta un elemento en una posición dada en la lista.
  }
  procedure LL_Insert(var list: TLinkedList; elem: TElement; pos: integer);
  var
    nodeptr, auxnodeptr: ^TNode;
    i: integer;
  begin
    New(nodeptr);
    i := 0;

    //Chequea que la posición esté dentro del rango de la lista.
    if (pos >= 0) and (pos <= LL_Count(list)) then
    begin
      nodeptr^.data := elem;
      auxnodeptr := list.head;
      while (auxnodeptr^.next <> nil) and (i < pos) do
      begin
        auxnodeptr := auxnodeptr^.next;
        i := i + 1;
      end;

      nodeptr^.next := auxnodeptr^.next;
      auxnodeptr^.next := nodeptr;
      list.count := list.count + 1;
    end
    else Halt(1);
  end;

  {
    Acción LL_Remove

    Dato-resultado list: TLinkedList
    Dato pos: Integer

    Elimina un elemento de una posición dada en la lista.
  }
  procedure LL_Remove(var list: TLinkedList; pos: integer);
  var
    nodeptr, auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    auxnodeptr := list.head;

    //Chequea que la posición exista.
    if (pos >= 0) and (pos < LL_Count(list)) then
    begin
      while (auxnodeptr^.next <> nil) and (i < pos) do
      begin
        auxnodeptr := auxnodeptr^.next;
        i := i + 1;
      end;

      if (auxnodeptr^.next^.next <> nil) then
        nodeptr := auxnodeptr^.next^.next
      else
        nodeptr := nil;

      Dispose(auxnodeptr^.next);
      auxnodeptr^.next := nodeptr;
      list.count := list.count - 1;
    end
    else Halt(1);
  end;

  {
    Acción LL_Set

    Dato-resultado list: TLinkedList
    Dato elem: TElement
    Dato pos: Integer

    Asigna un nuevo valor al elemento en la posición dada.
  }
  procedure LL_Set(list: TLinkedList; elem: TElement; pos: integer);
  var
    auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    // Chequea que la posición exista.
    if (pos >= 0) and (pos <= LL_Count(list)) then
    begin
      auxnodeptr := list.head;
      while (auxnodeptr^.next <> nil) and (i < pos) do
      begin
        auxnodeptr := auxnodeptr^.next;
        i := i + 1;
      end;

      auxnodeptr^.next^.data := elem;
    end
    else Halt(1);
  end;

  {
    Función LL_Get: TElement

    Dato-resultado list: TLinkedList
    Dato pos: Integer

    Obtiene el elemento en la posición dada.
  }
  function LL_Get(list: TLinkedList; pos: integer): TElement;
  var
    auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    // Chequea que la posición esté dentro del rango de la lista.
    if (pos >= 0) and (pos <= LL_Count(list)) then
    begin
      auxnodeptr := list.head;
      while (auxnodeptr^.next <> nil) and (i < pos) do
      begin
        auxnodeptr := auxnodeptr^.next;
        i := i + 1;
      end;

      LL_Get := auxnodeptr^.next^.data;
    end
    else Halt(1);
  end;

  {
    Función LL_Count: Integer

    Dato-resultado list: TLinkedList

    Obtiene la cantidad de elementos que contiene la lista.
  }
  function LL_Count(list: TLinkedList): integer;
  begin
    LL_Count := list.count;
  end;

  {
    Acción LL_Clear

    Dato-resultado list: TLinkedList

    Vacía la lista.
  }
  procedure LL_Clear(list: TLinkedList);
  var
    nodeptr, auxnodeptr: ^TNode;
  begin
    auxnodeptr := list.head^.next;
    while (auxnodeptr <> nil) do
    begin
      nodeptr := auxnodeptr;
      Dispose(nodeptr);
      auxnodeptr := auxnodeptr^.next;
    end;
  end;

  {
    Acción LL_Dispose

    Dato-resultado list: TLinkedList

    Vacía la lista y libera la memoria.
  }
  procedure LL_Dispose(var list: TLinkedList);
  begin
    LL_clear(list);
    Dispose(list.head);
  end;

  {
    Acción LL_Show

    Dato-resultado list: TLinkedList

    Muestra el contenido de la lista.
  }
  procedure LL_Show(list: TLinkedList);
  var
    auxnodeptr: ^TNode;
  begin
    Write('[');

    auxnodeptr := list.head;
    while (auxnodeptr^.next <> nil) do
    begin
      auxnodeptr := auxnodeptr^.next;
      // Modi
      Write('{id:', auxnodeptr^.data.id, '}');
      if (auxnodeptr^.next <> nil) then Write(',');
    end;

    WriteLn(']');
  end;

  {
    Acción LL_Swap

    Dato list: TLinkedList
    Dato pos1, pos2: Integer

    Intercambia la posición de dos elementos de la lista.
  }
  procedure LL_Swap(list: TLinkedList; pos1, pos2: integer);
  var
    auxelem: TElement;
  begin
    //Chequea que las posiciones existan y sean diferentes.
    if (pos1 >= 0) and (pos2 >= 0) and
       (pos1 < LL_Count(list)) and (pos2 < LL_Count(list)) and
       (pos1 <> pos2) then
    begin
      auxelem := LL_Get(list, pos1);
      LL_Set(list, LL_Get(list, pos2), pos1);
      LL_Set(list, auxelem, pos2);
    end
    else Halt(1);
  end;

  {
    Acción LL_Sort

    Dato list: TLinkedList

    Ordena la lista utilizando el algoritmo bubble sort.
  }
  procedure LL_Sort(list: TLinkedList; order: TOrder);
  var
    limit, i: integer;
  begin
    limit := LL_Count(list) - 1;
    while (limit > 0) do
    begin
      i := 0;

      while (i < limit) do
      begin
        if (order = Asc) then
        begin
          // Modificar condición para adaptarse a TElement.
          if (LL_Get(list, i).id > LL_Get(list, i + 1).id) then
            LL_Swap(list, i, i + 1);
        end
        else
        begin
          // Modificar condición para adaptarse a TElement.
          if (LL_Get(list, i).id < LL_Get(list, i + 1).id) then
            LL_Swap(list, i, i + 1);
        end;
        i := i + 1;
      end;

      limit := limit - 1;
    end;
  end;

end.
