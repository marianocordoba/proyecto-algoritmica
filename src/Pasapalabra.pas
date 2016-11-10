program Pasapalabra;

uses
  Crt,
  SysUtils,
  CharList,
  UI;

type
  TPlayer = record
    name: string;
    score: integer;
  end;

  TArrWord = record
    word: string[20];
    letter: char;
  end;

  TWord = record
    word: TCharList;
    letter: char;
    passed: boolean;
  end;

  TWords = array[0..25] of TWord;

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
  Acción ConvertWord

  Dato w1: TArrWord
  Dato-resultado w2: TWord

  Convierte un TArrWord en un TWord.
}
procedure ConvertWord(w1: TArrWord; var w2: TWord);
var
  i: integer;
  e: TElement;
begin
  i := 1;
  CL_Init(w2.word);

  while (i <= Length(w1.word)) do
  begin
    e.character := w1.word[i];
    e.visible := true;
    CL_Push(w2.word, e);
    i := i + 1;
  end;

  w2.letter := w1.letter;
  w2.passed := false;
end;

{
  Acción HideLetters

  Dato-resultado word: TWord
  Dato quantity: Integer

  Oculta algunas letras de la palabra.
}
procedure HideLetters(var word: TWord; quantity: integer);
var
  // q = Cantidad de letras ocultas
  q, i: integer;
  e: TElement;
begin
  q := 0;

  if (CL_Length(word.word) <= 4) then
    quantity := 1;

  while (q < quantity) do
  begin
    i := Random(CL_Length(word.word));
    e := CL_Get(word.word, i);
    if (e.character <> word.letter) and (e.visible) then
    begin
      e.visible := false;
      CL_Set(word.word, e, i);
      q := q + 1;
    end;
  end;
end;

{
  Acción LoadWords

  Dato-resultado words: TWords

  Carga las palabras a usar en un arreglo.
  Para esto lee las palabras del archivo, seleciona una para cada letra, las
  convierte a listas y esconde algunas de sus letras.
}
procedure LoadWords(var words: TWords);
const
  filePath = 'words.dat';
var
  f: file of TArrWord;
  w1: TArrWord;
  w2: TWord;
  i, j, k: integer;
begin
  Assign(f, filePath);
  Reset(f);

  i := 0;
  j := 0;
  k := Random(5);

  while not (EOF(f)) do
  begin
    Read(f, w1);

    if (i = k) then
    begin
      ConvertWord(w1, w2);

      if (level = 1) then
        HideLetters(w2, 2)
      else
        HideLetters(w2, 3);

      words[j] := w2;
      j := j + 1;
    end;

    if (i < 4) then
    begin
      i := i + 1;
    end
    else
    begin
      i := 0;
      k := Random(5);
    end;
  end;

  Close(f);
end;

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
begin
  UI_DrawWindow;

  UI_Write('Seleccione la dificultad', (windMaxX - 24) div 2, windMinY + 5);

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

  UI_Menu(items, (windMaxX - 6) div 2, windMaxY - 6);
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

procedure GuessWord;
var
  x, y: integer;
  word: string;
begin
  ClrScr;
  UI_DrawWindow;

  // CL_Length * 2 para compensar los espacios que se muestran en CL_Show
  x := (windMaxX - (CL_Length(words[wordIndex].word) * 2)) div 2;
  y := windMinY + 10;
  GotoXY(x, y + 1);
  CL_Show(words[wordIndex].word, false);

  UI_Write(Concat('Jugador: ', player.name), windMinX + 4, windMinY + 2);
  UI_Write(Concat('Puntaje: ', IntToStr(player.score)), windMaxX - 16, windMinY + 2);
  UI_Write(Concat('Letra: ', Uppercase(words[wordIndex].letter)), (windMaxX - 8) div 2, windMinY + 2);

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
  Acción SaveScore

  Muestra y guarda el puntaje del jugador.
}
procedure SaveScore;
var
  item: TMenuItem;
  items: TMenuItems;
  x, y: integer;
begin
  ClrScr;
  UI_DrawWindow;

  x := (windMaxX - 14 - Length(player.name)) div 2;
  y := windMinY + 10;
  UI_Write(Concat('¡Felicidades ', player.name, '!'), x, y);

  x := (windMaxX - 22) div 2;
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
    SaveScore;

  ClrScr;
  UI_DrawWindow;

  // CL_Length * 2 para compensar los espacios que se muestran en CL_Show
  x := (windMaxX - (CL_Length(words[wordIndex].word) * 2)) div 2;
  y := windMinY + 10;
  GotoXY(x, y + 1);
  CL_Show(words[wordIndex].word, false);

  UI_Write(Concat('Jugador: ', player.name), windMinX + 4, windMinY + 2);
  UI_Write(Concat('Puntaje: ', IntToStr(player.score)), windMaxX - 16, windMinY + 2);
  UI_Write(Concat('Letra: ', Uppercase(words[wordIndex].letter)), (windMaxX - 8) div 2, windMinY + 2);

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
  UI_Menu(items, (windMaxX - 16) div 2, windMaxY - 6 + (i * -1));
end;

{
  Acción Play

  Inicia una partida en el nivel dado.
}
procedure Play();
begin
  UI_DrawWindow;

  LoadWords(words);

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
  item.action := @Exit;
  items.items[1] := item;

  item.text := 'Cambiar de usuario';
  item.action := @Exit;
  items.items[2] := item;

  item.text := 'Mejores puntajes';
  item.action := @Exit;
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
  x: integer;
begin
  UI_DrawWindow;
  UI_DrawLogo;

  x := (windMaxX - 32) div 2;
  UI_Write('  ¡Bienvenido a Pasapalabra!  ', x, windMaxY - 9);
  UI_Write('Ingresa tu nombre para comenzar', x, windMaxY - 8);
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
