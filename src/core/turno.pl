% =============================================================================
% turno.pl — Bucle principal, movimiento y lógica de turnos
% =============================================================================

% =============================================================================
% MOVIMIENTO
% =============================================================================

mover_jugador(Estado, SumaDados, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, PosActual, Dinero, Props),
    SumaPos is PosActual + SumaDados,
    mi_mod(SumaPos, 40, NuevaPos),
    comprobar_paso_salida(PosActual, NuevaPos, Dinero, DineroConSalida),
    (DineroConSalida > Dinero ->
        log_evento(paso_salida, Nombre, DineroConSalida, '', '', '')
    ; true),
    log_evento(movimiento, Nombre, PosActual, NuevaPos, '', ''),
    JugadorMovido = jugador(Nombre, NuevaPos, DineroConSalida, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorMovido, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    obtener_casilla(Tablero, NuevaPos, Casilla),
    nombre_casilla(Casilla, NombreCasilla),
    format("  ~w avanza a casilla ~w: ~w~n",
           [Nombre, NuevaPos, NombreCasilla]).

% =============================================================================
% TURNO CON DOBLES
% =============================================================================

ejecutar_turno(Estado, EstadoFinal) :-
    ejecutar_turno_con_dobles(Estado, 0, EstadoFinal).

% Tercer doble consecutivo → cárcel
ejecutar_turno_con_dobles(Estado, 3, EstadoFinal) :-
    !,
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, _, Dinero, Props)),
    format("  ~w saca TRES DOBLES CONSECUTIVOS! Va a la Carcel~n", [Nombre]),
    encarcelar_en_lista(Nombre, Carcel, NuevaCarcel),
    log_evento(carcel_entrada, Nombre, triple_doble, '', '', ''),
    JugadorAct = jugador(Nombre, 10, Dinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    EstadoFinal = estado(NuevosJugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios).

ejecutar_turno_con_dobles(Estado, ContDobles, EstadoFinal) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, _, _, _),

    % 1. Tirar dados
    tirar_dados(Semilla, D1, D2, SonDobles, S1),
    SumaDados is D1 + D2,
    Estado1 = estado(Jugadores, Tablero, Turno, S1, Carcel, Edificios),
    log_evento(dados, Nombre, D1, D2, SumaDados, SonDobles),
    (ContDobles =:= 0 ->
        format("~n  --- Turno de ~w ---~n", [Nombre])
    ;
        format("  --- ~w tira de nuevo (dobles #~w) ---~n", [Nombre, ContDobles])
    ),
    format("  Dados: ~w + ~w = ~w", [D1, D2, SumaDados]),
    (SonDobles = true -> write(' (DOBLES!)') ; true), nl,

    % 2. Gestionar cárcel si aplica
    turno_carcel(Estado1, D1, D2, SonDobles, Estado2, PuedeMover),

    (PuedeMover = true ->
        % 3. Mover jugador
        mover_jugador(Estado2, SumaDados, Estado3),
        % 4. Evaluar casilla
        evaluar_casilla(Estado3, SumaDados, Estado4),
        % 5. Verificar bancarrota
        regla_bancarrota(Estado4, Estado5)
    ;
        Estado5 = Estado2
    ),

    % Snapshot de estado del jugador tras su acción
    log_snapshot_turno(Estado5, Nombre),

    % 6. Turno extra por dobles
    Estado5 = estado(_, _, _, _, Carcel5, _),
    (SonDobles = true, PuedeMover = true, \+ esta_en_carcel(Nombre, Carcel5) ->
        NuevoContDobles is ContDobles + 1,
        ejecutar_turno_con_dobles(Estado5, NuevoContDobles, EstadoFinal)
    ;
        EstadoFinal = Estado5
    ).

% =============================================================================
% BUCLE PRINCIPAL
% =============================================================================

jugar(Estado, 0, Estado) :-
    !,
    write('=== FIN DE LA SIMULACION (turnos agotados) ==='), nl,
    imprimir_estado(Estado).

jugar(Estado, _, Estado) :-
    Estado = estado(Jugadores, _, _, _, _, _),
    verificar_fin(Jugadores),
    !,
    Jugadores = [jugador(Ganador, _, _, _)],
    log_evento(ganador, Ganador, '', '', '', ''),
    format("~n=== ~w GANA LA PARTIDA! ===~n", [Ganador]),
    imprimir_estado(Estado).

jugar(Estado, TurnosRestantes, EstadoFinal) :-
    Estado = estado(Jugadores, _, _, _, _, _),
    mi_longitud(Jugadores, NumJugadores),
    NumJugadores > 1,
    ejecutar_turno(Estado, Estado1),
    siguiente_turno(Estado1, Estado2),
    incrementar_turno_log,
    NuevosTurnos is TurnosRestantes - 1,
    jugar(Estado2, NuevosTurnos, EstadoFinal).

jugar_n_turnos(Estado, N, EstadoFinal) :-
    jugar(Estado, N, EstadoFinal).
