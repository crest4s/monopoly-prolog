% Escenario 11: Alquiler de servicios
% Bruno posee 2 servicios (x10), Ana posee 1 propiedad regular.


escenario_11(Estado) :-
    Jugadores = [
        jugador('Ana',   0, 1350, [1]),
        jugador('Bruno', 20, 1200, [12, 28]),
        jugador('Clara', 10, 1500, [])
    ],
    crear_estado(Jugadores, 888, Estado).

ejecutar_escenario_11 :-
    nl, imprimir_linea,
    write('  ESCENARIO 11: ALQUILER DE SERVICIOS'), nl,
    write('  Bruno: 2 servicios (x10 dados), Ana: 1 propiedad regular'), nl,
    imprimir_linea, nl,
    escenario_11(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 12, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 11 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
