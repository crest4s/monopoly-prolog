:- use_module(library(plunit)).

:- begin_tests(impuestos).

test(impuesto_capital_200) :-
    tablero(T),
    Jugadores = [jugador('Ana', 4, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    aplicar_impuesto(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 4, 1300, [])], T, 0, 42, [], []).

test(impuesto_lujo_100) :-
    tablero(T),
    Jugadores = [jugador('Ana', 38, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    aplicar_impuesto(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 38, 1400, [])], T, 0, 42, [], []).

test(no_impuesto_en_otra_casilla) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    aplicar_impuesto(Estado, NuevoEstado),
    NuevoEstado == Estado.

:- end_tests(impuestos).
