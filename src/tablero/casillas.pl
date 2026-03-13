% =============================================================================
% casillas.pl — Definición de las 40 casillas del Monopoly Clásico Español
% =============================================================================

tablero([
    % --- Lado Sur (casillas 0–9) ---
    casilla(0,  salida),
    casilla(1,  propiedad('Ronda de Valencia', marron, 60, 2)),
    casilla(2,  caja_comunidad),
    casilla(3,  propiedad('Plaza de Lavapies', marron, 60, 4)),
    casilla(4,  impuesto('Impuesto sobre el Capital', 200)),
    casilla(5,  estacion('Estacion de Goya', 200)),
    casilla(6,  propiedad('Glorieta de Cuatro Caminos', celeste, 100, 6)),
    casilla(7,  suerte),
    casilla(8,  propiedad('Avenida de Recoletos', celeste, 100, 6)),
    casilla(9,  propiedad('Calle de Preciados', celeste, 120, 8)),

    % --- Lado Oeste (casillas 10–19) ---
    casilla(10, carcel),
    casilla(11, propiedad('Glorieta de Bilbao', rosa, 140, 10)),
    casilla(12, servicio('Compania de Electricidad', 150)),
    casilla(13, propiedad('Calle Alberto Aguilera', rosa, 140, 10)),
    casilla(14, propiedad('Calle de Fuencarral', rosa, 160, 12)),
    casilla(15, estacion('Estacion de Atocha', 200)),
    casilla(16, propiedad('Avenida del Mediterraneo', naranja, 180, 14)),
    casilla(17, caja_comunidad),
    casilla(18, propiedad('Avenida de Europa', naranja, 180, 14)),
    casilla(19, propiedad('Calle de Bailen', naranja, 200, 16)),

    % --- Lado Norte (casillas 20–29) ---
    casilla(20, parking),
    casilla(21, propiedad('Puerta del Sol', rojo, 220, 18)),
    casilla(22, suerte),
    casilla(23, propiedad('Calle de Alcala', rojo, 220, 18)),
    casilla(24, propiedad('Gran Via', rojo, 240, 20)),
    casilla(25, estacion('Estacion del Norte', 200)),
    casilla(26, propiedad('Calle de Velazquez', amarillo, 260, 22)),
    casilla(27, propiedad('Calle de Serrano', amarillo, 260, 22)),
    casilla(28, servicio('Compania de Aguas', 150)),
    casilla(29, propiedad('Plaza de Espana', amarillo, 280, 24)),

    % --- Lado Este (casillas 30–39) ---
    casilla(30, ir_a_carcel),
    casilla(31, propiedad('Rambla de Cataluna', verde, 300, 26)),
    casilla(32, propiedad('Avenida del Tibidabo', verde, 300, 26)),
    casilla(33, caja_comunidad),
    casilla(34, propiedad('Paseo de la Castellana', verde, 320, 28)),
    casilla(35, estacion('Estacion de Sants', 200)),
    casilla(36, suerte),
    casilla(37, propiedad('Paseo del Prado', azul, 350, 35)),
    casilla(38, impuesto('Impuesto de Lujo', 100)),
    casilla(39, propiedad('Calle de la Paz', azul, 400, 50))
]).
