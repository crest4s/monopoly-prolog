% =============================================================================
% main.pl — Punto de entrada del Monopoly Clásico Español en Prolog
% =============================================================================
% Uso:
%   $ cd monopolio_v2
%   $ swipl main.pl
%   ?- main.
% =============================================================================

% --- Carga del motor y escenarios ---
:- consult('src/loader').
:- consult('escenarios/loader_escenarios').
:- consult('src/stats/simulacion').

% =============================================================================
% MENÚ PRINCIPAL
% =============================================================================

main :-
    nl,
    write('============================================================'), nl,
    write('     MONOPOLY CLASICO ESPANOL — Motor Logico en Prolog'), nl,
    write('============================================================'), nl,
    write('  Escenarios basicos:'), nl,
    write('   1. Compras iniciales (3 jugadores, 6 turnos)'), nl,
    write('   2. Monopolio formado (alquiler doble)'), nl,
    write('   3. Proximo a bancarrota (eliminacion)'), nl,
    write('   4. Multiples alquileres consecutivos'), nl,
    write('   5. Simulacion completa (4 jugadores, 10 turnos)'), nl, nl,
    write('  Escenarios avanzados:'), nl,
    write('   6. Mecanicas de carcel'), nl,
    write('   7. Cartas de Suerte'), nl,
    write('   8. Cartas de Caja de Comunidad'), nl,
    write('   9. Dobles y triple doble'), nl,
    write('  10. Alquiler de estaciones'), nl,
    write('  11. Alquiler de servicios'), nl,
    write('  12. Paso por Salida'), nl,
    write('  13. Casillas de impuestos'), nl,
    write('  14. Partida larga (hasta 200 turnos)'), nl, nl,
    write('  Estadisticas:'), nl,
    write('  20. Simular lote (50 partidas con CSV)'), nl, nl,
    write('   0. Salir'), nl, nl,
    write('  Opcion: '),
    read(Opcion),
    ejecutar_opcion(Opcion).

ejecutar_opcion(0) :-
    !, nl,
    write('  Gracias por jugar. Hasta pronto!'), nl, nl.
ejecutar_opcion(1)  :- !, ejecutar_escenario_1,  nl, main.
ejecutar_opcion(2)  :- !, ejecutar_escenario_2,  nl, main.
ejecutar_opcion(3)  :- !, ejecutar_escenario_3,  nl, main.
ejecutar_opcion(4)  :- !, ejecutar_escenario_4,  nl, main.
ejecutar_opcion(5)  :- !, ejecutar_escenario_5,  nl, main.
ejecutar_opcion(6)  :- !, ejecutar_escenario_6,  nl, main.
ejecutar_opcion(7)  :- !, ejecutar_escenario_7,  nl, main.
ejecutar_opcion(8)  :- !, ejecutar_escenario_8,  nl, main.
ejecutar_opcion(9)  :- !, ejecutar_escenario_9,  nl, main.
ejecutar_opcion(10) :- !, ejecutar_escenario_10, nl, main.
ejecutar_opcion(11) :- !, ejecutar_escenario_11, nl, main.
ejecutar_opcion(12) :- !, ejecutar_escenario_12, nl, main.
ejecutar_opcion(13) :- !, ejecutar_escenario_13, nl, main.
ejecutar_opcion(14) :- !, ejecutar_escenario_14, nl, main.
ejecutar_opcion(20) :-
    !,
    write('  Simulando 50 partidas de 200 turnos...'), nl,
    simular_lote(50, 200),
    write('  CSVs guardados en stats/data/'), nl,
    nl, main.
ejecutar_opcion(_) :-
    write('  Opcion no valida. Intente de nuevo.'), nl,
    main.

ejecutar :- main.

% =============================================================================
% Inicio automático (descomentar para auto-arranque):
% :- main.
% =============================================================================
