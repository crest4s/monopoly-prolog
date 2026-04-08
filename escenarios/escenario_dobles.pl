% Escenario 9: Dobles y triple doble

escenario_9(Estado) :-
    inicializar_juego(['Ana', 'Bruno', 'Clara'], 314, Estado).

ejecutar_escenario_9 :-
    nl, imprimir_linea,
    write('  ESCENARIO 9: DOBLES Y TRIPLE DOBLE'), nl,
    write('  3 jugadores, se observan dobles y turnos extra'), nl,
    imprimir_linea, nl,
    escenario_9(Estado),
    imprimir_estado(Estado),
    jugar_n_turnos(Estado, 20, EstadoFinal),
    nl,
    write('=== RESULTADO FINAL ESCENARIO 9 ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).
