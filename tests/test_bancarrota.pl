:- use_module(library(plunit)).

:- begin_tests(bancarrota).

test(bancarrota_eliminado) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, -10, []),
                 jugador('Bruno', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_bancarrota(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Bruno', 10, 1500, [])], T, 0, 42, [], [], logger_inactivo).

test(bancarrota_no_aplica) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 100, []),
                 jugador('Bruno', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_bancarrota(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(bancarrota_cero_no_aplica) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 0, []),
                 jugador('Bruno', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], [], logger_inactivo),
    regla_bancarrota(Estado, NuevoEstado),
    NuevoEstado == Estado.

test(bancarrota_ajusta_turno) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 500, []),
                 jugador('Bruno', 10, -5, []),
                 jugador('Clara', 20, 800, [])],
    Estado = estado(Jugadores, T, 1, 42, [], [], logger_inactivo),
    regla_bancarrota(Estado, NuevoEstado),
    NuevoEstado = estado(NJ, T, _, 42, _, _, _),
    mi_longitud(NJ, 2).

:- end_tests(bancarrota).
