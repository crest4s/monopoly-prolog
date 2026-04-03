% Dispatcher de evaluación de casillas

evaluar_casilla(Estado, SumaDados, EstadoFinal) :-
    Estado = estado(Jugadores, Tablero, Turno, _, _, _, _),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(_, Posicion, _, _),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, Tipo),
    evaluar_tipo(Tipo, Estado, SumaDados, Estado1),
    regla_compra_casas(Estado1, EstadoFinal).

% Propiedad, estación o servicio
evaluar_tipo(Tipo, Estado, SumaDados, EstadoFinal) :-
    es_comprable(Tipo),
    !,
    regla_alquiler(Estado, SumaDados, Estado1),
    (Estado1 == Estado ->
        regla_compra(Estado1, EstadoFinal)
    ;
        EstadoFinal = Estado1
    ).

% Impuesto
evaluar_tipo(impuesto(_, _), Estado, _, EstadoFinal) :-
    !,
    aplicar_impuesto(Estado, EstadoFinal).

% Ir a la cárcel
evaluar_tipo(ir_a_carcel, Estado, _, EstadoFinal) :-
    !,
    aplicar_ir_a_carcel(Estado, EstadoFinal).

% Suerte
evaluar_tipo(suerte, Estado, _, EstadoFinal) :-
    !,
    aplicar_suerte(Estado, EstadoFinal).

% Caja de comunidad
evaluar_tipo(caja_comunidad, Estado, _, EstadoFinal) :-
    !,
    aplicar_caja_comunidad(Estado, EstadoFinal).

% Casillas sin efecto (Salida, Cárcel visita, Parking)
evaluar_tipo(_, Estado, _, Estado).
