% Regla: Paso por la casilla de Salida

comprobar_paso_salida(PosAnterior, PosNueva, Dinero, NuevoDinero) :-
    PosNueva < PosAnterior,
    !,
    NuevoDinero is Dinero + 200,
    format("  +++ Pasa por SALIDA y cobra 200€~n", []).

comprobar_paso_salida(_, _, Dinero, Dinero).
