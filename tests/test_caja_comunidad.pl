% =============================================================================
% test_caja_comunidad.pl — Tests para cartas de Caja de Comunidad
% =============================================================================
:- use_module(library(plunit)).

:- begin_tests(caja_comunidad, [setup(limpiar_carcel)]).

test(caja_carta_1_cobra_200) :-
    aplicar_efecto_caja(1, 'Ana', 2, 1500, [],
                        'Ana', 2, NuevoDinero, []),
    NuevoDinero =:= 1700.

test(caja_carta_2_paga_100) :-
    aplicar_efecto_caja(2, 'Ana', 2, 1500, [],
                        'Ana', 2, NuevoDinero, []),
    NuevoDinero =:= 1400.

test(caja_carta_3_ir_salida) :-
    aplicar_efecto_caja(3, 'Ana', 17, 1500, [],
                        'Ana', NuevaPos, NuevoDinero, []),
    NuevaPos =:= 0,
    NuevoDinero =:= 1700.

test(caja_carta_4_cobra_100) :-
    aplicar_efecto_caja(4, 'Ana', 2, 1500, [],
                        'Ana', 2, NuevoDinero, []),
    NuevoDinero =:= 1600.

test(caja_carta_5_paga_50) :-
    aplicar_efecto_caja(5, 'Ana', 2, 1500, [],
                        'Ana', 2, NuevoDinero, []),
    NuevoDinero =:= 1450.

:- end_tests(caja_comunidad).
