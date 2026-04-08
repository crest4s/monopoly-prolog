% Escenario 6: Mecánicas de cárcel

escenario_6(Estado) :-
    Jugadores = [
        jugador('Ana',   10, 1400, [1, 3]),
        jugador('Bruno', 28, 1500, [11, 13]),
        jugador('Clara', 5, 1300, [6, 8, 9])
    ],
    crear_estado(Jugadores, 33, EstadoBase),
    EstadoBase = estado(J, T, Tu, S, [], E, Logger),
    encarcelar_en_lista('Ana', [], Carcel),
    Estado = estado(J, T, Tu, S, Carcel, E, Logger).

ejecutar_escenario_6 :-
    nl, imprimir_linea,
    write('  ESCENARIO 6: MECANICAS DE CARCEL'), nl,
    write('  Ana empieza en carcel. Bruno cerca de "Ir a Carcel"'), nl,
    write('  Se observan turnos en carcel y liberacion'), nl,
    imprimir_linea, nl,
    escenario_6(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 12, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 6 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
