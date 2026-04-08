% Test: Detección de monopolio
:- use_module(library(plunit)).

:- begin_tests(monopolio).

test(tiene_monopolio_marron) :-
    tiene_monopolio(jugador('Ana', 0, 1500, [1, 3]), marron).

test(no_tiene_monopolio_parcial, [fail]) :-
    tiene_monopolio(jugador('Ana', 0, 1500, [1]), marron).

test(tiene_monopolio_celeste) :-
    tiene_monopolio(jugador('Ana', 0, 1500, [6, 8, 9, 1]), celeste).

test(tiene_monopolio_azul) :-
    tiene_monopolio(jugador('Ana', 0, 1500, [37, 39]), azul).

test(no_monopolio_vacio, [fail]) :-
    tiene_monopolio(jugador('Ana', 0, 1500, []), marron).

test(monopolio_con_extras) :-
    tiene_monopolio(jugador('Ana', 0, 1500, [1, 3, 5, 6, 8, 9]), marron).

:- end_tests(monopolio).
