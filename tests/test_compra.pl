:- use_module(library(plunit)).

:- begin_tests(compra).

test(compra_propiedad_libre) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 1, 1440, [1])], T, 0, 42, [], [], logger_inactivo).

test(compra_sin_dinero) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 30, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_propiedad_ocupada) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, []),
                 jugador('Bruno', 5, 1500, [1])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_casilla_no_comprable) :-
    tablero(T),
    Jugadores = [jugador('Ana', 0, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(compra_estacion) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_compra(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 5, 1300, [5])], T, 0, 42, [], [], logger_inactivo).

:- end_tests(compra).
