% =============================================================================
% jugador.pl — Gestión de jugadores
% =============================================================================

obtener_jugador_actual(estado(Jugadores, _, Turno, _, _, _), Jugador) :-
    mi_obtener_elemento(Jugadores, Turno, Jugador).

actualizar_jugador_en_lista(Jugadores, Turno, JugadorNuevo, NuevaLista) :-
    mi_reemplazar_elemento(Jugadores, Turno, JugadorNuevo, NuevaLista).

siguiente_turno(estado(Jugadores, Tablero, Turno, Semilla, Carcel, Edificios),
                estado(Jugadores, Tablero, NuevoTurno, Semilla, Carcel, Edificios)) :-
    mi_longitud(Jugadores, N),
    N > 0,
    T1 is Turno + 1,
    mi_mod(T1, N, NuevoTurno).

crear_jugadores([], []).
crear_jugadores([Nombre|R], [jugador(Nombre, 0, 1500, [])|Jugadores]) :-
    crear_jugadores(R, Jugadores).

% --- Búsqueda de propietario ---
buscar_propietario([], _, ninguno).
buscar_propietario([J|_], Indice, J) :-
    J = jugador(_, _, _, Props),
    mi_member(Indice, Props), !.
buscar_propietario([_|Resto], Indice, Propietario) :-
    buscar_propietario(Resto, Indice, Propietario).

% --- Búsqueda de índice de jugador por nombre ---
buscar_indice_jugador(Jugadores, Nombre, Indice) :-
    buscar_indice_jugador_acc(Jugadores, Nombre, 0, Indice).

buscar_indice_jugador_acc([jugador(Nombre, _, _, _)|_], Nombre, Acc, Acc) :- !.
buscar_indice_jugador_acc([_|R], Nombre, Acc, Indice) :-
    Acc1 is Acc + 1,
    buscar_indice_jugador_acc(R, Nombre, Acc1, Indice).
