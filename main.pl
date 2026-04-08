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
    write('  15. Modo libre (jugadores y turnos configurables)'), nl, nl,
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
ejecutar_opcion(15) :- !, ejecutar_modo_libre, nl, main.
ejecutar_opcion(20) :-
    !,
    write('  Simulando 50 partidas de 200 turnos...'), nl,
    simular_lote(50, 200),
    write('  CSVs guardados en stats/data/'), nl,
    nl, main.
ejecutar_opcion(_) :-
    write('  Opcion no valida. Intente de nuevo.'), nl,
    main.

ejecutar_modo_libre :-
    nl, imprimir_linea,
    write('  PARTIDA LIBRE'), nl,
    write('  Elige jugadores, semilla y si quieres limite de turnos o partida completa.'), nl,
    imprimir_linea, nl,
    pedir_entero_rango('  Numero de jugadores (2-8): ', 2, 8, NumJugadores),
    pedir_nombres_jugadores(1, NumJugadores, Nombres),
    pedir_semilla(Semilla),
    pedir_modo_partida(Modo, Turnos),
    inicializar_juego(Nombres, Semilla, EstadoInicial),
    nl,
    write('=== ESTADO INICIAL ==='), nl,
    imprimir_estado(EstadoInicial),
    (Modo = turnos ->
        jugar_n_turnos(EstadoInicial, Turnos, EstadoFinal)
    ;
        jugar_hasta_fin(EstadoInicial, EstadoFinal)
    ),
    nl,
    write('=== RESULTADO FINAL MODO LIBRE ==='), nl,
    imprimir_estado(EstadoFinal),
    imprimir_todas_propiedades(EstadoFinal).

pedir_modo_partida(Modo, Turnos) :-
    nl,
    write('  Modo de finalizacion:'), nl,
    write('   1. Jugar un numero fijo de turnos'), nl,
    write('   2. Jugar hasta que quede un solo jugador'), nl,
    write('  Opcion: '),
    read(Opcion),
    ( Opcion =:= 1 ->
        pedir_entero_rango('  Numero de turnos: ', 1, 100000, Turnos),
        Modo = turnos
    ; Opcion =:= 2 ->
        Turnos = 0,
        Modo = hasta_fin
    ;
        write('  Opcion no valida. Intente de nuevo.'), nl,
        pedir_modo_partida(Modo, Turnos)
    ).

pedir_semilla(Semilla) :-
    repeat,
    nl,
    write('  Semilla de la partida (entero): '),
    read(Entrada),
    ( integer(Entrada) ->
        Semilla = Entrada,
        !
    ;
        write('  Debe ser un numero entero.'), nl,
        fail
    ).

pedir_nombres_jugadores(Indice, Total, []) :-
    Indice > Total,
    !.

pedir_nombres_jugadores(Indice, Total, [Nombre|Resto]) :-
    Indice =< Total,
    pedir_nombre_jugador(Indice, Nombre),
    Siguiente is Indice + 1,
    pedir_nombres_jugadores(Siguiente, Total, Resto).

pedir_nombre_jugador(Indice, Nombre) :-
    repeat,
    format('  Nombre del jugador ~w (atomo, por ejemplo ana o ''Juan Perez''): ', [Indice]),
    read(Nombre),
    atom(Nombre),
    !.

pedir_entero_rango(Prompt, Min, Max, Valor) :-
    repeat,
    write(Prompt),
    read(Entrada),
    ( integer(Entrada), Entrada >= Min, Entrada =< Max ->
        Valor = Entrada,
        !
    ;
        format('  Debe ser un numero entre ~w y ~w.~n', [Min, Max]),
        fail
    ).

ejecutar :- main.

% =============================================================================
% Inicio automático (descomentar para auto-arranque):
% :- main.
% =============================================================================
