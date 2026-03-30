% =============================================================================
% logger.pl — Logger de eventos a CSV para estadísticas
% =============================================================================
% Uso:
%   iniciar_log('stats/data/partida_1.csv'),
%   ... jugar ...,
%   cerrar_log.
%
% Si no se inicia el log, todos los predicados son no-ops.
% =============================================================================

:- dynamic log_activo/0.
:- dynamic log_stream/1.
:- dynamic log_turno_actual/1.

% --- Iniciar logging ---
iniciar_log(Archivo) :-
    cerrar_log_si_activo,
    open(Archivo, write, Stream),
    assert(log_activo),
    assert(log_stream(Stream)),
    assert(log_turno_actual(1)),
    format(Stream, "evento,turno,jugador,v1,v2,v3,v4~n", []).

% --- Cerrar logging ---
cerrar_log :-
    (log_activo ->
        log_stream(Stream),
        close(Stream),
        retractall(log_activo),
        retractall(log_stream(_)),
        retractall(log_turno_actual(_))
    ; true).

cerrar_log_si_activo :-
    (log_activo -> cerrar_log ; true).

% --- Incrementar contador de turno ---
incrementar_turno_log :-
    (log_activo ->
        log_turno_actual(T),
        retractall(log_turno_actual(_)),
        T1 is T + 1,
        assert(log_turno_actual(T1))
    ; true).

% --- Registrar evento ---
log_evento(Evento, Jugador, V1, V2, V3, V4) :-
    (log_activo ->
        log_stream(Stream),
        log_turno_actual(T),
        format(Stream, "~w,~w,~w,~w,~w,~w,~w~n",
               [Evento, T, Jugador, V1, V2, V3, V4])
    ; true).

% --- Snapshot de un jugador específico ---
log_snapshot_turno(estado(Jugadores, _, _, _), Nombre) :-
    (log_activo ->
        buscar_jugador_por_nombre(Jugadores, Nombre, jugador(_, Pos, Dinero, Props)),
        mi_longitud(Props, NumProps),
        log_evento(saldo, Nombre, Dinero, Pos, NumProps, '')
    ; true).

% --- Snapshot de todos los jugadores ---
log_snapshot_todos(estado(Jugadores, _, _, _)) :-
    (log_activo ->
        log_snapshot_jugadores(Jugadores)
    ; true).

log_snapshot_jugadores([]).
log_snapshot_jugadores([jugador(Nombre, Pos, Dinero, Props)|Rest]) :-
    mi_longitud(Props, NumProps),
    log_evento(saldo, Nombre, Dinero, Pos, NumProps, ''),
    log_snapshot_jugadores(Rest).

% --- Buscar jugador por nombre ---
buscar_jugador_por_nombre([jugador(Nombre, P, D, Pr)|_], Nombre, jugador(Nombre, P, D, Pr)) :- !.
buscar_jugador_por_nombre([_|R], Nombre, J) :-
    buscar_jugador_por_nombre(R, Nombre, J).
buscar_jugador_por_nombre([], _, _) :- fail.
