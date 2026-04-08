% Escenario 5: Simulación completa de 10 turnos

escenario_5(Estado) :-
    inicializar_juego(['Ana', 'Bruno', 'Clara', 'David'], 2026, Estado).

ejecutar_escenario_5 :-
    nl, imprimir_linea,
    write('  ESCENARIO 5: SIMULACION DE 10 TURNOS'), nl,
    write('  4 jugadores, 1500€ cada uno, 10 turnos completos'), nl,
    imprimir_linea, nl,
    escenario_5(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 10, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 5 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
