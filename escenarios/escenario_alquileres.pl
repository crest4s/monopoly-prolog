% Escenario 4: multiples alquileres consecutivos
% Propiedades repartidas entre 3 jugadores. Muchos cobros de alquiler.

escenario_4(Estado) :-
    Jugadores = [
        jugador('Ana',   0, 800, [1, 3, 6, 8, 9, 5]),
        jugador('Bruno', 10, 900, [11, 13, 14, 16, 18, 19]),
        jugador('Clara', 20, 1000, [21, 23, 24, 26, 27, 29])
    ],
    crear_estado(Jugadores, 256, Estado).

ejecutar_escenario_4 :-
    nl, imprimir_linea,
    write('  ESCENARIO 4: MULTIPLES ALQUILERES CONSECUTIVOS'), nl,
    write('  Propiedades repartidas entre 3 jugadores'), nl,
    imprimir_linea, nl,
    escenario_4(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 12, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 4 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
