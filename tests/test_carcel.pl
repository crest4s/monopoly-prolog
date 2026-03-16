:- use_module(library(plunit)).

:- begin_tests(carcel, [setup(limpiar_carcel), cleanup(limpiar_carcel)]).

test(encarcelar_marca) :-
    encarcelar('Ana'),
    esta_en_carcel('Ana').

test(liberar_desmarca) :-
    encarcelar('Ana'),
    liberar('Ana'),
    \+ esta_en_carcel('Ana').

test(no_en_carcel_por_defecto, [fail]) :-
    esta_en_carcel('NuevoJugador').

test(turno_carcel_dobles_libera) :-
    tablero(T),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    encarcelar('Ana'),
    turno_carcel(Estado, 3, 3, true, _, PuedeMover),
    PuedeMover = true,
    \+ esta_en_carcel('Ana').

test(turno_carcel_sin_dobles_sigue) :-
    tablero(T),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    encarcelar('Ana'),
    turno_carcel(Estado, 3, 4, false, _, PuedeMover),
    PuedeMover = false,
    esta_en_carcel('Ana').

test(turno_carcel_tercer_turno_paga) :-
    limpiar_carcel,
    tablero(T),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    encarcelar('Ana'),
    retract(user:en_carcel('Ana', 3)),
    assertz(user:en_carcel('Ana', 1)),
    turno_carcel(Estado, 2, 5, false, NuevoEstado, PuedeMover),
    PuedeMover = true,
    \+ esta_en_carcel('Ana'),
    NuevoEstado = estado(NJ, _, _, _),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 10, DineroAna, _)),
    DineroAna =:= 1450.

test(jugador_libre_no_afecta) :-
    limpiar_carcel,
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42),
    turno_carcel(Estado, 3, 4, false, NuevoEstado, PuedeMover),
    PuedeMover = true,
    NuevoEstado == Estado.

test(limpiar_carcel_limpia) :-
    encarcelar('Ana'),
    encarcelar('Bruno'),
    limpiar_carcel,
    \+ esta_en_carcel('Ana'),
    \+ esta_en_carcel('Bruno').

:- end_tests(carcel).
