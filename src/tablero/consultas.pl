% =============================================================================
% consultas.pl — Consultas y accesores del tablero
% =============================================================================

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
