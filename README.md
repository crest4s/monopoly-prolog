# Monopoly Clásico Español — Motor Lógico en Prolog

Motor de simulación del Monopoly clásico español implementado en SWI-Prolog,
con sistema de estadísticas en Python.

Práctica en grupo de la Universidad de Alcalá (UAH), curso 2025-26.

## Requisitos

- **SWI-Prolog** >= 9.0 (`swipl`)
- **Python** >= 3.10 (para estadísticas)
- Dependencias Python: `pip install -r stats/requirements.txt`

## Estructura del Proyecto

```
monopolio_prolog/
├── main.pl                      # Punto de entrada con menú
├── src/                         # Código fuente modular
│   ├── loader.pl                # Carga de dependencias
│   ├── utils/                   # Utilidades (listas, PRNG, impresión)
│   ├── tablero/                 # Definición del tablero
│   ├── reglas/                  # Reglas del juego (10 módulos)
│   ├── core/                    # Motor principal
│   ├── ui/                      # Presentación por consola
│   └── stats/                   # Logger CSV y simulación
├── escenarios/                  # 14 escenarios de prueba
├── tests/                       # Tests automáticos (plunit)
├── stats/                       # Análisis Python
│   ├── simulador.py             # Lanzador de simulaciones
│   ├── estadisticas.py          # Cálculo de estadísticas
│   ├── graficas.py              # Generación de gráficas
│   └── data/                    # CSVs y gráficas generadas
└── docs/                        # Documentación
```

## Uso Rápido

### Jugar escenarios

```bash
swipl main.pl
?- main.
```

### Ejecutar tests automáticos

```bash
swipl tests/run_tests.pl
```

### Generar estadísticas

```bash
# 1. Simular partidas (genera CSVs)
swipl -g "simular_lote(50, 200)" -t halt main.pl

# 2. Analizar estadísticas
python stats/estadisticas.py

# 3. Generar gráficas
python stats/graficas.py
```

O todo desde Python:

```bash
python stats/simulador.py --partidas 50 --turnos 200
python stats/estadisticas.py
python stats/graficas.py
```

## Escenarios Disponibles

| # | Escenario | Descripción |
|---|-----------|-------------|
| 1 | Compras iniciales | 3 jugadores, primeras compras |
| 2 | Monopolio formado | Alquiler doble por monopolio |
| 3 | Bancarrota | Jugador con 10€ entre propiedades caras |
| 4 | Alquileres múltiples | Propiedades repartidas, muchos cobros |
| 5 | Simulación completa | 4 jugadores, 10 turnos |
| 6 | Cárcel | Mecánicas completas de encarcelamiento |
| 7 | Suerte | Diferentes cartas de Suerte |
| 8 | Caja de Comunidad | Diferentes cartas de Caja |
| 9 | Dobles | Dobles consecutivos y triple doble |
| 10 | Estaciones | Alquiler progresivo (25€ × num. estaciones) |
| 11 | Servicios | Alquiler por dados (×4 o ×10) |
| 12 | Paso por Salida | Cobro de 200€ al dar la vuelta |
| 13 | Impuestos | Casillas de impuesto (200€ y 100€) |
| 14 | Partida larga | 4 jugadores, hasta 200 turnos |

## Estadísticas Generadas

- Casillas más visitadas (heatmap)
- Distribución de sumas de dados
- Frecuencia de dobles
- Evolución de saldo por turno
- Balance alquiler pagado/cobrado
- Entradas en cárcel por jugador
- Turno de eliminación (bancarrota)
- Duración de partidas
- Propiedades más rentables
- Efectos de cartas (Suerte / Caja)
- Vueltas al tablero por jugador
- Impuestos pagados por jugador
- Frecuencia de victorias

## Tests

Batería de tests unitarios con `plunit` en `tests/` (un fichero por módulo: listas, generador pseudoaleatorio, tablero, compra, compra de casas, alquiler, monopolio, bancarrota, cárcel, Suerte, Caja de Comunidad, impuestos, movimiento y paso por Salida). Se ejecutan con:

```bash
swipl tests/run_tests.pl
```

El workflow `.github/workflows/ci-prolog.yml` los lanza en cada push.

## Autores

- Adrián Morales Rodríguez ([@crest4s](https://github.com/crest4s))
- [@aliciasiguenza](https://github.com/aliciasiguenza)
- [@avuren13](https://github.com/avuren13)

## Licencia

[MIT](LICENSE)
