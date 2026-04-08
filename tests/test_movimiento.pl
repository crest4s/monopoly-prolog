% Test: Movimiento de jugadores
:- use_module(library(plunit)).

:- begin_tests(movimiento).

test(movimiento_normal) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    mover_jugador(Estado, 5, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 5, 1500, [])], T, 0, 42, [], [], logger_inactivo).

test(movimiento_circular) :-
    tablero(T),
    Jugadores = [jugador('Ana', 37, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    mover_jugador(Estado, 7, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 4, NuevoDinero, [])], T, 0, 42, [], [], logger_inactivo),
    NuevoDinero =:= 1700.  % Paso por Salida +200

test(siguiente_turno_circular) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, []),
                 jugador('Bruno', 0, 1500, []),
                 jugador('Clara', 0, 1500, [])],
    Estado = estado(Jugadores, T, 2, 42, [], [], logger_inactivo),
    siguiente_turno(Estado, estado(Jugadores, T, NuevoTurno, 42, [], [], logger_inactivo)),
    NuevoTurno =:= 0.

test(verificar_fin_un_jugador) :-
    verificar_fin([jugador('Ana', 0, 1500, [])]).

test(verificar_fin_dos_jugadores, [fail]) :-
    verificar_fin([jugador('Ana', 0, 1500, []),
                   jugador('Bruno', 0, 1500, [])]).

:- end_tests(movimiento).
