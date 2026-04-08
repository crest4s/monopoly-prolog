% Escenario 8: Cartas de Caja de Comunidad

escenario_8(Estado) :-
    Jugadores = [
        jugador('Ana',   0, 1500, []),
        jugador('Bruno', 14, 1500, []),
        jugador('Clara', 30, 1500, [])
    ],
    crear_estado(Jugadores, 123, Estado).

ejecutar_escenario_8 :-
    nl, imprimir_linea,
    write('  ESCENARIO 8: CARTAS DE CAJA DE COMUNIDAD'), nl,
    write('  Jugadores cerca de casillas de Caja (2, 17, 33)'), nl,
    imprimir_linea, nl,
    escenario_8(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 9, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 8 ==='), nl,
    imprimir_estado(EstadoFinal).
