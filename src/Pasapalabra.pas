program Pasapalabra;

uses
  Crt,
  SysUtils,
  CharList,
  WordManager,
  PlayerManager,
  UI;

var
  player: TPlayer;
  words: TWords;
  level, round: integer;
  wordIndex: integer;
  passed: integer;

procedure Main; forward;
procedure PlayEasy; forward;
procedure PlayHard; forward;
procedure ShowWord; forward;

{
  Acción Exit

  Limpia la pantalla y sale del programa.
}
procedure Exit;
begin
  ClrScr;
  Halt;
end;

{
  Acción SelectLevel

  Permite al usuario seleccionar la dificultad.
}
procedure SelectLevel;
var
  item: TMenuItem;
  items: TMenuItems;
  x, y: integer;
begin
  UI_DrawWindow;

  x := (windMaxX - 24) div 2;
  y := windMinY + 3;
  UI_Write('Seleccione la dificultad', x, y);

  item.text := 'Fácil';
  item.action := @PlayEasy;
  items.items[0] := item;

  item.text := 'Difícil';
  item.action := @PlayHard;
  items.items[1] := item;

  item.text := 'Volver';
  item.action := @Main;
  items.items[2] := item;

  items.count := 3;

  x := (windMaxX - 6) div 2;
  y := windMaxY - 6;
  UI_Menu(items, x, y);
end;

{
  Acción Pass

  Pasa una palabra para ser adivinada después.
}
procedure Pass;
begin
  words[wordIndex].passed := true;
  wordIndex := wordIndex + 1;
  passed := passed + 1;
  ShowWord;
end;

{
  Acción ShowPlayerStats

  Muestra nombre y puntaje del jugador, y la letra con la que está jugando.
}
procedure ShowPlayerStats;
var
  x, y: integer;
begin
  x := windMinX + 4;
  y := windMinY + 2;
  UI_Write(Concat('Jugador: ', player.name), x, y);

  x := windMaxX - 16;
  UI_Write(Concat('Puntaje: ', IntToStr(player.score)), x, y);

  x := (windMaxX - 8) div 2;
  UI_Write(Concat('Letra: ', Uppercase(words[wordIndex].letter)), x, y);
end;

{
  Acción GuessWord

  Muestra una pantalla que le permite al usuario ingresar la palabra a adivinar
}
procedure GuessWord;
var
  x, y: integer;
  word: string;
begin
  UI_DrawWindow;

  // CL_Length * 2 para compensar los espacios que se muestran en CL_Show
  x := (windMaxX - (CL_Length(words[wordIndex].word) * 2)) div 2;
  y := windMinY + 10;
  GotoXY(x, y);
  CL_Show(words[wordIndex].word, false);

  ShowPlayerStats;

  x := (windMaxX - 22) div 2;
  y := windMaxY - 6;
  UI_DrawBox(x, y, 22, 3);

  word := '';
  while (Length(word) <= 0) do
  begin
    GotoXY(x + 1, y + 1);
    ReadLn(word);
  end;


  x := (windMaxX - 10) div 2;
  if (CL_Equals(words[wordIndex].word, word)) then
  begin
    TextColor(green);
    UI_Write('¡Correcto!', x, y - 3);
    TextColor(white);
    if (round = 1) then
      player.score := player.score + 2
    else
      player.score := player.score + 1;
  end
  else
  begin
    TextColor(red);
    UI_Write('Incorrecto', x, y - 3);
    TextColor(white);
  end;
  GotoXY(x - 5, y + 1);
  Delay(1000);

  wordIndex := wordIndex + 1;
  passed := 0;
  ShowWord;
end;

{
  Acción ShowScore

  Muestra y guarda el puntaje del jugador.
}
procedure ShowScore;
var
  item: TMenuItem;
  items: TMenuItems;
  x, y: integer;
begin
  UI_DrawWindow;
  PM_SaveScore(player);

  x := (windMaxX - 16 - Length(player.name)) div 2;
  y := windMinY + 10;
  UI_Write(Concat('¡Felicidades ', player.name, '!'), x, y);

  x := (windMaxX - 20) div 2;
  y := y + 1;
  UI_Write(Concat('Conseguiste ', IntToStr(player.score), ' puntos'), x, y);

  item.text := 'Jugar de nuevo';
  item.action := @SelectLevel;
  items.items[0] := item;

  item.text := 'Ir al menú principal';
  item.action := @Main;
  items.items[1] := item;

  items.count := 2;

  x := (windMaxX - 20) div 2;
  y := windMaxY - 5;
  UI_Menu(items, x, y);
end;

{
  Acción ShowWord

  Muestra una palabra para ser adivinada.
}
procedure ShowWord;
var
  item: TMenuItem;
  items: TMenuItems;
  x, y, i: integer;
