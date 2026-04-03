% Impresión del estado del juego

imprimir_estado(estado(Jugadores, _, _, _, Carcel, _, _)) :-
    imprimir_linea,
    write('  ESTADO ACTUAL DEL JUEGO'), nl,
    imprimir_linea,
    imprimir_jugadores(Jugadores, Carcel),
    imprimir_linea.

imprimir_jugadores([], _).
imprimir_jugadores([J|R], Carcel) :-
    J = jugador(Nombre, Pos, Dinero, Props),
    mi_longitud(Props, NumProps),
    format("  ~w | Pos: ~w | Dinero: ~w$ | Propiedades: ~w",
           [Nombre, Pos, Dinero, NumProps]),
    (esta_en_carcel(Nombre, Carcel) ->
        turnos_en_carcel(Nombre, Carcel, T),
        format(" | EN CARCEL (~w turnos)", [T])
    ;
        true
    ),
    nl,
    imprimir_jugadores(R, Carcel).

imprimir_propiedades_jugador(jugador(Nombre, _, _, Props), Tablero) :-
    format("  Propiedades de ~w: ", [Nombre]),
    imprimir_nombres_propiedades(Props, Tablero),
    nl.

imprimir_nombres_propiedades([], _) :-
    write('(ninguna)').
imprimir_nombres_propiedades([P], Tablero) :-
    obtener_casilla(Tablero, P, Casilla),
    nombre_casilla(Casilla, Nombre),
    format("~w(~w)", [Nombre, P]).
imprimir_nombres_propiedades([P|R], Tablero) :-
    R \= [],
    obtener_casilla(Tablero, P, Casilla),
    nombre_casilla(Casilla, Nombre),
    format("~w(~w), ", [Nombre, P]),
    imprimir_nombres_propiedades(R, Tablero).

imprimir_todas_propiedades(estado(Jugadores, Tablero, _, _, _, _, _)) :-
    write('  PROPIEDADES DETALLADAS:'), nl,
    imprimir_props_todos(Jugadores, Tablero).

imprimir_props_todos([], _).
imprimir_props_todos([J|R], Tablero) :-
    imprimir_propiedades_jugador(J, Tablero),
    imprimir_props_todos(R, Tablero).
