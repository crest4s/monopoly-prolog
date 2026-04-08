% =============================================================================
% caja_comunidad.pl — Cartas de Caja de Comunidad
% =============================================================================

aplicar_caja_comunidad(Estado, NuevoEstado) :-
       Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, caja_comunidad),
    !,
    prng_rango(Semilla, 1, 5, Carta, S1),
       EstadoLog = estado(Jugadores, Tablero, Turno, S1, Carcel, Edificios, Logger),
       log_evento(EstadoLog, caja, Nombre, Carta, '', '', '', EstadoLog2),
    aplicar_efecto_caja(Carta, Nombre, Posicion, Dinero, Props,
                        NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    JugadorAct = jugador(NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
       EstadoLog2 = estado(_, _, _, _, _, _, Logger2),
       NuevoEstado = estado(NuevosJugadores, Tablero, Turno, S1, Carcel, Edificios, Logger2).

aplicar_caja_comunidad(Estado, Estado).

% --- Efectos de cartas de Caja de Comunidad ---
aplicar_efecto_caja(1, Nombre, Pos, Dinero, Props,
                    Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 200,
    format("  [CAJA] Error del banco a favor de ~w: cobra 200€ (Saldo: ~w€)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_caja(2, Nombre, Pos, Dinero, Props,
                    Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero - 100,
    format("  [CAJA] ~w paga 100€ al hospital (Saldo: ~w€)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_caja(3, Nombre, _Pos, Dinero, Props,
                    Nombre, 0, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 200,
    format("  [CAJA] ~w avanza hasta Salida y cobra 200€ (Saldo: ~w€)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_caja(4, Nombre, Pos, Dinero, Props,
                    Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero + 100,
    format("  [CAJA] ~w cobra 100€ de la venta de acciones (Saldo: ~w€)~n",
           [Nombre, NuevoDinero]).

aplicar_efecto_caja(5, Nombre, Pos, Dinero, Props,
                    Nombre, Pos, NuevoDinero, Props) :-
    NuevoDinero is Dinero - 50,
    format("  [CAJA] ~w paga 50€ al dentista (Saldo: ~w€)~n",
           [Nombre, NuevoDinero]).
