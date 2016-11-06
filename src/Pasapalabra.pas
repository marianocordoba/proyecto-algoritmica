program Pasapalabra;

uses
  Crt,
  LinkedList;

{
  Acción DrawWindow

  Dibuja una "ventana" utilizando caracteres ASCII.
}
procedure DrawWindow();
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
  Acción DrawLogo

  Imprime el logo del juego.
     ___  __   __   __   ___  __   _     __   ___  ___   __
   | |_)/ /\ ( (` / /\ | |_)/ /\ | |   / /\ | |_)| |_) / /\
  |_| /_/--\_)_)/_/--\|_| /_/--\|_|__/_/--\|_|_)|_| \/_/--\
}
procedure DrawLogo();
var
  x: integer;
begin
  // Se calcula x para centrar el logo.
  x := (windMaxX - 57) div 2;
  GotoXY(x, windMinY + 2);
  WriteLn(' ___  __   __   __   ___  __   _     __   ___  ___   __  ');
  GotoXY(x, windMinY + 3);
  WriteLn('| |_)/ /\ ( (` / /\ | |_)/ /\ | |   / /\ | |_)| |_) / /\ ');
  GotoXY(x, windMinY + 4);
  WriteLn('|_| /_/--\_)_)/_/--\|_| /_/--\|_|__/_/--\|_|_)|_| \/_/--\');
end;

{
  Acción MainMenu

  Muestra el menú principal del juego y maneja la interacción entre el usuario
  y dicho menú.
}
procedure MainMenu();
const
  optionsQuantity = 6;
var
  k: char; // Key pressed
  options: array[0..optionsQuantity - 1] of string;
  selectedOption: integer;
  i, x, y: integer;
begin
  options[0] := 'Iniciar juego';
  options[1] := 'Ver mi promedio';
  options[2] := 'Cambiar de usuario';
  options[3] := 'Crear nuevo usuario';
  options[4] := 'Mejores puntajes';
  options[5] := 'Salir';

  // Se calcula x e y para centrar el menú.
  x := (windMaxX - 20) div 2;
  y := (windMaxY - optionsQuantity) div 2;

  for i := 0 to optionsQuantity - 1 do
  begin
    GotoXY(x, y + i);
    WriteLn(options[i]);
  end;

  GotoXY(x - 2, y);
  selectedOption := 0;

  k := ReadKey;
  // #27 = ESC, #13 = ENTER
  while (k <> #27) and not ((k = #13) and (selectedOption = 5)) do
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
        if (selectedOption < 5) then
        begin
          selectedOption := selectedOption + 1;
          GotoXY(x - 2, y + selectedOption);
        end;
      end;

      // #72 = ↑
      if (k = #72) then
        begin
          if (selectedOption > 0) then
          begin
            selectedOption := selectedOption - 1;
            GotoXY(x - 2, y + selectedOption);
          end;
        end;
    end;

    if (k = #13) then
    begin
      case selectedOption of
        0:
        begin
          GotoXY(windMinX + 5, windMaxY - 3);
          WriteLn('Iniciar juego: No implementado.       ');
          GotoXY(x - 2, y + selectedOption);
        end;
        1:
        begin
          GotoXY(windMinX + 5, windMaxY - 3);
          WriteLn('Ver mi promedio: No implementado.     ');
          GotoXY(x - 2, y + selectedOption);
        end;
        2:
        begin
          GotoXY(windMinX + 5, windMaxY - 3);
          WriteLn('Cambiar de usuario. No implementado.  ');
          GotoXY(x - 2, y + selectedOption);
        end;
        3:
        begin
          GotoXY(windMinX + 5, windMaxY - 3);
          WriteLn('Crear nuevo usuario. No implementado. ');
          GotoXY(x - 2, y + selectedOption);
        end;
        4:
        begin
          GotoXY(windMinX + 5, windMaxY - 3);
          WriteLn('Mejores puntajes: No implementado.    ');
          GotoXY(x - 2, y + selectedOption);
        end;
      end;
    end;

    k := ReadKey;
  end;
end;

begin
  DrawWindow;
  DrawLogo;
  MainMenu;
  ClrScr;
end.
