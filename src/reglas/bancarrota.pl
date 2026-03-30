% Regla 3 - bancarrota
regla_bancarrota(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, _, Dinero, Propiedades),
    Dinero < 0,
    !,
    log_evento(bancarrota, Nombre, Dinero, '', '', ''),
    format("~n  !! ~w esta en BANCARROTA (Saldo: ~w$)~n", [Nombre, Dinero]),
    format("  !! Se liberan ~w propiedades al tablero~n", [Propiedades]),
    liberar(Nombre),
    mi_eliminar_elemento(Jugadores, Jugador, JugadoresRestantes),
    mi_longitud(JugadoresRestantes, NumRestantes),
    (NumRestantes > 0 ->
        NuevoTurno is (Turno - 1 + NumRestantes) mod NumRestantes
    ;
        NuevoTurno = 0
    ),
    NuevoEstado = estado(JugadoresRestantes, Tablero, NuevoTurno, Semilla).

regla_bancarrota(Estado, Estado).
