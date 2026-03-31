% =============================================================================
% run_tests.pl — Ejecutor de todos los tests
% =============================================================================
% Uso:
%   $ cd monopolio_v2
%   $ swipl tests/run_tests.pl
% =============================================================================

:- consult('../src/loader').
:- use_module(library(plunit)).

:- consult('test_listas').
:- consult('test_prng').
:- consult('test_tablero').
:- consult('test_compra').
:- consult('test_alquiler').
:- consult('test_monopolio').
:- consult('test_bancarrota').
:- consult('test_carcel').
:- consult('test_suerte').
:- consult('test_caja_comunidad').
:- consult('test_impuestos').
:- consult('test_movimiento').
:- consult('test_paso_salida').
:- consult('test_compra_casas').

:- initialization(run_tests, main).
