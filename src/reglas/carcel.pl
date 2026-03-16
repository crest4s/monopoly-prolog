:- dynamic en_carcel/2.
% en_carcel(NombreJugador, TurnosRestantes)

encarcelar(Nombre) :-
    retractall(en_carcel(Nombre, _)),
    assertz(en_carcel(Nombre, 3)),
    log_evento(carcel_entrada, Nombre, '', '', '', '').

liberar(Nombre) :-
    retractall(en_carcel(Nombre, _)).

esta_en_carcel(Nombre) :-
    en_carcel(Nombre, T),
    T > 0.

limpiar_carcel :-
    retractall(en_carcel(_, _)).

% --- Turno de cárcel: saca dobles → se libera ---
turno_carcel(Estado, _D1, _D2, true, NuevoEstado, true) :-
    Estado = estado(Jugadores, _Tablero, Turno, _Semilla),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, _, _, _)),
    esta_en_carcel(Nombre),
    !,
    liberar(Nombre),
    log_evento(carcel_salida, Nombre, dobles, '', '', ''),
    format("  ~w saca DOBLES y sale de la Carcel!~n", [Nombre]),
    NuevoEstado = Estado.

% --- Turno de cárcel: no saca dobles ---
turno_carcel(Estado, _D1, _D2, false, NuevoEstado, PuedeMover) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, Pos, Dinero, Props)),
    esta_en_carcel(Nombre),
    !,
    en_carcel(Nombre, TurnosRestantes),
    NuevosTurnos is TurnosRestantes - 1,
    (NuevosTurnos =:= 0 ->
        liberar(Nombre),
        NuevoDinero is Dinero - 50,
        log_evento(carcel_salida, Nombre, pago, NuevoDinero, '', ''),
        format("  ~w no saca dobles. Paga 50$ y sale de la Carcel (Saldo: ~w$)~n",
               [Nombre, NuevoDinero]),
        JugadorAct = jugador(Nombre, Pos, NuevoDinero, Props),
        mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
        NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla),
        PuedeMover = true
    ;
        retractall(en_carcel(Nombre, _)),
        assertz(en_carcel(Nombre, NuevosTurnos)),
        format("  ~w sigue en la Carcel (~w turnos restantes)~n",
               [Nombre, NuevosTurnos]),
        NuevoEstado = Estado,
        PuedeMover = false
    ).

% Si no está en la cárcel, no aplica
turno_carcel(Estado, _, _, _, Estado, true).

% --- Ir a la Cárcel (casilla 30) ---
aplicar_ir_a_carcel(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, ir_a_carcel),
    !,
    encarcelar(Nombre),
    JugadorAct = jugador(Nombre, 10, Dinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla),
    format("  >> ~w va DIRECTAMENTE A LA CARCEL~n", [Nombre]).

aplicar_ir_a_carcel(Estado, Estado).
