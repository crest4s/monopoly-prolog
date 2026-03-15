% Escenario 11: Alquiler de servicios
% Ana posee 1 servicio (x4), Bruno posee 2 servicios (x10).


escenario_11(Estado) :-
    Jugadores = [
        jugador('Ana',   0, 1350, [12]),
        jugador('Bruno', 20, 1200, [12, 28]),
        jugador('Clara', 10, 1500, [])
    ],
    crear_estado(Jugadores, 888, Estado).

ejecutar_escenario_11 :-
    nl, imprimir_linea,
    write('  ESCENARIO 11: ALQUILER DE SERVICIOS'), nl,
    write('  Ana: 1 servicio (x4 dados), Bruno: 2 servicios (x10 dados)'), nl,
    imprimir_linea, nl,
    escenario_11(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 12, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 11 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
