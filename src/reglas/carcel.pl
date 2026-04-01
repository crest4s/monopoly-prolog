% =============================================================================
% carcel.pl — Mecánicas de cárcel (estado funcional, sin assert/retract)
% =============================================================================
% La cárcel se representa como una lista de términos preso(Nombre, Turnos)
% incluida en la estructura estado/6. No hay predicados dinámicos globales.
% =============================================================================

% --- Consulta ---

esta_en_carcel(Nombre, Carcel) :-
    mi_member(preso(Nombre, T), Carcel),
    T > 0.

turnos_en_carcel(Nombre, Carcel, T) :-
    mi_member(preso(Nombre, T), Carcel).

% --- Modificación de la lista de cárcel ---

encarcelar_en_lista(Nombre, Carcel0, Carcel1) :-
    mi_eliminar_presos(Nombre, Carcel0, Temp),
    Carcel1 = [preso(Nombre, 3)|Temp].

liberar_de_lista(Nombre, Carcel0, Carcel1) :-
    mi_eliminar_presos(Nombre, Carcel0, Carcel1).

actualizar_turnos_carcel(_, _, [], []).
actualizar_turnos_carcel(Nombre, N, [preso(Nombre, _)|R], [preso(Nombre, N)|R]) :- !.
actualizar_turnos_carcel(Nombre, N, [X|R], [X|R2]) :-
    actualizar_turnos_carcel(Nombre, N, R, R2).

mi_eliminar_presos(_, [], []).
mi_eliminar_presos(Nombre, [preso(Nombre, _)|R], R2) :- !,
    mi_eliminar_presos(Nombre, R, R2).
mi_eliminar_presos(Nombre, [X|R], [X|R2]) :-
    mi_eliminar_presos(Nombre, R, R2).

% --- Turno en cárcel: saca dobles → se libera y puede mover ---
turno_carcel(Estado, _D1, _D2, true, NuevoEstado, true) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, _, _, _)),
    esta_en_carcel(Nombre, Carcel),
    !,
    liberar_de_lista(Nombre, Carcel, NuevaCarcel),
    log_evento(carcel_salida, Nombre, dobles, '', '', ''),
    format("  ~w saca DOBLES y sale de la Carcel!~n", [Nombre]),
    NuevoEstado = estado(Jugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios).

% --- Turno en cárcel: sin dobles ---
turno_carcel(Estado, _D1, _D2, false, NuevoEstado, PuedeMover) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, jugador(Nombre, Pos, Dinero, Props)),
    esta_en_carcel(Nombre, Carcel),
    !,
    turnos_en_carcel(Nombre, Carcel, TurnosRestantes),
    NuevosTurnos is TurnosRestantes - 1,
    (NuevosTurnos =:= 0 ->
        liberar_de_lista(Nombre, Carcel, NuevaCarcel),
        NuevoDinero is Dinero - 50,
        log_evento(carcel_salida, Nombre, pago, NuevoDinero, '', ''),
        format("  ~w no saca dobles. Paga 50$ y sale de la Carcel (Saldo: ~w$)~n",
               [Nombre, NuevoDinero]),
        JugadorAct = jugador(Nombre, Pos, NuevoDinero, Props),
        mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
        NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios),
        PuedeMover = true
    ;
        actualizar_turnos_carcel(Nombre, NuevosTurnos, Carcel, NuevaCarcel),
        format("  ~w sigue en la Carcel (~w turnos restantes)~n",
               [Nombre, NuevosTurnos]),
        NuevoEstado = estado(Jugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios),
        PuedeMover = false
    ).

% Si no está en la cárcel, no aplica
turno_carcel(Estado, _, _, _, Estado, true).

% --- Ir a la Cárcel (casilla 30) ---
aplicar_ir_a_carcel(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, ir_a_carcel),
    !,
    encarcelar_en_lista(Nombre, Carcel, NuevaCarcel),
    log_evento(carcel_entrada, Nombre, casilla_30, '', '', ''),
    JugadorAct = jugador(Nombre, 10, Dinero, Props),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, Semilla, NuevaCarcel, Edificios),
    format("  >> ~w va DIRECTAMENTE A LA CARCEL~n", [Nombre]).

aplicar_ir_a_carcel(Estado, Estado).
