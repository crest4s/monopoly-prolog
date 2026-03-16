% =============================================================================
% escenario_suerte.pl — Escenario 7: Cartas de Suerte
% =============================================================================
% Jugadores posicionados cerca de casillas de Suerte (7, 22, 36).
% Se observan los diferentes efectos de las cartas.
% =============================================================================

escenario_7(Estado) :-
    Jugadores = [
        jugador('Ana',   4, 1500, []),
        jugador('Bruno', 19, 1500, []),
        jugador('Clara', 33, 1500, [])
    ],
    crear_estado(Jugadores, 77, Estado).

ejecutar_escenario_7 :-
    nl, imprimir_linea,
    write('  ESCENARIO 7: CARTAS DE SUERTE'), nl,
    write('  Jugadores cerca de casillas de Suerte (7, 22, 36)'), nl,
    imprimir_linea, nl,
    escenario_7(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 9, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 7 ==='), nl,
    imprimir_estado(EstadoFinal).
