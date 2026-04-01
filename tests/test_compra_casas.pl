% =============================================================================
% test_compra_casas.pl — Tests para compra de casas y hoteles
% =============================================================================
:- use_module(library(plunit)).

:- begin_tests(compra_casas).

% Compra de primera casa en monopolio marron
test(compra_primera_casa) :-
    tablero(T),
    % Ana posee ambas propiedades del grupo marron (pos 1 y 3)
    Jugadores = [jugador('Ana', 1, 1500, [1, 3])],
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_compra_casas(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 1, NuevoDinero, [1, 3])], T, 0, 42, [], NuevosEdificios),
    NuevoDinero =:= 1450,        % 1500 - 50 (precio casa marron)
    obtener_edificios_en(1, NuevosEdificios, 1).  % Casa en pos 1

% Sin monopolio no construye
test(sin_monopolio_no_construye) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 1500, [1])],   % Solo una del grupo marron
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_compra_casas(Estado, NuevoEstado),
    NuevoEstado == Estado.

% Sin dinero suficiente no construye
test(sin_dinero_no_construye) :-
    tablero(T),
    Jugadores = [jugador('Ana', 1, 30, [1, 3])],  % Solo 30, precio casa marron = 50
    Estado = estado(Jugadores, T, 0, 42, [], []),
    regla_compra_casas(Estado, NuevoEstado),
    NuevoEstado == Estado.

% La segunda casa se construye en la propiedad menos edificada
test(segunda_casa_balance) :-
    tablero(T),
    % Ana tiene casa en pos 1, debe construir en pos 3 para equilibrar
    Edificios = [edificio(1, 1)],
    Jugadores = [jugador('Ana', 1, 1500, [1, 3])],
    Estado = estado(Jugadores, T, 0, 42, [], Edificios),
    regla_compra_casas(Estado, NuevoEstado),
    NuevoEstado = estado(_, T, 0, 42, [], NuevosEdificios),
    obtener_edificios_en(3, NuevosEdificios, 1).   % Casa nueva en pos 3

% Construccion de hotel (5 edificios)
test(construye_hotel) :-
    tablero(T),
    % Azul: pos 37 y 39; 4 casas en ambas → siguiente es hotel
    Edificios = [edificio(37, 4), edificio(39, 4)],
    Jugadores = [jugador('Ana', 37, 1000, [37, 39])],
    Estado = estado(Jugadores, T, 0, 42, [], Edificios),
    regla_compra_casas(Estado, NuevoEstado),
    NuevoEstado = estado([jugador('Ana', 37, NuevoDinero, _)], T, 0, 42, [], NuevosEdificios),
    NuevoDinero =:= 800,                             % 1000 - 200 (precio azul)
    obtener_edificios_en(37, NuevosEdificios, 5).    % Hotel en pos 37

% Alquiler aumenta con edificios
test(alquiler_con_casas) :-
    tablero(T),
    Edificios = [edificio(1, 2)],   % 2 casas en pos 1
    Jugadores = [jugador('Ana', 1, 1500, []),
                 jugador('Bruno', 5, 1500, [1])],
    Estado = estado(Jugadores, T, 0, 42, [], Edificios),
    regla_alquiler(Estado, 5, NuevoEstado),
    NuevoEstado = estado(NJ, T, 0, 42, [], Edificios),
    mi_obtener_elemento(NJ, 0, jugador('Ana', 1, DineroAna, _)),
    DineroAna =:= 1470.    % 1500 - (2 * 15) = 1500 - 30

:- end_tests(compra_casas).
