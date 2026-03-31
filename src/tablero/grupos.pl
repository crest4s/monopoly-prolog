% =============================================================================
% grupos.pl — Agrupaciones de color, estaciones y servicios
% =============================================================================

grupo_color(marron,   [1, 3]).
grupo_color(celeste,  [6, 8, 9]).
grupo_color(rosa,     [11, 13, 14]).
grupo_color(naranja,  [16, 18, 19]).
grupo_color(rojo,     [21, 23, 24]).
grupo_color(amarillo, [26, 27, 29]).
grupo_color(verde,    [31, 32, 34]).
grupo_color(azul,     [37, 39]).

posiciones_estaciones([5, 15, 25, 35]).
posiciones_servicios([12, 28]).

% Precio por cada casa/hotel según el color del grupo
precio_casas(marron,   50).
precio_casas(celeste,  50).
precio_casas(rosa,    100).
precio_casas(naranja, 100).
precio_casas(rojo,    150).
precio_casas(amarillo,150).
precio_casas(verde,   200).
precio_casas(azul,    200).
