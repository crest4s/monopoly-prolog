% =============================================================================
% estado.pl — Inicialización y verificación de estado
% =============================================================================
% Estado: estado(Jugadores, Tablero, Turno, Semilla)
% =============================================================================

inicializar_juego(Nombres, Semilla, Estado) :-
    tablero(T),
    crear_jugadores(Nombres, Jugadores),
    limpiar_carcel,
    Estado = estado(Jugadores, T, 0, Semilla).

crear_estado(Jugadores, Semilla, Estado) :-
    tablero(T),
    limpiar_carcel,
    Estado = estado(Jugadores, T, 0, Semilla).

verificar_fin(Jugadores) :-
    mi_longitud(Jugadores, 1).
