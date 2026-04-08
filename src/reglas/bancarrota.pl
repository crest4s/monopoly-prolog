% Regla 3 - bancarrota
regla_bancarrota(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, _Logger),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, _, Dinero, Propiedades),
    Dinero < 0,
    !,
    log_evento(Estado, bancarrota, Nombre, Dinero, '', '', '', EstadoLog),
    format("~n  !! ~w esta en BANCARROTA (Saldo: ~w€)~n", [Nombre, Dinero]),
    format("  !! Se liberan ~w propiedades al tablero~n", [Propiedades]),
    liberar_de_lista(Nombre, Carcel, NuevaCarcel),
    limpiar_edificios_de(Propiedades, Edificios, NuevosEdificios),
    mi_eliminar_elemento(Jugadores, Jugador, JugadoresRestantes),
    mi_longitud(JugadoresRestantes, NumRestantes),
    (NumRestantes > 0 ->
        T1 is Turno - 1 + NumRestantes,
        mi_mod(T1, NumRestantes, NuevoTurno)
    ;
        NuevoTurno = 0
    ),
    EstadoLog = estado(_, _, _, _, _, _, LoggerLog),
    NuevoEstado = estado(JugadoresRestantes, Tablero, NuevoTurno, Semilla, NuevaCarcel, NuevosEdificios, LoggerLog).

regla_bancarrota(Estado, Estado).
