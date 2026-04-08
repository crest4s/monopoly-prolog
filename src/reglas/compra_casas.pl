% Regla: Compra de casas y hoteles

% Encuentra la posicion del grupo con menos edificios actuales
propiedad_menos_edificada([P], _, P) :- !.
propiedad_menos_edificada([P|Ps], Edificios, Mejor) :-
    obtener_edificios_en(P, Edificios, NP),
    propiedad_menos_edificada(Ps, Edificios, MejorResto),
    obtener_edificios_en(MejorResto, Edificios, NResto),
    (NP =< NResto -> Mejor = P ; Mejor = MejorResto).

% Intenta comprar UN edificio en el primer monopolio elegible del jugador actual
regla_compra_casas(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, Pos, Dinero, Props)),
    % Buscar grupo de color donde el jugador tenga monopolio y pueda construir
    grupo_color(Color, Grupo),
    mi_todos_member(Grupo, Props),
    precio_casas(Color, Precio),
    Dinero >= Precio,
    % Propiedad menos edificada del grupo
    propiedad_menos_edificada(Grupo, Edificios, PosEdif),
    obtener_edificios_en(PosEdif, Edificios, NActual),
    NActual < 5,
    !,
    NNuevo is NActual + 1,
    actualizar_edificios(PosEdif, NNuevo, Edificios, NuevosEdificios),
    NuevoDinero is Dinero - Precio,
    JugadorAct = jugador(Nombre, Pos, NuevoDinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    EstadoSinLog = estado(NuevosJugadores, Tablero, Turno, Semilla, Carcel, NuevosEdificios, Logger),
    log_evento(EstadoSinLog, compra_casa, Nombre, PosEdif, Precio, NNuevo, Color, NuevoEstado),
    (NNuevo =:= 5 ->
        format("  ~w construye un HOTEL en pos ~w (~w) por ~w€~n",
               [Nombre, PosEdif, Color, Precio])
    ;
        format("  ~w construye casa #~w en pos ~w (~w) por ~w€~n",
               [Nombre, NNuevo, PosEdif, Color, Precio])
    ).

regla_compra_casas(Estado, Estado).
