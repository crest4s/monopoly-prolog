% Casilla de impuesto

aplicar_impuesto(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, impuesto(NombreImp, Cantidad)),
    !,
    NuevoDinero is Dinero - Cantidad,
    JugadorAct = jugador(Nombre, Posicion, NuevoDinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    log_evento(impuesto, Nombre, Posicion, Cantidad, NuevoDinero, ''),
    format("  >> ~w paga ~w$ por ~w (Saldo: ~w$)~n",
           [Nombre, Cantidad, NombreImp, NuevoDinero]).

aplicar_impuesto(Estado, Estado).
