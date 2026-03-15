% Escenario: Ana posee monopolio marrón (pos 1, 3). Bruno cae y paga doble.

escenario_2(Estado) :-
    Jugadores = [
        jugador('Ana',   5, 1300, [1, 3]),
        jugador('Bruno', 0, 1500, []),
        jugador('Clara', 20, 1400, [21])
    ],
    crear_estado(Jugadores, 100, Estado).

ejecutar_escenario_2 :-
    nl, imprimir_linea,
    write('  ESCENARIO 2: MONOPOLIO FORMADO'), nl,
    write('  Ana tiene monopolio marron (pos 1, 3)'), nl,
    write('  Alquiler doble al caer en sus propiedades'), nl,
    imprimir_linea, nl,
    escenario_2(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 6, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 2 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
