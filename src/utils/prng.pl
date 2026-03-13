% Generador de números pseudoaleatorios
% Fórmula: S1 = (1103515245 * S0 + 12345) mod 2^31

prng_siguiente(S0, S1) :-
    S1 is (1103515245 * S0 + 12345) mod 2147483648.

tirar_dado(S0, Valor, S1) :-
    prng_siguiente(S0, S1),
    BitsAltos is S1 // 65536,
    Valor is (BitsAltos mod 6) + 1.

tirar_dados(S0, D1, D2, SonDobles, S2) :-
    tirar_dado(S0, D1, S1),
    tirar_dado(S1, D2, S2),
    (D1 =:= D2 -> SonDobles = true ; SonDobles = false).

prng_rango(S0, Min, Max, Valor, S1) :-
    prng_siguiente(S0, S1),
    Rango is Max - Min + 1,
    BitsAltos is S1 // 65536,
    Valor is (BitsAltos mod Rango) + Min.
