{
  Ésta unidad contiene la definición de una lista de caracteres
  y funciones para su manejo.
}

unit CharList;

interface

  type
    // TElement debe ser modificado para adaptarse al caso de uso.
    TElement = record
      character: char;
      visible: boolean;
    end;

    TNode = record
      data: TElement;
      next: ^TNode;
    end;

    TCharList = record
      head: ^TNode;
      count: integer;
    end;

    TOrder = (Asc, Desc);

  procedure CL_Init(var list: TCharList);
  procedure CL_Push(var list: TCharList; elem: TElement);
  procedure CL_Pop(var list: TCharList);
  procedure CL_Shift(var list: TCharList; elem: TElement);
  procedure CL_Unshift(var list: TCharList);
  procedure CL_Insert(var list: TCharList; elem: TElement; pos: integer);
  procedure CL_Remove(var list: TCharList; pos: integer);
  procedure CL_Set(list: TCharList; elem: TElement; pos: integer);
  procedure CL_Clear(list: TCharList);
  procedure CL_Dispose(var list: TCharList);
  procedure CL_Show(list: TCharList; showNotVisibles: boolean);
  function CL_Get(list: TCharList; pos: integer): TElement;
  function CL_Length(list: TCharList): integer;
  function CL_Equals(list: TCharList; text: string): boolean;

implementation

  uses SysUtils;

  {
    Acción CL_Init

    Dato-resultado list: TCharList

    Inicializa la lista.
  }
  procedure CL_Init(var list: TCharList);
  var
    nodeptr: ^TNode;
  begin
    New(nodeptr);

    nodeptr^.next := nil;
    list.head := nodeptr;
    list.count := 0;
  end;

  {
    Acción CL_Push

    Dato-resultado list: TCharList
    Dato elem: TElement

    Inserta un elemento al final de la lista.
  }
  procedure CL_Push(var list: TCharList; elem: TElement);
  begin
    CL_insert(list, elem, CL_Length(list));
  end;

  {
    Acción CL_Pop

    Dato-resultado list: TCharList

    Elimina un elemento del final de la lista.
  }
  procedure CL_Pop(var list: TCharList);
  begin
    CL_remove(list, CL_Length(list) - 1);
  end;

  {
    Acción CL_Shift

    Dato-resultado list: TCharList
    Dato elem: TElement

    Inserta un elemento al inicio de la lista.
  }
  procedure CL_Shift(var list: TCharList; elem: TElement);
  begin
    CL_insert(list, elem, 0);
  end;

  {
    Acción CL_Unshift

    Dato-resultado list: TCharList

    Elimina un elemento del inicio de la lista.
  }
  procedure CL_Unshift(var list: TCharList);
  begin
    CL_remove(list, 0);
  end;

  {
    Acción CL_Insert

    Dato-resultado list: TCharList
    Dato elem: TElement
    Dato pos: Integer

    Inserta un elemento en una posición dada en la lista.
  }
  procedure CL_Insert(var list: TCharList; elem: TElement; pos: integer);
  var
    nodeptr, auxnodeptr: ^TNode;
    i: integer;
  begin
    New(nodeptr);
    i := 0;

    //Chequea que la posición esté dentro del rango de la lista.
    if (pos >= 0) and (pos <= CL_Length(list)) then
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
    Acción CL_Remove

    Dato-resultado list: TCharList
    Dato pos: Integer

    Elimina un elemento de una posición dada en la lista.
  }
  procedure CL_Remove(var list: TCharList; pos: integer);
  var
    nodeptr, auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    auxnodeptr := list.head;

    //Chequea que la posición exista.
    if (pos >= 0) and (pos < CL_Length(list)) then
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
    Acción CL_Set

    Dato-resultado list: TCharList
    Dato elem: TElement
    Dato pos: Integer

    Asigna un nuevo valor al elemento en la posición dada.
  }
  procedure CL_Set(list: TCharList; elem: TElement; pos: integer);
  var
    auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    // Chequea que la posición exista.
    if (pos >= 0) and (pos <= CL_Length(list)) then
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
    Función CL_Get: TElement

    Dato-resultado list: TCharList
    Dato pos: Integer

    Obtiene el elemento en la posición dada.
  }
  function CL_Get(list: TCharList; pos: integer): TElement;
  var
    auxnodeptr: ^TNode;
    i: integer;
  begin
    i := 0;

    // Chequea que la posición esté dentro del rango de la lista.
    if (pos >= 0) and (pos <= CL_Length(list)) then
    begin
      auxnodeptr := list.head;
      while (auxnodeptr^.next <> nil) and (i < pos) do
      begin
        auxnodeptr := auxnodeptr^.next;
        i := i + 1;
      end;

      CL_Get := auxnodeptr^.next^.data;
    end
    else Halt(1);
  end;

  {
    Función CL_Length: Integer

    Dato-resultado list: TCharList

    Obtiene la cantidad de elementos que contiene la lista.
  }
  function CL_Length(list: TCharList): integer;
  begin
    CL_Length := list.count;
  end;

  {
    Acción CL_Clear

    Dato-resultado list: TCharList

    Vacía la lista.
  }
  procedure CL_Clear(list: TCharList);
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
    Acción CL_Dispose

    Dato-resultado list: TCharList

    Vacía la lista y libera la memoria.
  }
  procedure CL_Dispose(var list: TCharList);
  begin
    CL_clear(list);
    Dispose(list.head);
  end;

  {
    Acción CL_Show

    Dato-resultado list: TCharList

    Muestra el contenido de la lista.
  }
  procedure CL_Show(list: TCharList; showNotVisibles: boolean);
  var
    auxnodeptr: ^TNode;
  begin
    auxnodeptr := list.head;
    while (auxnodeptr^.next <> nil) do
    begin
      auxnodeptr := auxnodeptr^.next;
      if (showNotVisibles) then
        Write(auxnodeptr^.data.character)
      else
      begin
        if (auxnodeptr^.data.visible) then
          Write(auxnodeptr^.data.character)
        else
          Write('_');

        if (auxnodeptr^.next <> nil) then
          Write(' ');
      end;
    end;
  end;

  {
    Función CL_Equals

    Dato list: TCharList
    Dato text: String

    Compara el contenido de la lista con un string y devuelve verdadero si
    son iguales.
  }
  function CL_Equals(list: TCharList; text: string): boolean;
  var
    auxnodeptr: ^TNode;
    i: integer;
  begin
    auxnodeptr := list.head;
    i := 1;

    while (auxnodeptr^.next <> nil) and
          (Lowercase(auxnodeptr^.next^.data.character) = Lowercase(text[i])) do
    begin
      auxnodeptr := auxnodeptr^.next;
      i := i + 1;
    end;

    CL_Equals := i - 1 = CL_Length(list);
  end;

end.
