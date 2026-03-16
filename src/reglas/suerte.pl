% =============================================================================
% suerte.pl — Cartas de Suerte
% =============================================================================

aplicar_suerte(Estado, NuevoEstado) :-
    Estado = estado(Jugadores, Tablero, Turno, Semilla),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, suerte),
    !,
    prng_rango(Semilla, 1, 6, Carta, S1),
    log_evento(suerte, Nombre, Carta, '', '', ''),
    aplicar_efecto_suerte(Carta, Nombre, Posicion, Dinero, Props,
                          NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    JugadorAct = jugador(NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
    NuevoEstado = estado(NuevosJugadores, Tablero, Turno, S1).

aplicar_suerte(Estado, Estado).

% --- Efectos de cartas de Suerte ---
aplicar_efecto_suerte(1, Nombre, Pos, Dinero, Props,
                      Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 100,
    format("  [SUERTE] ~w recibe 100$ del banco (Saldo: ~w$)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_suerte(2, Nombre, Pos, Dinero, Props,
                      Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero - 50,
    format("  [SUERTE] ~w paga 50$ de multa (Saldo: ~w$)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_suerte(3, Nombre, _Pos, Dinero, Props,
                      Nombre, 0, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 200,
    format("  [SUERTE] ~w avanza hasta Salida y cobra 200$ (Saldo: ~w$)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_suerte(4, Nombre, Pos, Dinero, Props,
                      Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 50,
    format("  [SUERTE] Dividendo de 50$ para ~w (Saldo: ~w$)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_suerte(5, Nombre, Pos, Dinero, Props,
                      Nombre, NuevaPos, Dinero, Props) :-
    NuevaPos is (Pos + 3) mod 40,
    format("  [SUERTE] ~w avanza 3 casillas a posicion ~w~n",
           [Nombre, NuevaPos]).

aplicar_efecto_suerte(6, Nombre, _Pos, Dinero, Props,
                      Nombre, 10, Dinero, Props) :-
    encarcelar(Nombre),
    format("  [SUERTE] ~w va directamente a la Carcel~n", [Nombre]).
