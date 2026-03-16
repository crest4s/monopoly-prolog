% =============================================================================
% simulacion.pl — Simulación con logging estadístico
% =============================================================================
% Ejecuta N simulaciones y guarda eventos en CSV.
%
% Uso desde línea de comandos:
%   $ swipl -g "simular_lote(50, 200)" -t halt main.pl
%
% Esto ejecuta 50 partidas de hasta 200 turnos cada una.
% Los CSV se guardan en stats/data/partida_N.csv
% =============================================================================

% --- Simular una partida con logging ---
simular_partida_con_log(Semilla, MaxTurnos, Archivo) :-
    iniciar_log(Archivo),
    inicializar_juego(['Ana', 'Bruno', 'Clara', 'David'], Semilla, Estado),
    log_snapshot_todos(Estado),
    jugar_n_turnos(Estado, MaxTurnos, _EstadoFinal),
    cerrar_log.

% --- Simular un lote de partidas ---
simular_lote(NumPartidas, MaxTurnos) :-
    simular_lote_acc(1, NumPartidas, MaxTurnos).

simular_lote_acc(I, N, _) :-
    I > N, !,
    format("~n=== Lote completado: ~w partidas simuladas ===~n", [N]).

simular_lote_acc(I, N, MaxTurnos) :-
    I =< N,
    format("~nSimulando partida ~w/~w...~n", [I, N]),
    number_codes(I, Codes),
    atom_codes(IAtom, Codes),
    atom_concat('stats/data/partida_', IAtom, Temp),
    atom_concat(Temp, '.csv', Archivo),
    Semilla is I * 7919 + 42,
    simular_partida_con_log(Semilla, MaxTurnos, Archivo),
    I1 is I + 1,
    simular_lote_acc(I1, N, MaxTurnos).
