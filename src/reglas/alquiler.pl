% Regla 1: cobro de alquiler

% Propiedad normal
calcular_alquiler(propiedad(_, Color, _, AlquilerBase), Dueño, _, Alquiler) :-
    (tiene_monopolio(Dueño, Color) ->
        Alquiler is AlquilerBase * 2,
        format("  ** MONOPOLIO ~w detectado! Alquiler DOBLE~n", [Color])
    ;
        Alquiler is AlquilerBase
    ).

% Estación: 25 por cada estación del dueño
calcular_alquiler(estacion(_, _), Dueño, _, Alquiler) :-
    Dueño = jugador(_, _, _, Props),
    posiciones_estaciones(Estaciones),
    mi_contar_en(Props, Estaciones, NumEstaciones),
    Alquiler is 25 * NumEstaciones.

% Servicio: SumaDados * multiplicador
calcular_alquiler(servicio(_, _), Dueño, SumaDados, Alquiler) :-
    Dueño = jugador(_, _, _, Props),
    posiciones_servicios(Servicios),
    mi_contar_en(Props, Servicios, NumServicios),
    (NumServicios =:= 2 ->
        Multiplicador = 10
    ;
        Multiplicador = 4
    ),
    Alquiler is SumaDados * Multiplicador.

regla_alquiler(Estado, SumaDados, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(NombreJ, Posicion, DineroJ, PropsJ),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, Tipo),
    es_comprable(Tipo),
    buscar_propietario(Jugadores, Posicion, Dueño),
    Dueño \== ninguno,
    Dueño = jugador(NombreD, _, _, _),
    NombreJ \== NombreD,
    !,
    calcular_alquiler(Tipo, Dueño, SumaDados, Alquiler),
    NuevoDineroJ is DineroJ - Alquiler,
    Dueño = jugador(NombreD, PosD, DineroD, PropsD),
    NuevoDineroD is DineroD + Alquiler,
    JugadorAct = jugador(NombreJ, Posicion, NuevoDineroJ, PropsJ),
    DueñoAct = jugador(NombreD, PosD, NuevoDineroD, PropsD),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, Jugadores1),
    buscar_indice_jugador(Jugadores1, NombreD, IndiceDueño),
    mi_reemplazar_elemento(Jugadores1, IndiceDueño, DueñoAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla),
    nombre_casilla(Casilla, NombreCasilla),
    log_evento(alquiler, NombreJ, Posicion, Alquiler, NombreD, NuevoDineroJ),
    format("  >> ~w paga ~w$ de alquiler a ~w por ~w~n",
           [NombreJ, Alquiler, NombreD, NombreCasilla]).

regla_alquiler(Estado, _, Estado).
