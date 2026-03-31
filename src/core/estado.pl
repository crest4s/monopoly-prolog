% =============================================================================
% estado.pl — Inicialización y verificación de estado
% =============================================================================
% Estado: estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios)
%   Carcel:   lista de preso(Nombre, TurnosRestantes)
%   Edificios: lista de edificio(Pos, N)  (N: 1-4 casas, 5 hotel)
% =============================================================================

inicializar_juego(Nombres, Semilla, Estado) :-
    tablero(T),
    crear_jugadores(Nombres, Jugadores),
    Estado = estado(Jugadores, T, 0, Semilla, [], []).

crear_estado(Jugadores, Semilla, Estado) :-
    tablero(T),
    Estado = estado(Jugadores, T, 0, Semilla, [], []).

verificar_fin(Jugadores) :-
    mi_longitud(Jugadores, 1).
