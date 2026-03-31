% Regla 1: cobro de alquiler

% Propiedad normal: alquiler depende de edificios presentes en la casilla
calcular_alquiler(propiedad(_, Color, _, AlquilerBase), Dueño, _, Pos, Edificios, Alquiler) :-
    obtener_edificios_en(Pos, Edificios, N),
    (N > 0 ->
        multiplicador_edificio(N, Mult),
        Alquiler is AlquilerBase * Mult,
        (N =:= 5 ->
            format("  ** HOTEL en pos ~w! Alquiler x~w~n", [Pos, Mult])
        ;
            format("  ** ~w casa(s) en pos ~w! Alquiler x~w~n", [N, Pos, Mult])
        )
    ; tiene_monopolio(Dueño, Color) ->
        Alquiler is AlquilerBase * 2,
        format("  ** MONOPOLIO ~w detectado! Alquiler DOBLE~n", [Color])
    ;
        Alquiler is AlquilerBase
    ).

% Multiplicadores de alquiler segun numero de edificios
multiplicador_edificio(1, 5).
multiplicador_edificio(2, 15).
multiplicador_edificio(3, 45).
multiplicador_edificio(4, 80).
multiplicador_edificio(5, 125).  % hotel

% Estación: 25 por cada estación del dueño
calcular_alquiler(estacion(_, _), Dueño, _, _, _, Alquiler) :-
    Dueño = jugador(_, _, _, Props),
    posiciones_estaciones(Estaciones),
    mi_contar_en(Props, Estaciones, NumEstaciones),
    Alquiler is 25 * NumEstaciones.

% Servicio: SumaDados * multiplicador
calcular_alquiler(servicio(_, _), Dueño, SumaDados, _, _, Alquiler) :-
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
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
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
    calcular_alquiler(Tipo, Dueño, SumaDados, Posicion, Edificios, Alquiler),
    NuevoDineroJ is DineroJ - Alquiler,
    Dueño = jugador(NombreD, PosD, DineroD, PropsD),
    NuevoDineroD is DineroD + Alquiler,
    JugadorAct = jugador(NombreJ, Posicion, NuevoDineroJ, PropsJ),
    DueñoAct = jugador(NombreD, PosD, NuevoDineroD, PropsD),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, Jugadores1),
    buscar_indice_jugador(Jugadores1, NombreD, IndiceDueño),
    mi_reemplazar_elemento(Jugadores1, IndiceDueño, DueñoAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    nombre_casilla(Casilla, NombreCasilla),
    log_evento(alquiler, NombreJ, Posicion, Alquiler, NombreD, NuevoDineroJ),
    format("  >> ~w paga ~w$ de alquiler a ~w por ~w~n",
           [NombreJ, Alquiler, NombreD, NombreCasilla]).

regla_alquiler(Estado, _, Estado).
