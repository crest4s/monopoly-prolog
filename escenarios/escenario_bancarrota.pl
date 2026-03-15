% Escenario: Bruno tiene solo 10$. Ana tiene propiedades caras.
escenario_3(Estado) :-
    Jugadores = [
        jugador('Ana',   15, 2000, [21, 23, 24, 31, 32, 34, 37, 39]),
        jugador('Bruno', 20, 10, []),
        jugador('Clara', 10, 1200, [11, 13, 14])
    ],
    crear_estado(Jugadores, 55, Estado).

ejecutar_escenario_3 :-
    nl, imprimir_linea,
    write('  ESCENARIO 3: PROXIMO A BANCARROTA'), nl,
    write('  Bruno tiene solo 10$, propiedades caras en el tablero'), nl,
    imprimir_linea, nl,
    escenario_3(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 9, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 3 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
