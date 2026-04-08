# Arquitectura — Monopoly Clásico Español

## Principios de Diseño

1. **Modularidad máxima**: Cada concepto del juego es un archivo independiente.
2. **Sin módulos Prolog**: Todo en el espacio de nombres global (`user`), carga con `consult/1`.
3. **Listas manuales**: Todas las operaciones de listas implementadas sin predicados nativos.
4. **PRNG determinista**: Linear Congruential Generator para reproducibilidad.
5. **Logger opcional**: Las llamadas a `log_evento/6` son no-ops si no se activa el logging.

## Árbol de Dependencias

```
main.pl
├── src/loader.pl
│   ├── utils/listas.pl          (sin dependencias)
│   ├── utils/prng.pl            (sin dependencias)
│   ├── utils/impresion.pl       (sin dependencias)
│   ├── tablero/casillas.pl      (sin dependencias)
│   ├── tablero/grupos.pl        (sin dependencias)
│   ├── tablero/consultas.pl     → listas
│   ├── reglas/carcel.pl         → listas, consultas, logger
│   ├── core/jugador.pl          → listas
│   ├── reglas/monopolio.pl      → grupos, listas
│   ├── reglas/compra.pl         → listas, consultas, jugador, logger
│   ├── reglas/alquiler.pl       → listas, consultas, monopolio, jugador, logger
│   ├── reglas/bancarrota.pl     → listas, carcel, logger
│   ├── reglas/impuestos.pl      → listas, consultas, logger
│   ├── reglas/suerte.pl         → listas, prng, consultas, carcel, logger
│   ├── reglas/caja_comunidad.pl → listas, prng, consultas, logger
│   ├── reglas/paso_salida.pl    (sin dependencias)
│   ├── reglas/evaluador.pl      → consultas, compra, alquiler, impuestos,
│   │                              carcel, suerte, caja_comunidad
│   ├── core/estado.pl           → casillas, jugador, carcel
│   ├── stats/logger.pl          → listas (opcional)
│   ├── ui/presentacion.pl       → listas, consultas, carcel
│   └── core/turno.pl            → TODOS los anteriores
├── escenarios/loader_escenarios.pl
│   └── escenario_*.pl (14 archivos)
└── src/stats/simulacion.pl      → loader, logger
```

## Estructura del Estado

```prolog
estado(Jugadores, Tablero, Turno, Semilla)
%   Jugadores: [jugador(Nombre, Posicion, Dinero, Propiedades)]
%   Tablero:   [casilla(Indice, Tipo)] — 40 casillas
%   Turno:     0-based, índice del jugador actual
%   Semilla:   valor actual del PRNG
```

## Tipos de Casilla

| Tipo | Estructura |
|------|-----------|
| Salida | `salida` |
| Propiedad | `propiedad(Nombre, Color, Precio, AlquilerBase)` |
| Estación | `estacion(Nombre, Precio)` |
| Servicio | `servicio(Nombre, Precio)` |
| Impuesto | `impuesto(Nombre, Cantidad)` |
| Suerte | `suerte` |
| Caja Comunidad | `caja_comunidad` |
| Cárcel | `carcel` |
| Parking | `parking` |
| Ir a Cárcel | `ir_a_carcel` |

## Reglas Implementadas

### R0: Compra (`reglas/compra.pl`)
- Casilla comprable + sin dueño + dinero suficiente → compra automática.

### R1: Alquiler (`reglas/alquiler.pl`)
- **Propiedad**: AlquilerBase (×2 si monopolio).
- **Estación**: 25€ × número de estaciones del dueño.
- **Servicio**: SumaDados × (4 si 1 servicio, 10 si 2).

### R2: Monopolio (`reglas/monopolio.pl`)
- Un jugador posee TODAS las propiedades de un grupo de color.

### R3: Bancarrota (`reglas/bancarrota.pl`)
- Dinero < 0 → eliminación. Propiedades liberadas.

### Cárcel (`reglas/carcel.pl`)
- Entrada: casilla 30 o carta suerte o 3 dobles consecutivos.
- Salida: dobles (gratis) o pago de 50€ al 3er turno.

### Cartas (`reglas/suerte.pl`, `reglas/caja_comunidad.pl`)
- 6 efectos de Suerte, 5 de Caja de Comunidad.
- Selección por PRNG determinista.

## Sistema de Estadísticas

### Logger Prolog (`src/stats/logger.pl`)
CSV con formato: `evento,turno,jugador,v1,v2,v3,v4`

Eventos registrados:
- `dados` — Tirada de dados (D1, D2, suma, es_doble)
- `movimiento` — Movimiento (pos_anterior, pos_nueva)
- `compra` — Compra (posición, precio, saldo)
- `alquiler` — Pago de alquiler (posición, cantidad, dueño, saldo)
- `impuesto` — Pago de impuesto (posición, cantidad, saldo)
- `suerte` — Carta de suerte (número de carta)
- `caja` — Carta de caja (número de carta)
- `carcel_entrada` — Entrada en cárcel (causa)
- `carcel_salida` — Salida de cárcel (método, saldo)
- `paso_salida` — Paso por Salida (saldo)
- `bancarrota` — Bancarrota (saldo final)
- `saldo` — Snapshot de estado (dinero, posición, propiedades)
- `ganador` — Victoria

### Análisis Python (`stats/`)
- `simulador.py` — Lanza simulaciones vía `swipl`
- `estadisticas.py` — 15+ métricas estadísticas
- `graficas.py` — 14 gráficas PNG (barras, líneas, heatmap, boxplot)

## Tests (`tests/`)
- Framework previsto: `plunit` (built-in de SWI-Prolog)
- Infraestructura de tests por implementar (no hay suites ni `run_tests.pl` aún).
- Cuando exista la batería de tests, se documentará aquí el comando de ejecución.
