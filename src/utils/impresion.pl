% Utilidades básicas de impresión

imprimir_lista([]).
imprimir_lista([X]) :-
    write(X).
imprimir_lista([X|R]) :-
    R \= [],
    write(X), write(', '),
    imprimir_lista(R).

imprimir_linea :-
    write('------------------------------------------------------------'), nl.

mi_mod_manual(A, B, A) :-
    A >= 0, A < B, !.
mi_mod_manual(A, B, R) :-
    A >= B,
    A1 is A - B,
    mi_mod_manual(A1, B, R).
mi_mod_manual(A, B, R) :-
    A < 0,
    A1 is A + B,
    mi_mod_manual(A1, B, R).