begin
  if (round = 1) and (wordIndex > 25) then
  begin
    wordIndex := 0;
    round := 2;
  end;

  if (round = 2) and not (words[wordIndex].passed) then
  begin
    wordIndex := wordIndex + 1;
    ShowWord;
  end;

  if (round = 2) and (wordIndex > 25) then
    ShowScore;

  UI_DrawWindow;

  // CL_Length * 2 para compensar los espacios que se muestran en CL_Show
  x := (windMaxX - (CL_Length(words[wordIndex].word) * 2)) div 2;
  y := windMinY + 10;
  GotoXY(x, y);
  CL_Show(words[wordIndex].word, false);

  ShowPlayerStats;

  // Se usa i para acomodar los elementos del menú.
  i := -1;
  if (round = 1) and (passed < 3) then
  begin
    i := 0;
    item.text := 'Pasapalabra (' + IntToStr(3 - passed) + ')';
    item.action := @Pass;
    items.items[i] := item;
  end;

  item.text := 'Adivinar palabra';
  item.action := @GuessWord;
  items.items[i + 1] := item;

  item.text := 'Ir al menú principal';
  item.action := @Main;
  items.items[i + 2] := item;

  items.count := i + 3;

  // Si i = -1 se baja un lugar para compensar el elemento faltante.
  x := (windMaxX - 16) div 2;
  y := windMaxY - 6 + (i * (-1));
  UI_Menu(items, x, y);
end;

{
  Acción HighScores

  Muestra los 10 mejores puntajes.
}
procedure HighScores;
var
  players: TPlayers;
  item: TMenuItem;
  items: TMenuItems;
  x, y, i: integer;
begin
  UI_DrawWindow;

  players := PM_HighScores;

  x := (windMaxX - 18) div 2;
  y := windMinY + 3;
  UI_Write('Mejores puntajes', x, y);

  i := 0;
  x := (windMaxX - 28) div 2;
  y := windMinY + 6;
  while (i < 10) and (i < players.count) do
  begin
    UI_Write(IntToStr(i + 1), x, y + i);
    UI_Write(players.data[i].name, x + 3, y + i);
    UI_Write(IntToStr(players.data[i].score), x + 26, y + i);
    i := i + 1;
  end;

  item.text := 'Volver';
  item.action := @Main;
  items.items[0] := item;
  items.count := 1;

  x := (windMaxX - 6) div 2;
  y := windMaxY - 4;
  UI_Menu(items, x, y);
end;

{
  Acción AverageScore

  Muestra el puntaje promedio del jugador actual.
}
procedure AverageScore;
var
  item: TMenuItem;
  items: TMenuItems;
  x, y: integer;
  score: real;
begin
  UI_DrawWindow;

  score := PM_AverageScore(player.name);

  x := (windMaxX - 18) div 2;
  y := windMinY + 3;
  UI_Write('Puntaje promedio', x, y);

  x := (windMaxX - 12) div 2;
  y := windMinY + 6;
  UI_Write(Concat(FloatToStr(score), ' puntos'), x, y);

  item.text := 'Volver';
  item.action := @Main;
  items.items[0] := item;
  items.count := 1;

  x := (windMaxX - 6) div 2;
  y := windMaxY - 4;
  UI_Menu(items, x, y);
end;

{
  Acción Play

  Inicia una partida en el nivel dado.
}
procedure Play();
begin
  UI_DrawWindow;

  WM_LoadWords(words, level);

  round := 1;
  wordIndex := 0;
  passed := 0;
  ShowWord;
end;
procedure PlayEasy;
begin
  level := 1;
  Play;
end;
procedure PlayHard;
begin
  level := 2;
  Play;
end;

{
  Acción Main

  Muestra el menú principal del juego.
}
procedure Main;
var
  item: TMenuItem;
  items: TMenuItems;
begin
  UI_DrawWindow;
  UI_DrawLogo;

  item.text := 'Iniciar partida';
  item.action := @SelectLevel;
  items.items[0] := item;

  item.text := 'Ver mi promedio';
  item.action := @AverageScore;
  items.items[1] := item;

  item.text := 'Cambiar de usuario';
  item.action := @Exit;
  items.items[2] := item;

  item.text := 'Mejores puntajes';
  item.action := @HighScores;
  items.items[3] := item;

  item.text := 'Salir';
  item.action := @Exit;
  items.items[4] := item;

  items.count := 5;

  UI_Menu(items, (windMaxX - 20) div 2, windMaxY - 8);
end;

{
  Acción Welcome

  Dato-resultado pn: String;

  Muestra un mensaje de bienvenida y pide al usuario que ingrese su nombre.
}
procedure Welcome(var pn: string);
var
  x, y: integer;
begin
  UI_DrawWindow;
  UI_DrawLogo;

  x := (windMaxX - 32) div 2;
  y := windMaxY - 9;
  UI_Write('  ¡Bienvenido a Pasapalabra!  ', x, y);
  UI_Write('Ingresa tu nombre para comenzar', x, y + 1);
  UI_DrawBox(x, windMaxY - 6, 32, 3);

  pn := '';
  while (Length(pn) < 1) do
  begin
    GotoXY(x + 2, windMaxY - 5);
    ReadLn(pn);
  end;
end;

begin
  Randomize;
  Welcome(player.name);
  Main;
end.
