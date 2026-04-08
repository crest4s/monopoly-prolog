% Escenario 13: Casillas de impuestos
% Jugadores cerca de impuestos (pos 4 y 38).

escenario_13(Estado) :-
    Jugadores = [
        jugador('Ana',   1, 1500, []),
        jugador('Bruno', 35, 1500, []),
        jugador('Clara', 0, 1500, [])
    ],
    crear_estado(Jugadores, 150, Estado).

ejecutar_escenario_13 :-
    nl, imprimir_linea,
    write('  ESCENARIO 13: CASILLAS DE IMPUESTOS'), nl,
    write('  Jugadores cerca de impuestos (pos 4: 200€, pos 38: 100€)'), nl,
    imprimir_linea, nl,
    escenario_13(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 9, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 13 ==='), nl,
    imprimir_estado(EstadoFinal).
