{
  Esta unidad contiene definiciones de tipos, acciones y funciones para el manejo
  de los jugadores y sus puntajes.
}

unit PlayerManager;

interface

  type
    TPlayer = record
      name: string[20];
      score: integer;
    end;

    TPlayers = record
      data: array[0..255] of TPlayer;
      count: integer;
    end;

    procedure PM_SaveScore(player: TPlayer);
    function PM_HighScores: TPlayers;
    function PM_AverageScore(playerName: string): real;

implementation

  const
    filePath = 'player_score.dat';

  var
    f: file of TPlayer;

  {
    Acción OpenFile

    Abre el archivo, creandolo si no existe.
  }
  procedure OpenFile;
  begin
    Assign(f, filePath);
    {$I-}
      Reset(f);
    {$I+}
    if (IOResult <> 0) then
      Rewrite(f);
  end;

  {
    Acción Sort

    Dato-resultado players: TPlayers

    Ordena el arreglo de mayor a menor utilizando el algoritmo bubble sort.
  }
  procedure Sort(var players: TPlayers);
  var
    aux: TPlayer;
    i, j: integer;
  begin
    j := 1;

    while (j < players.count) do
    begin
      i := 0;
      while (i < players.count - j) do
      begin
        if (players.data[i].score < players.data[i + 1].score) then
        begin
          aux := players.data[i];
          players.data[i] := players.data[i + 1];
          players.data[i + 1] := aux;
        end;
        i := i + 1;
      end;
      j := j + 1;
    end;
  end;

  {
    Functión Average: Real

    Dato playerScores: TPlayers

    Calcula el puntaje promedio de un arreglo de TPlayer recursivamente.
  }
  function Average(playerScores: TPlayers; n: integer): real;
  begin
    if (playerScores.count = 1) then
      Average := playerScores.data[0].score / n
    else
    begin
      playerScores.count := playerScores.count - 1;
      playerScores.data[playerScores.count - 1].score :=
        playerScores.data[playerScores.count - 1].score +
        playerScores.data[playerScores.count].score;

      Average := Average(playerScores, n);
    end;
  end;

  {
    Acción PM_SaveScore

    Dato players

    Guarda el puntaje del jugador en un archivo.
  }
  procedure PM_SaveScore(player: TPlayer);
  begin
    OpenFile;
    Seek(f, FileSize(f));
    Write(f, player);
    Close(f);
  end;

  {
    Función PM_HighScores: TPlayers

    Devuelve el listado de jugadores con sus puntajes, ordenados de mayor a menor.
  }
  function PM_HighScores: TPlayers;
  var
    player: TPlayer;
    players: TPlayers;
  begin
    OpenFile;
    players.count := 0;

    while not (EOF(f)) do
    begin
      Read(f, player);
      players.data[players.count] := player;
      players.count := players.count + 1;
    end;

    Sort(players);
    Close(f);

    PM_HighScores := players;
  end;

  {
    Función PM_AverageScore: Real

    Dato playerName: String

    Devuelve el puntaje promedio del jugador dado.
  }
  function PM_AverageScore(playerName: string): real;
  var
    player: TPlayer;
    playerScores: TPlayers;
  begin
    OpenFile;
    playerScores.count := 0;

    while not (EOF(f)) do
    begin
      Read(f, player);
      if (player.name = playerName) then
      begin
        playerScores.data[playerScores.count] := player;
        playerScores.count := playerScores.count + 1;
      end;
    end;

    PM_AverageScore := Average(playerScores, playerScores.count);
  end;

end.
