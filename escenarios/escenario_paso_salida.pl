% Escenario 12: Paso por la casilla de salida
% Jugadores en posiciones altas del tablero para pasar pronto por la salida.

escenario_12(Estado) :-
    Jugadores = [
        jugador('Ana',   36, 1500, []),
        jugador('Bruno', 37, 1500, []),
        jugador('Clara', 38, 1500, [])
    ],
    crear_estado(Jugadores, 200, Estado).

ejecutar_escenario_12 :-
    nl, imprimir_linea,
    write('  ESCENARIO 12: PASO POR SALIDA'), nl,
    write('  Jugadores en posiciones 36-38, a punto de dar la vuelta'), nl,
    imprimir_linea, nl,
    escenario_12(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 9, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 12 ==='), nl,
    imprimir_estado(EstadoFinal).
