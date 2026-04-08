% Test: Operaciones de listas
:- use_module(library(plunit)).

:- begin_tests(listas).

% mi_append
test(append_vacia_izq) :- mi_append([], [1,2], [1,2]).
test(append_vacia_der) :- mi_append([1,2], [], [1,2]).
test(append_dos_listas) :- mi_append([1,2], [3,4], [1,2,3,4]).
test(append_unitarias) :- mi_append([a], [b], [a,b]).

% mi_member
test(member_primero) :- mi_member(1, [1,2,3]).
test(member_ultimo) :- mi_member(3, [1,2,3]).
test(member_no_existe, [fail]) :- mi_member(4, [1,2,3]).
test(member_vacia, [fail]) :- mi_member(1, []).

% mi_longitud 
test(longitud_vacia) :- mi_longitud([], 0).
test(longitud_uno) :- mi_longitud([a], 1).
test(longitud_tres) :- mi_longitud([a,b,c], 3).

% mi_obtener_elemento
test(obtener_primero) :- mi_obtener_elemento([a,b,c], 0, a).
test(obtener_medio) :- mi_obtener_elemento([a,b,c], 1, b).
test(obtener_ultimo) :- mi_obtener_elemento([a,b,c], 2, c).

% mi_reemplazar_elemento
test(reemplazar_primero) :- mi_reemplazar_elemento([a,b,c], 0, x, [x,b,c]).
test(reemplazar_medio) :- mi_reemplazar_elemento([a,b,c], 1, x, [a,x,c]).
test(reemplazar_ultimo) :- mi_reemplazar_elemento([a,b,c], 2, x, [a,b,x]).

% mi_eliminar_elemento
test(eliminar_existe) :- mi_eliminar_elemento([a,b,c], b, [a,c]).
test(eliminar_primero) :- mi_eliminar_elemento([a,b,c], a, [b,c]).
test(eliminar_no_existe) :- mi_eliminar_elemento([a,b], x, [a,b]).

% mi_invertir
test(invertir_vacia) :- mi_invertir([], []).
test(invertir_uno) :- mi_invertir([a], [a]).
test(invertir_tres) :- mi_invertir([1,2,3], [3,2,1]).

% mi_ultimo
test(ultimo_uno) :- mi_ultimo([a], a).
test(ultimo_tres) :- mi_ultimo([1,2,3], 3).

% mi_suma_lista
test(suma_vacia) :- mi_suma_lista([], 0).
test(suma_numeros) :- mi_suma_lista([1,2,3,4], 10).

% mi_buscar_indice
test(buscar_primero) :- mi_buscar_indice([a,b,c], a, 0).
test(buscar_ultimo) :- mi_buscar_indice([a,b,c], c, 2).

% mi_todos_member
test(todos_presentes) :- mi_todos_member([1,3], [1,2,3,4]).
test(todos_falta_uno, [fail]) :- mi_todos_member([1,5], [1,2,3]).
test(todos_vacio) :- mi_todos_member([], [1,2]).

% mi_contar
test(contar_cero) :- mi_contar([a,b,c], x, 0).
test(contar_uno) :- mi_contar([a,b,c], b, 1).
test(contar_varios) :- mi_contar([a,b,a,a], a, 3).

% mi_contar_en
test(contar_en_ninguno) :- mi_contar_en([1,2], [5,6], 0).
test(contar_en_algunos) :- mi_contar_en([1,2,3], [2,3,4], 2).
test(contar_en_todos) :- mi_contar_en([1,2,3], [1,2,3], 3).

% mi_eliminar_todos
test(eliminar_todos_uno) :- mi_eliminar_todos([a,b,a,c], a, [b,c]).
test(eliminar_todos_ninguno) :- mi_eliminar_todos([a,b], x, [a,b]).

% mi_max
test(max_primero) :- mi_max(5, 3, 5).
test(max_segundo) :- mi_max(2, 7, 7).
test(max_iguales) :- mi_max(4, 4, 4).

% mi_tomar
test(tomar_cero) :- mi_tomar(0, [1,2,3], []).
test(tomar_algunos) :- mi_tomar(2, [1,2,3], [1,2]).
test(tomar_mas_que_hay) :- mi_tomar(5, [1,2], [1,2]).

:- end_tests(listas).
