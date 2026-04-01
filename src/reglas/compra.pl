% Regla 0: Compra de propiedades

regla_compra(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Propiedades),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, Tipo),
    es_comprable(Tipo),
    buscar_propietario(Jugadores, Posicion, Propietario),
    Propietario == ninguno,
    precio_casilla(Tipo, Precio),
    Dinero >= Precio,
    !,
    NuevoDinero is Dinero - Precio,
    mi_append(Propiedades, [Posicion], NuevasProps),
    JugadorActualizado = jugador(Nombre, Posicion, NuevoDinero, NuevasProps),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorActualizado, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    nombre_casilla(Casilla, NombreCasilla),
    log_evento(compra, Nombre, Posicion, Precio, NuevoDinero, ''),
    format("  >> ~w COMPRA ~w por ~w$ (Saldo: ~w$)~n",
           [Nombre, NombreCasilla, Precio, NuevoDinero]).

regla_compra(Estado, Estado).
