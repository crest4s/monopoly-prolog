% Operaciones auxiliares de listas

mi_append([], L, L).
mi_append([X|R1], L2, [X|R3]) :-
    mi_append(R1, L2, R3).

mi_member(X, [X|_]).
mi_member(X, [_|R]) :-
    mi_member(X, R).

mi_longitud([], 0).
mi_longitud([_|R], N) :-
    mi_longitud(R, N1),
    N is N1 + 1.

mi_obtener_elemento([X|_], 0, X).
mi_obtener_elemento([_|R], I, X) :-
    I > 0,
    I1 is I - 1,
    mi_obtener_elemento(R, I1, X).

mi_reemplazar_elemento([_|R], 0, X, [X|R]).
mi_reemplazar_elemento([Y|R], I, X, [Y|R2]) :-
    I > 0,
    I1 is I - 1,
    mi_reemplazar_elemento(R, I1, X, R2).

mi_eliminar_elemento([], _, []).
mi_eliminar_elemento([X|R], X, R) :- !.
mi_eliminar_elemento([Y|R], X, [Y|R2]) :-
    mi_eliminar_elemento(R, X, R2).

mi_invertir(L, R) :-
    mi_invertir_acc(L, [], R).

mi_invertir_acc([], Acc, Acc).
mi_invertir_acc([X|R], Acc, Res) :-
    mi_invertir_acc(R, [X|Acc], Res).

mi_ultimo([X], X).
mi_ultimo([_|R], X) :-
    mi_ultimo(R, X).

mi_suma_lista([], 0).
mi_suma_lista([X|R], S) :-
    mi_suma_lista(R, S1),
    S is S1 + X.

mi_buscar_indice(L, X, I) :-
    mi_buscar_indice_acc(L, X, 0, I).

mi_buscar_indice_acc([X|_], X, Acc, Acc).
mi_buscar_indice_acc([_|R], X, Acc, I) :-
    Acc1 is Acc + 1,
    mi_buscar_indice_acc(R, X, Acc1, I).

mi_todos_member([], _).
mi_todos_member([X|R], L) :-
    mi_member(X, L),
    mi_todos_member(R, L).

mi_contar([], _, 0).
mi_contar([X|R], X, N) :-
    !,
    mi_contar(R, X, N1),
    N is N1 + 1.
mi_contar([_|R], X, N) :-
    mi_contar(R, X, N).

mi_contar_en(_, [], 0).
mi_contar_en(Lista, [X|R], N) :-
    (mi_member(X, Lista) ->
        mi_contar_en(Lista, R, N1),
        N is N1 + 1
    ;
        mi_contar_en(Lista, R, N)
    ).

mi_eliminar_todos([], _, []).
mi_eliminar_todos([X|R], X, R2) :-
    !,
    mi_eliminar_todos(R, X, R2).
mi_eliminar_todos([Y|R], X, [Y|R2]) :-
    mi_eliminar_todos(R, X, R2).

mi_aplanar_propiedades([], []).
mi_aplanar_propiedades([jugador(_, _, _, Props)|R], Todas) :-
    mi_aplanar_propiedades(R, RestProps),
    mi_append(Props, RestProps, Todas).

mi_max(A, B, A) :- A >= B, !.
mi_max(_, B, B).

mi_tomar(0, _, []) :- !.
mi_tomar(_, [], []) :- !.
mi_tomar(N, [X|R], [X|R2]) :-
    N > 0,
    N1 is N - 1,
    mi_tomar(N1, R, R2).

% Modulo manual sin operador nativo (para valores pequeños: posiciones y turnos)
mi_mod(A, B, A) :- A >= 0, A < B, !.
mi_mod(A, B, R) :- A >= B, !, A1 is A - B, mi_mod(A1, B, R).
mi_mod(A, B, R) :- A < 0,  !, A1 is A + B, mi_mod(A1, B, R).
