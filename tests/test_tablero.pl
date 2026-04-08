% Test: Tablero y consultas
:- use_module(library(plunit)).

:- begin_tests(tablero).

test(tablero_40_casillas) :-
    tablero(T),
    mi_longitud(T, 40).

test(casilla_salida) :-
    tablero(T),
    obtener_casilla(T, 0, casilla(0, salida)).

test(casilla_carcel) :-
    tablero(T),
    obtener_casilla(T, 10, casilla(10, carcel)).

test(casilla_ir_a_carcel) :-
    tablero(T),
    obtener_casilla(T, 30, casilla(30, ir_a_carcel)).

test(casilla_parking) :-
    tablero(T),
    obtener_casilla(T, 20, casilla(20, parking)).

test(nombre_salida) :-
    nombre_casilla(casilla(0, salida), 'Salida').

test(nombre_propiedad) :-
    nombre_casilla(casilla(1, propiedad('Test', marron, 60, 2)), 'Test').

test(es_comprable_propiedad) :-
    es_comprable(propiedad('X', marron, 60, 2)).

test(es_comprable_estacion) :-
    es_comprable(estacion('X', 200)).

test(es_comprable_servicio) :-
    es_comprable(servicio('X', 150)).

test(no_comprable_salida, [fail]) :-
    es_comprable(salida).

test(no_comprable_carcel, [fail]) :-
    es_comprable(carcel).

test(precio_propiedad) :-
    precio_casilla(propiedad('X', marron, 60, 2), 60).

test(precio_estacion) :-
    precio_casilla(estacion('X', 200), 200).

test(grupo_marron) :-
    grupo_color(marron, [1, 3]).

test(grupo_celeste) :-
    grupo_color(celeste, [6, 8, 9]).

test(estaciones) :-
    posiciones_estaciones([5, 15, 25, 35]).

test(servicios) :-
    posiciones_servicios([12, 28]).

test(color_propiedad) :-
    color_casilla(propiedad('X', rojo, 220, 18), rojo).

test(alquiler_base) :-
    alquiler_base_casilla(propiedad('X', marron, 60, 2), 2).

:- end_tests(tablero).
