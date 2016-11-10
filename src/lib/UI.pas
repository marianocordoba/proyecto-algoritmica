unit UI;

interface

  type
    TMenuItem = record
      text: string;
      action: TProcedure;
    end;

    TMenuItems = record
      items: array[0..9] of TMenuItem;
      count: integer;
    end;

  procedure UI_DrawWindow;
  procedure UI_DrawBox(posX, posY, width, height: integer);
  procedure UI_DrawLogo;
  procedure UI_Write(text: string; posX, posY: integer);
  procedure UI_Menu(items: TMenuItems; posX, posY: integer);

implementation

  uses
    Crt;

  {
    Acción DrawWindow

    Dibuja una "ventana" utilizando caracteres ASCII.
  }
  procedure UI_DrawWindow();
  var
    x, y: integer;
  begin
    ClrScr;
    for x := windMinX + 4 to windMaxX - 5 do
    begin
      GotoXY(x, windMinY + 1);
      WriteLn('═');
      GotoXY(x, windMaxY - 2);
      WriteLn('═');
    end;

    for y := windMinY + 2 to windMaxY - 3 do
    begin
      GotoXY(windMinX + 3, y);
      WriteLn('║');
      GotoXY(windMaxX - 4, y);
      WriteLn('║');
    end;

    GotoXY(windMinX + 3, windMinY + 1);
    WriteLn('╔');
    GotoXY(windMaxX - 4, windMinY + 1);
    WriteLn('╗');
    GotoXY(windMinX + 3, windMaxY - 2);
    WriteLn('╚');
    GotoXY(windMaxX - 4, windMaxY - 2);
    WriteLn('╝');
  end;

  {
    Acción DrawBox

    Dato posX: Integer
    Dato posY: Integer
    Dato height: Integer
    Dato width: Integer

    Dibuja un cuadro en la pantalla.
  }
  procedure UI_DrawBox(posX, posY, width, height: integer);
  var
    x, y: integer;
  begin
    for x := posX + 1 to posX + width - 3 do
    begin
      GotoXY(x, posY);
      WriteLn('─');
      GotoXY(x, posY + height);
      WriteLn('─');
    end;

    for y := posY + 1 to posY + height - 1 do
    begin
      GotoXY(posX, y);
      WriteLn('│');
      GotoXY(posX + width - 2, y);
      WriteLn('│');
    end;

    GotoXY(posX, posY);
    WriteLn('┌');
    GotoXY(posX + width - 2, posY);
    WriteLn('┐');
    GotoXY(posX, posY + height);
    WriteLn('└');
    GotoXY(posX + width - 2, posY + height);
    WriteLn('┘');
  end;

  {
    Acción DrawLogo

    Imprime el logo del juego.
       ___  __   __   __   ___  __   _     __   ___  ___   __
     | |_)/ /\ ( (` / /\ | |_)/ /\ | |   / /\ | |_)| |_) / /\
    |_| /_/--\_)_)/_/--\|_| /_/--\|_|__/_/--\|_|_)|_| \/_/--\
  }
  procedure UI_DrawLogo;
  var
    x: integer;
  begin
    // Se calcula x para centrar el logo.
    x := (windMaxX - 57) div 2;
    GotoXY(x, windMinY + 5);
    WriteLn(' ___  __   __   __   ___  __   _     __   ___  ___   __  ');
    GotoXY(x, windMinY + 6);
    WriteLn('| |_)/ /\ ( (` / /\ | |_)/ /\ | |   / /\ | |_)| |_) / /\ ');
    GotoXY(x, windMinY + 7);
    WriteLn('|_| /_/--\_)_)/_/--\|_| /_/--\|_|__/_/--\|_|_)|_| \/_/--\');
  end;

  {
    Acción UI_Write

    Dato text: String
    Dato posX: Integer
    Dato posY: Integer

    Escribe en la posición dada y vuelve el cursor a donde estaba.
  }
  procedure UI_Write(text: string; posX, posY: integer);
  var
    curX, curY: integer;
  begin
    curX := WhereX;
    curY := WhereY;
    GotoXY(posX, posY);
    WriteLn(text);
    GotoXY(curX, curY);
  end;


  {
    Acción UI_Menu

    Dato items: TMenuItems
    Dato posX: Integer
    Dato posY: Integer

    Muestra un menú y maneja la interacción entre el usuario y dicho menú.
  }
  procedure UI_Menu(items: TMenuItems; posX, posY:integer);
  var
    k: char; // Key pressed
    selectedOption: integer;
    i: integer;
  begin
    for i := 0 to items.count - 1 do
    begin
      GotoXY(posX, posY + i);
      WriteLn(items.items[i].text);
    end;

    GotoXY(posX - 2, posY);
    selectedOption := 0;

    k := ReadKey;
    // Ciclo infinito. Para salir se debe usar Halt.
    while (true) do
    begin
      if (Ord(k) = 0) then
      begin
        {
          Si Ord(k) = 0, entonces se trata de un caracter extendido. Se lee de
          nuevo la tecla para obtener el valor del caracter extendido.
        }
        k := ReadKey;

        // #80 = ↓
        if (k = #80) then
        begin
          if (selectedOption < items.count - 1) then
          begin
            selectedOption := selectedOption + 1;
            GotoXY(posX - 2, posY + selectedOption);
          end;
        end;

        // #72 = ↑
        if (k = #72) then
          begin
            if (selectedOption > 0) then
            begin
              selectedOption := selectedOption - 1;
              GotoXY(posX - 2, posY + selectedOption);
            end;
          end;
      end;

      // #13 = ENTER
      if (k = #13) then
      begin
        items.items[selectedOption].action;
      end;

      k := ReadKey;
    end;
  end;

end.
