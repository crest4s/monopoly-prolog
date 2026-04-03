% =============================================================================
% logger.pl — Logger de eventos a CSV para estadísticas (sin estado global)
% =============================================================================

% Logger en el estado:
%   logger_inactivo
%   logger_activo(Stream, TurnoLog)

logger_esta_activo(logger_activo(_, _)).

estado_con_logger(estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, _),
                 Logger,
                 estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger)).

obtener_logger(estado(_, _, _, _, _, _, Logger), Logger).

% --- Iniciar logging ---
iniciar_log(EstadoIn, Archivo, EstadoOut) :-
    cerrar_log_si_activo(EstadoIn, EstadoCerrado),
    open(Archivo, write, Stream),
    Logger = logger_activo(Stream, 1),
    estado_con_logger(EstadoCerrado, Logger, EstadoOut),
    format(Stream, "evento,turno,jugador,v1,v2,v3,v4~n", []).

% --- Cerrar logging ---
cerrar_log(EstadoIn, EstadoOut) :-
    obtener_logger(EstadoIn, Logger),
    (logger_esta_activo(Logger) ->
        Logger = logger_activo(Stream, _),
        close(Stream),
        estado_con_logger(EstadoIn, logger_inactivo, EstadoOut)
    ;
        EstadoOut = EstadoIn
    ).

cerrar_log_si_activo(EstadoIn, EstadoOut) :-
    obtener_logger(EstadoIn, Logger),
    (logger_esta_activo(Logger) ->
        cerrar_log(EstadoIn, EstadoOut)
    ;
        EstadoOut = EstadoIn
    ).

% --- Incrementar contador de turno ---
incrementar_turno_log(EstadoIn, EstadoOut) :-
    obtener_logger(EstadoIn, Logger),
    (Logger = logger_activo(Stream, T) ->
        T1 is T + 1,
        estado_con_logger(EstadoIn, logger_activo(Stream, T1), EstadoOut)
    ;
        EstadoOut = EstadoIn
    ).

% --- Registrar evento ---
log_evento(EstadoIn, Evento, Jugador, V1, V2, V3, V4, EstadoOut) :-
    obtener_logger(EstadoIn, Logger),
    (Logger = logger_activo(Stream, T) ->
        format(Stream, "~w,~w,~w,~w,~w,~w,~w~n",
               [Evento, T, Jugador, V1, V2, V3, V4]),
        EstadoOut = EstadoIn
    ;
        EstadoOut = EstadoIn
    ).

% --- Snapshot de un jugador específico ---
log_snapshot_turno(EstadoIn, Nombre, EstadoOut) :-
    EstadoIn = estado(Jugadores, _, _, _, _, _, _),
    (buscar_jugador_por_nombre(Jugadores, Nombre, jugador(_, Pos, Dinero, Props)) ->
        mi_longitud(Props, NumProps),
        log_evento(EstadoIn, saldo, Nombre, Dinero, Pos, NumProps, '', EstadoOut)
    ;
        EstadoOut = EstadoIn
    ).

% --- Snapshot de todos los jugadores ---
log_snapshot_todos(EstadoIn, EstadoOut) :-
    EstadoIn = estado(Jugadores, _, _, _, _, _, _),
    log_snapshot_jugadores(Jugadores, EstadoIn, EstadoOut).

log_snapshot_jugadores([], Estado, Estado).
log_snapshot_jugadores([jugador(Nombre, Pos, Dinero, Props)|Rest], EstadoIn, EstadoOut) :-
    mi_longitud(Props, NumProps),
    log_evento(EstadoIn, saldo, Nombre, Dinero, Pos, NumProps, '', Estado1),
    log_snapshot_jugadores(Rest, Estado1, EstadoOut).

% --- Buscar jugador por nombre ---
buscar_jugador_por_nombre([jugador(Nombre, P, D, Pr)|_], Nombre, jugador(Nombre, P, D, Pr)) :- !.
buscar_jugador_por_nombre([_|R], Nombre, J) :-
    buscar_jugador_por_nombre(R, Nombre, J).
buscar_jugador_por_nombre([], _, _) :- fail.
