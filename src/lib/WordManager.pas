{
  Esta unidad contiene tipos y funciones para manejar las palabras del juego.
}

unit WordManager;

interface

uses
  Crt,
  SysUtils,
  CharList;

  type
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

  procedure WM_LoadWords(var words: TWords; level: integer);

implementation

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

    if (CL_Length(word.word) < 4) then
      quantity := 1;

    if (CL_Length(word.word) = 4) then
      quantity := 2;

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
  procedure WM_LoadWords(var words: TWords; level: integer);
  const
    filePath = 'words.dat';
  var
    f: file of TArrWord;
    w1: TArrWord;
    w2: TWord;
    i, j, k: integer;
  begin
    Randomize;
    Assign(f, filePath);
    Reset(f);

    if (EOF(f)) then
    begin
      ClrScr;
      WriteLn('Se ha producido un error al cargar las palabras.');
      Halt;
    end;

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

end.
