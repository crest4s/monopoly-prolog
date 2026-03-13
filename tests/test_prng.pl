:- use_module(library(plunit)).

:- begin_tests(prng).

% Determinismo: misma semilla → mismo resultado
test(prng_determinista) :-
    prng_siguiente(42, S1),
    prng_siguiente(42, S2),
    S1 =:= S2.

test(prng_diferente_semilla) :-
    prng_siguiente(42, S1),
    prng_siguiente(100, S2),
    S1 =\= S2.

% Dado: rango 1-6
test(dado_rango) :-
    tirar_dado(42, V, _),
    V >= 1, V =< 6.

test(dado_rango_otra_semilla) :-
    tirar_dado(9999, V, _),
    V >= 1, V =< 6.

% Dados: dos dados independientes
test(dados_rango) :-
    tirar_dados(42, D1, D2, _, _),
    D1 >= 1, D1 =< 6,
    D2 >= 1, D2 =< 6.

% Dobles
test(dados_dobles_true) :-
    tirar_dados(42, D1, D2, SonDobles, _),
    (D1 =:= D2 -> SonDobles = true ; SonDobles = false).

% prng_rango
test(rango_inclusivo) :-
    prng_rango(42, 1, 6, V, _),
    V >= 1, V =< 6.

test(rango_pequeño) :-
    prng_rango(42, 1, 1, V, _),
    V =:= 1.

% Cadena de semillas
test(cadena_semillas) :-
    tirar_dado(42, _, S1),
    tirar_dado(S1, _, S2),
    S1 =\= S2.

:- end_tests(prng).
