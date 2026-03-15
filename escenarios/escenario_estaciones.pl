% Escenario 10: Alquiler de estaciones
% Ana posee 1 estación, Bruno posee 3 estaciones.

escenario_10(Estado) :-
    Jugadores = [
        jugador('Ana',   0, 1200, [5]),
        jugador('Bruno', 10, 900, [15, 25, 35]),
        jugador('Clara', 20, 1500, [])
    ],
    crear_estado(Jugadores, 500, Estado).

ejecutar_escenario_10 :-
    nl, imprimir_linea,
    write('  ESCENARIO 10: ALQUILER DE ESTACIONES'), nl,
    write('  Ana: 1 estacion (25$), Bruno: 3 estaciones (75$ c/u)'), nl,
    imprimir_linea, nl,
    escenario_10(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 12, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 10 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
