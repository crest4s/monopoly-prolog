% Core: Inicialización y verificación de estado

inicializar_juego(Nombres, Semilla, Estado) :-
    tablero(T),
    crear_jugadores(Nombres, Jugadores),
    Estado = estado(Jugadores, T, 0, Semilla, [], [], logger_inactivo).

crear_estado(Jugadores, Semilla, Estado) :-
    tablero(T),
    Estado = estado(Jugadores, T, 0, Semilla, [], [], logger_inactivo).

verificar_fin(Jugadores) :-
    mi_longitud(Jugadores, 1).
