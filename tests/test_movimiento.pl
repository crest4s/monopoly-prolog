% =============================================================================
% test_movimiento.pl — Tests para movimiento de jugadores
% =============================================================================
:- use_module(library(plunit)).

:- begin_tests(movimiento).

test(movimiento_normal) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    mover_jugador(Estado, 5, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 5, 1500, [])], T, 0, 42, [], []).

test(movimiento_circular) :-
    tablero(T),
    Jugadores = [jugador('Ana', 37, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    mover_jugador(Estado, 7, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 4, NuevoDinero, [])], T, 0, 42, [], []),
    NuevoDinero =:= 1700.  % Paso por Salida +200

test(siguiente_turno_circular) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, []),
                 jugador('Bruno', 0, 1500, []),
                 jugador('Clara', 0, 1500, [])],
    Estado = estado(Jugadores, T, 2, 42, [], []),
    siguiente_turno(Estado, estado(Jugadores, T, NuevoTurno, 42, [], [])),
    NuevoTurno =:= 0.

test(verificar_fin_un_jugador) :-
    verificar_fin([jugador('Ana', 0, 1500, [])]).

test(verificar_fin_dos_jugadores, [fail]) :-
    verificar_fin([jugador('Ana', 0, 1500, []),
                   jugador('Bruno', 0, 1500, [])]).

:- end_tests(movimiento).
