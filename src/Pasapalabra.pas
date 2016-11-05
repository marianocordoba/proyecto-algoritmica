program Pasapalabra;

uses LinkedList;

var
  list: TLinkedList;
  e: TElement;
  i: integer;

begin
  Randomize;
  LL_Init(list);

  i := 0;
  while (i < 20) do
  begin
    e.id := Random(30);
    LL_Push(list, e);
    i := i + 1;
  end;

  LL_Show(list);
  WriteLn;

  LL_Sort(list, Asc);
  LL_Show(list);
  WriteLn;

  LL_Sort(list, Desc);
  LL_Show(list);
end.
