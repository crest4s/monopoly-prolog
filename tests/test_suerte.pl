% =============================================================================
% test_suerte.pl — Tests para cartas de Suerte
% =============================================================================
:- use_module(library(plunit)).

:- begin_tests(suerte).

test(suerte_carta_1_gana_100) :-
    aplicar_efecto_suerte(1, 'Ana', 7, 1500, [],
                          'Ana', 7, NuevoDinero, []),
    NuevoDinero =:= 1600.

test(suerte_carta_2_paga_50) :-
    aplicar_efecto_suerte(2, 'Ana', 7, 1500, [],
                          'Ana', 7, NuevoDinero, []),
    NuevoDinero =:= 1450.

test(suerte_carta_3_ir_salida) :-
    aplicar_efecto_suerte(3, 'Ana', 22, 1500, [],
                          'Ana', NuevaPos, NuevoDinero, []),
    NuevaPos =:= 0,
    NuevoDinero =:= 1700.

test(suerte_carta_4_dividendo) :-
    aplicar_efecto_suerte(4, 'Ana', 7, 1500, [],
                          'Ana', 7, NuevoDinero, []),
    NuevoDinero =:= 1550.

test(suerte_carta_5_avanza_3) :-
    aplicar_efecto_suerte(5, 'Ana', 7, 1500, [],
                          'Ana', NuevaPos, 1500, []),
    NuevaPos =:= 10.

test(suerte_carta_5_wrap) :-
    aplicar_efecto_suerte(5, 'Ana', 38, 1500, [],
                          'Ana', NuevaPos, 1500, []),
    NuevaPos =:= 1.

test(suerte_carta_6_carcel) :-
    aplicar_efecto_suerte(6, 'Ana', 7, 1500, [],
                          'Ana', NuevaPos, 1500, []),
    NuevaPos =:= 10,
    efecto_suerte_carcel(6, 'Ana', [], Carcel),
    esta_en_carcel('Ana', Carcel).

:- end_tests(suerte).
