:- use_module(library(plunit)).

:- begin_tests(compra, [setup(limpiar_carcel)]).

test(compra_propiedad_libre) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 1, 1440, [1])], T, 0, 42).

test(compra_sin_dinero) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 30, [])],
    Estado = estado(Jugadores, T, 0, 42),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_propiedad_ocupada) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, []),
                 jugador('Bruno', 5, 1500, [1])],
    Estado = estado(Jugadores, T, 0, 42),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_casilla_no_comprable) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_estacion) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 5, 1300, [5])], T, 0, 42).

:- end_tests(compra).
