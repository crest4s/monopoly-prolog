% =============================================================================
% loader.pl — Carga todos los modulos del motor Monopoly en orden
% =============================================================================
% Ejecutar desde la raíz del proyecto:
%   ?- consult('src/loader').
% =============================================================================

% --- Utilidades ---
:- consult('utils/listas').
:- consult('utils/prng').
:- consult('utils/impresion').

% --- Tablero ---
:- consult('tablero/casillas').
:- consult('tablero/grupos').
:- consult('tablero/consultas').

% --- Reglas de cárcel (sin dynamic: estado en estructura estado/6) ---
:- consult('reglas/carcel').

% --- Core: jugador (necesario para compra/alquiler) ---
:- consult('core/jugador').

% --- Resto de reglas ---
:- consult('reglas/monopolio').
:- consult('reglas/compra').
:- consult('reglas/alquiler').
:- consult('reglas/bancarrota').
:- consult('reglas/compra_casas').
:- consult('reglas/impuestos').
:- consult('reglas/suerte').
:- consult('reglas/caja_comunidad').
:- consult('reglas/paso_salida').
:- consult('reglas/evaluador').

% --- Core: estado ---
:- consult('core/estado').

% --- Estadísticas ---
:- consult('stats/logger').

% --- Presentación ---
:- consult('ui/presentacion').

% --- Bucle principal ---
:- consult('core/turno').
