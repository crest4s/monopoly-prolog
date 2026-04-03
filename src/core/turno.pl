% =============================================================================
% turno.pl — Bucle principal, movimiento y lógica de turnos
% =============================================================================

% =============================================================================
% MOVIMIENTO
% =============================================================================

mover_jugador(Estado, SumaDados, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, PosActual, Dinero, Props),
    SumaPos is PosActual + SumaDados,
    mi_mod(SumaPos, 40, NuevaPos),
    comprobar_paso_salida(PosActual, NuevaPos, Dinero, DineroConSalida),
    EstadoSinLog = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    (DineroConSalida > Dinero ->
        log_evento(EstadoSinLog, paso_salida, Nombre, DineroConSalida, '', '', '', EstadoLog1)
    ; EstadoLog1 = EstadoSinLog),
    log_evento(EstadoLog1, movimiento, Nombre, PosActual, NuevaPos, '', '', EstadoLog2),
    JugadorMovido = jugador(Nombre, NuevaPos, DineroConSalida, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorMovido, NuevosJugadores),
    EstadoLog2 = estado(_, _, _, _, _, _, Logger2),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger2),
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
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, _, Dinero, Props)),
    format("  ~w saca TRES DOBLES CONSECUTIVOS! Va a la Carcel~n", [Nombre]),
    encarcelar_en_lista(Nombre, Carcel, NuevaCarcel),
    EstadoSinLog = estado(Jugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios, Logger),
    log_evento(EstadoSinLog, carcel_entrada, Nombre, triple_doble, '', '', '', EstadoLog),
    JugadorAct = jugador(Nombre, 10, Dinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    EstadoLog = estado(_, _, _, _, _, _, Logger2),
    EstadoFinal = estado(NuevosJugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios, Logger2).

ejecutar_turno_con_dobles(Estado, ContDobles, EstadoFinal) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, _, _, _),

    % 1. Tirar dados
    tirar_dados(Semilla, D1, D2, SonDobles, S1),
    SumaDados is D1 + D2,
    Estado1 = estado(Jugadores, Tablero, Turno, S1, Carcel, Edificios, Logger),
    log_evento(Estado1, dados, Nombre, D1, D2, SumaDados, SonDobles, Estado1Log),
    (ContDobles =:= 0 ->
        format("~n  --- Turno de ~w ---~n", [Nombre])
    ;
        format("  --- ~w tira de nuevo (dobles #~w) ---~n", [Nombre, ContDobles])
    ),
    format("  Dados: ~w + ~w = ~w", [D1, D2, SumaDados]),
    (SonDobles = true -> write(' (DOBLES!)') ; true), nl,

    % 2. Gestionar cárcel si aplica
    turno_carcel(Estado1Log, D1, D2, SonDobles, Estado2, PuedeMover),

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
    log_snapshot_turno(Estado5, Nombre, Estado6),

    % 6. Turno extra por dobles
    Estado6 = estado(_, _, _, _, Carcel5, _, _),
    (SonDobles = true, PuedeMover = true, \+ esta_en_carcel(Nombre, Carcel5) ->
        NuevoContDobles is ContDobles + 1,
        ejecutar_turno_con_dobles(Estado6, NuevoContDobles, EstadoFinal)
    ;
        EstadoFinal = Estado6
    ).

% =============================================================================
% BUCLE PRINCIPAL
% =============================================================================

jugar(Estado, 0, Estado) :-
    !,
    write('=== FIN DE LA SIMULACION (turnos agotados) ==='), nl,
    imprimir_estado(Estado).

jugar(Estado, _, Estado) :-
    Estado = estado(Jugadores, _, _, _, _, _, _),
    verificar_fin(Jugadores),
    !,
    Jugadores = [jugador(Ganador, _, _, _)],
    log_evento(Estado, ganador, Ganador, '', '', '', '', EstadoLog),
    format("~n=== ~w GANA LA PARTIDA! ===~n", [Ganador]),
    imprimir_estado(EstadoLog).

jugar(Estado, TurnosRestantes, EstadoFinal) :-
    Estado = estado(Jugadores, _, _, _, _, _, _),
    mi_longitud(Jugadores, NumJugadores),
    NumJugadores > 1,
    ejecutar_turno(Estado, Estado1),
    siguiente_turno(Estado1, Estado2),
    incrementar_turno_log(Estado2, Estado3),
    NuevosTurnos is TurnosRestantes - 1,
    jugar(Estado3, NuevosTurnos, EstadoFinal).

jugar_n_turnos(Estado, N, EstadoFinal) :-
    jugar(Estado, N, EstadoFinal).
