% Escenario: 4 jugadores, 200 turnos: simulación completa hasta que quede 1.

escenario_14(Estado) :-
    inicializar_juego(['Ana', 'Bruno', 'Clara', 'David'], 12345, Estado).

ejecutar_escenario_14 :-
    nl, imprimir_linea,
    write('  ESCENARIO 14: PARTIDA LARGA'), nl,
    write('  4 jugadores, 1500$ cada uno, hasta 200 turnos'), nl,
    imprimir_linea, nl,
    escenario_14(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 200, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 14 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
