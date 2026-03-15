% Regla 2 - monopolio
tiene_monopolio(jugador(_, _, _, Props), Color) :-
    grupo_color(Color, Posiciones),
    mi_todos_member(Posiciones, Props).
