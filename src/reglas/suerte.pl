% =============================================================================
% suerte.pl — Cartas de Suerte
% =============================================================================

aplicar_suerte(Estado, NuevoEstado) :-
       Estado = estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios, Logger),
    mi_obtener_elemento(Jugadores, Turno, Jugador),
    Jugador = jugador(Nombre, Posicion, Dinero, Props),
    obtener_casilla(Tablero, Posicion, Casilla),
    tipo_casilla(Casilla, suerte),
    !,
    prng_rango(Semilla, 1, 6, Carta, S1),
       EstadoConSemilla = estado(Jugadores, Tablero, Turno, S1, Carcel, Edificios, Logger),
       log_evento(EstadoConSemilla, suerte, Nombre, Carta, '', '', '', EstadoLog1),
    aplicar_efecto_suerte(Carta, Nombre, Posicion, Dinero, Props,
                          NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    % Efecto sobre cárcel (solo carta 6)
       efecto_suerte_carcel(Carta, NuevoNombre, Carcel, NuevaCarcel, EstadoLog1, EstadoLog2),
    JugadorAct = jugador(NuevoNombre, NuevaPos, NuevoDinero, NuevasProps),
    mi_reemplazar_elemento(Jugadores, Turno, JugadorAct, NuevosJugadores),
       EstadoLog2 = estado(_, _, _, _, _, _, Logger2),
       NuevoEstado = estado(NuevosJugadores, Tablero, Turno, S1, NuevaCarcel, Edificios, Logger2).

aplicar_suerte(Estado, Estado).

% --- Efecto sobre la lista de cárcel (solo carta 6) ---
efecto_suerte_carcel(6, Nombre, Carcel0, Carcel1, EstadoIn, EstadoOut) :-
    !,
    encarcelar_en_lista(Nombre, Carcel0, Carcel1),
       log_evento(EstadoIn, carcel_entrada, Nombre, suerte, '', '', '', EstadoOut).
efecto_suerte_carcel(_, _, Carcel, Carcel, Estado, Estado).

% Wrapper de compatibilidad para tests unitarios que no pasan Estado.
efecto_suerte_carcel(Carta, Nombre, Carcel0, Carcel1) :-
       EstadoDummy = estado([], [], 0, 0, Carcel0, [], logger_inactivo),
       efecto_suerte_carcel(Carta, Nombre, Carcel0, Carcel1, EstadoDummy, _).

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
    Suma5 is Pos + 3,
    mi_mod(Suma5, 40, NuevaPos),
    format("  [SUERTE] ~w avanza 3 casillas a posicion ~w~n",
           [Nombre, NuevaPos]).

aplicar_efecto_suerte(6, Nombre, _Pos, Dinero, Props,
                      Nombre, 10, Dinero, Props) :-
    format("  [SUERTE] ~w va directamente a la Carcel~n", [Nombre]).
