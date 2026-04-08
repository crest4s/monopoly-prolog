% Escenario 1: Compras iniciales

escenario_1(Estado) :-
    inicializar_juego(['Ana', 'Bruno', 'Clara'], 42, Estado).

ejecutar_escenario_1 :-
    nl, imprimir_linea,
    write('  ESCENARIO 1: COMPRAS INICIALES'), nl,
    write('  3 jugadores, 1500€ cada uno, 6 turnos'), nl,
    imprimir_linea, nl,
    escenario_1(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 6, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 1 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
