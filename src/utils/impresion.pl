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
