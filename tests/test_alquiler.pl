:- use_module(library(plunit)).

:- begin_tests(alquiler).

test(alquiler_propiedad_simple) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, []),
                 jugador('Bruno', 5, 1500, [1])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 1, DineroAna, _)),
    mi_obtener_elemento(NJ, 1, jugador('Bruno', 5, DineroBruno, _)),
    DineroAna =:= 1498,    % Alquiler base de pos 1 = 2
    DineroBruno =:= 1502.

test(alquiler_propia_no_cobra) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, [1])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado == Estado.

test(alquiler_monopolio_doble) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, []),
                 jugador('Bruno', 5, 1500, [1, 3])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 1, DineroAna, _)),
    DineroAna =:= 1496.    % 2 * 2 = 4 (monopolio)

test(alquiler_estacion_una) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, []),
                 jugador('Bruno', 10, 1500, [5])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 5, DineroAna, _)),
    DineroAna =:= 1475.    % 25 * 1

test(alquiler_estacion_tres) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, []),
                 jugador('Bruno', 10, 1500, [5, 15, 25])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 5, DineroAna, _)),
    DineroAna =:= 1425.    % 25 * 3

test(alquiler_servicio_uno) :-
    tablero(T),
    Jugadores = [jugador('Ana', 12, 1500, []),
                 jugador('Bruno', 10, 1500, [12])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 8, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 12, DineroAna, _)),
    DineroAna =:= 1468.    % 8 * 4

test(alquiler_servicio_dos) :-
    tablero(T),
    Jugadores = [jugador('Ana', 12, 1500, []),
                 jugador('Bruno', 10, 1500, [12, 28])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_alquiler(Estado, 8, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], []),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 12, DineroAna, _)),
    DineroAna =:= 1420.    % 8 * 10

:- end_tests(alquiler).
