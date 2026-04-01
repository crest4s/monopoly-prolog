:- use_module(library(plunit)).

:- begin_tests(carcel).

test(encarcelar_lista) :-
    encarcelar_en_lista('Ana', [], Carcel),
    esta_en_carcel('Ana', Carcel).

test(liberar_lista) :-
    encarcelar_en_lista('Ana', [], C0),
    liberar_de_lista('Ana', C0, C1),
    \+ esta_en_carcel('Ana', C1).

test(no_en_carcel_por_defecto, [fail]) :-
    esta_en_carcel('NuevoJugador', []).

test(turno_carcel_dobles_libera) :-
    tablero(T),
    encarcelar_en_lista('Ana', [], C0),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, C0, []),
    turno_carcel(Estado, 3, 3, true, NuevoEstado, PuedeMover),
    PuedeMover = true,
    NuevoEstado = estado(_, _, _, _, C1, _),
    \+ esta_en_carcel('Ana', C1).

test(turno_carcel_sin_dobles_sigue) :-
    tablero(T),
    encarcelar_en_lista('Ana', [], C0),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, C0, []),
    turno_carcel(Estado, 3, 4, false, NuevoEstado, PuedeMover),
    PuedeMover = false,
    NuevoEstado = estado(_, _, _, _, C1, _),
    esta_en_carcel('Ana', C1).

test(turno_carcel_tercer_turno_paga) :-
    tablero(T),
    encarcelar_en_lista('Ana', [], C0),
    actualizar_turnos_carcel('Ana', 1, C0, C1),
    Jugadores = [jugador('Ana', 10, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, C1, []),
    turno_carcel(Estado, 2, 5, false, NuevoEstado, PuedeMover),
    PuedeMover = true,
    NuevoEstado = estado(NJ, _, _, _, C2, _),
    \+ esta_en_carcel('Ana', C2),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 10, DineroAna, _)),
    DineroAna =:= 1450.

test(jugador_libre_no_afecta) :-
    tablero(T),
    Jugadores = [jugador('Ana', 5, 1500, [])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    turno_carcel(Estado, 3, 4, false, NuevoEstado, PuedeMover),
    PuedeMover = true,
    NuevoEstado == Estado.

test(multiples_presos) :-
    encarcelar_en_lista('Ana', [], C0),
    encarcelar_en_lista('Bruno', C0, C1),
    esta_en_carcel('Ana', C1),
    esta_en_carcel('Bruno', C1).

:- end_tests(carcel).
