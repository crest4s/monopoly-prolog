:- use_module(library(plunit)).

:- begin_tests(paso_salida).

test(paso_salida_cobra) :-
    comprobar_paso_salida(35, 3, 1500, NuevoDinero),
    NuevoDinero =:= 1700.

test(no_paso_salida_sin_vuelta) :-
    comprobar_paso_salida(5, 10, 1500, NuevoDinero),
    NuevoDinero =:= 1500.

test(no_paso_salida_ir_a_carcel) :-
    comprobar_paso_salida(35, 10, 1500, NuevoDinero),
    NuevoDinero =:= 1500.

test(paso_salida_pos_cero) :-
    comprobar_paso_salida(38, 0, 1000, NuevoDinero),
    NuevoDinero =:= 1200.

:- end_tests(paso_salida).
