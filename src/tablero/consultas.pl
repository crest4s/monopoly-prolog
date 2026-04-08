% Tablero: Consultas y accesores del tablero

obtener_casilla(Tablero, Pos, Casilla) :-
    mi_obtener_elemento(Tablero, Pos, Casilla).

tipo_casilla(casilla(_, Tipo), Tipo).

nombre_casilla(casilla(_, salida), 'Salida').
nombre_casilla(casilla(_, propiedad(Nombre, _, _, _)), Nombre).
nombre_casilla(casilla(_, estacion(Nombre, _)), Nombre).
nombre_casilla(casilla(_, servicio(Nombre, _)), Nombre).
nombre_casilla(casilla(_, impuesto(Nombre, _)), Nombre).
nombre_casilla(casilla(_, suerte), 'Suerte').
nombre_casilla(casilla(_, caja_comunidad), 'Caja de Comunidad').
nombre_casilla(casilla(_, carcel), 'Carcel (Visita)').
nombre_casilla(casilla(_, parking), 'Parking Gratuito').
nombre_casilla(casilla(_, ir_a_carcel), 'Ve a la Carcel').

es_comprable(propiedad(_, _, _, _)).
es_comprable(estacion(_, _)).
es_comprable(servicio(_, _)).

precio_casilla(propiedad(_, _, Precio, _), Precio).
precio_casilla(estacion(_, Precio), Precio).
precio_casilla(servicio(_, Precio), Precio).

color_casilla(propiedad(_, Color, _, _), Color).

alquiler_base_casilla(propiedad(_, _, _, Alquiler), Alquiler).

% Obtener numero de edificios en una posicion (0 si no hay ninguno)
obtener_edificios_en(_, [], 0).
obtener_edificios_en(Pos, [edificio(Pos, N)|_], N) :- !.
obtener_edificios_en(Pos, [_|R], N) :-
    obtener_edificios_en(Pos, R, N).

% Actualizar o insertar edificio en la lista
actualizar_edificios(Pos, N, [], [edificio(Pos, N)]).
actualizar_edificios(Pos, N, [edificio(Pos, _)|R], [edificio(Pos, N)|R]) :- !.
actualizar_edificios(Pos, N, [X|R], [X|R2]) :-
    actualizar_edificios(Pos, N, R, R2).

% Eliminar edificio de una posicion concreta
mi_eliminar_edificio(_, [], []).
mi_eliminar_edificio(Pos, [edificio(Pos, _)|R], R) :- !.
mi_eliminar_edificio(Pos, [X|R], [X|R2]) :-
    mi_eliminar_edificio(Pos, R, R2).

% Eliminar todos los edificios de una lista de posiciones (al quebrar)
limpiar_edificios_de([], Edificios, Edificios).
limpiar_edificios_de([P|Ps], Edificios0, Edificios2) :-
    mi_eliminar_edificio(P, Edificios0, Edificios1),
    limpiar_edificios_de(Ps, Edificios1, Edificios2).
