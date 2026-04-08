"""Stats: Generación de gráficas estadísticas del Monopoly."""

import argparse
import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# Importar funciones de análisis
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from estadisticas import (
    cargar_partidas,
    casillas_mas_visitadas,
    distribucion_dados,
    duracion_partidas,
    evolucion_saldo,
    frecuencia_dobles,
    ganadores,
    entradas_carcel,
    compras_por_jugador,
    alquileres_pagados,
    alquileres_cobrados,
    turnos_eliminacion,
    efectos_suerte,
    efectos_caja,
    propiedades_mas_rentables,
    visitas_por_casilla,
    impuestos_totales,
    vueltas_por_jugador,
)

NOMBRES_CASILLAS = {
    0: "Salida", 1: "Ronda Valencia", 2: "Caja", 3: "Lavapies",
    4: "Imp. Capital", 5: "Est. Goya", 6: "Cuatro Caminos",
    7: "Suerte", 8: "Recoletos", 9: "Preciados", 10: "Carcel",
    11: "Bilbao", 12: "Electricidad", 13: "Alberto Aguilera",
    14: "Fuencarral", 15: "Est. Atocha", 16: "Mediterraneo",
    17: "Caja", 18: "Europa", 19: "Bailen", 20: "Parking",
    21: "Puerta Sol", 22: "Suerte", 23: "Alcala", 24: "Gran Via",
    25: "Est. Norte", 26: "Velazquez", 27: "Serrano",
    28: "Aguas", 29: "Pza. Espana", 30: "Ir Carcel",
    31: "Rambla Cat.", 32: "Tibidabo", 33: "Caja",
    34: "Castellana", 35: "Est. Sants", 36: "Suerte",
    37: "Paseo Prado", 38: "Imp. Lujo", 39: "Calle Paz",
}

sns.set_theme(style="whitegrid", palette="muted")


def grafica_casillas_visitadas(df: pd.DataFrame, salida: str):
    """Gráfica de barras: casillas más visitadas."""
    datos = casillas_mas_visitadas(df)
    datos["nombre"] = datos["casilla"].map(NOMBRES_CASILLAS).fillna(datos["casilla"].astype(str))

    fig, ax = plt.subplots(figsize=(12, 6))
    sns.barplot(data=datos, x="nombre", y="visitas", ax=ax, hue="nombre", legend=False)
    ax.set_title("Top 10 Casillas Más Visitadas", fontsize=14)
    ax.set_xlabel("Casilla")
    ax.set_ylabel("Visitas Totales")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "casillas_visitadas.png"), dpi=150)
    plt.close(fig)


def grafica_distribucion_dados(df: pd.DataFrame, salida: str):
    """Histograma: distribución de sumas de dados."""
    datos = distribucion_dados(df)

    fig, ax = plt.subplots(figsize=(10, 6))
    sns.barplot(data=datos, x="suma_dados", y="frecuencia", ax=ax, color="steelblue")
    ax.set_title("Distribución de Suma de Dados", fontsize=14)
    ax.set_xlabel("Suma de Dados")
    ax.set_ylabel("Frecuencia")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "distribucion_dados.png"), dpi=150)
    plt.close(fig)


def grafica_ganadores(df: pd.DataFrame, salida: str):
    """Gráfica de barras: frecuencia de victorias."""
    datos = ganadores(df)
    if datos.empty:
        return

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=datos, x="jugador", y="victorias", ax=ax, hue="jugador", legend=False)
    ax.set_title("Victorias por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Victorias")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "ganadores.png"), dpi=150)
    plt.close(fig)


def grafica_duracion_partidas(df: pd.DataFrame, salida: str):
    """Histograma: duración de partidas en turnos."""
    datos = duracion_partidas(df)

    fig, ax = plt.subplots(figsize=(10, 6))
    ax.hist(datos["duracion_turnos"], bins=20, color="coral", edgecolor="white")
    ax.set_title("Duración de Partidas", fontsize=14)
    ax.set_xlabel("Turnos")
    ax.set_ylabel("Número de Partidas")
    ax.axvline(datos["duracion_turnos"].mean(), color="red", linestyle="--",
               label=f"Media: {datos['duracion_turnos'].mean():.0f}")
    ax.legend()
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "duracion_partidas.png"), dpi=150)
    plt.close(fig)


def grafica_evolucion_saldo(df: pd.DataFrame, salida: str):
    """Líneas: evolución de saldo por jugador (muestra de 1 partida)."""
    datos = evolucion_saldo(df)
    if datos.empty:
        return

    primera_partida = datos["partida"].min()
    datos_p = datos[datos["partida"] == primera_partida]

    fig, ax = plt.subplots(figsize=(12, 6))
    for jugador in datos_p["jugador"].unique():
        d = datos_p[datos_p["jugador"] == jugador]
        ax.plot(d["turno"], d["dinero"], marker=".", label=jugador, linewidth=1.5)

    ax.set_title(f"Evolución de Saldo (Partida {primera_partida})", fontsize=14)
    ax.set_xlabel("Turno")
    ax.set_ylabel("Dinero (€)")
    ax.legend()
    ax.axhline(0, color="red", linestyle=":", alpha=0.5)
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "evolucion_saldo.png"), dpi=150)
    plt.close(fig)


def grafica_entradas_carcel(df: pd.DataFrame, salida: str):
    """Barras: promedio de entradas en cárcel por jugador."""
    datos = entradas_carcel(df)
    if datos.empty:
        return

    prom = datos.groupby("jugador")["entradas_carcel"].mean().reset_index()

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=prom, x="jugador", y="entradas_carcel", ax=ax, hue="jugador", legend=False)
    ax.set_title("Promedio de Entradas en Cárcel por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Entradas Promedio")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "entradas_carcel.png"), dpi=150)
    plt.close(fig)


def grafica_alquiler_balance(df: pd.DataFrame, salida: str):
    """Barras agrupadas: alquiler pagado vs cobrado por jugador."""
    pagado = alquileres_pagados(df)
    cobrado = alquileres_cobrados(df)

    if pagado.empty and cobrado.empty:
        return

    pag_prom = pagado.groupby("jugador")["total_alquiler_pagado"].mean().reset_index()
    cob_prom = cobrado.groupby("jugador")["total_alquiler_cobrado"].mean().reset_index()

    merged = pd.merge(pag_prom, cob_prom, on="jugador", how="outer").fillna(0)

    fig, ax = plt.subplots(figsize=(10, 6))
    x = range(len(merged))
    width = 0.35
    ax.bar([i - width / 2 for i in x], merged["total_alquiler_pagado"],
           width, label="Pagado", color="salmon")
    ax.bar([i + width / 2 for i in x], merged["total_alquiler_cobrado"],
           width, label="Cobrado", color="mediumseagreen")
    ax.set_xticks(list(x))
    ax.set_xticklabels(merged["jugador"])
    ax.set_title("Balance de Alquiler Promedio por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Dinero (€)")
    ax.legend()
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "alquiler_balance.png"), dpi=150)
    plt.close(fig)


def grafica_efectos_suerte(df: pd.DataFrame, salida: str):
    """Barras: frecuencia de cada carta de suerte."""
    datos = efectos_suerte(df)
    if datos.empty:
        return

    nombres = {1: "+100€", 2: "-50€", 3: "Ir Salida", 4: "+50€", 5: "Avanza 3", 6: "Cárcel"}
    datos["efecto"] = datos["carta"].map(nombres).fillna("?")

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=datos, x="efecto", y="frecuencia", ax=ax, hue="efecto", legend=False)
    ax.set_title("Frecuencia de Cartas de Suerte", fontsize=14)
    ax.set_xlabel("Efecto")
    ax.set_ylabel("Frecuencia")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "efectos_suerte.png"), dpi=150)
    plt.close(fig)


def grafica_efectos_caja(df: pd.DataFrame, salida: str):
    """Barras: frecuencia de cada carta de caja."""
    datos = efectos_caja(df)
    if datos.empty:
        return

    nombres = {1: "+200€", 2: "-100€", 3: "Ir Salida", 4: "+100€", 5: "-50€"}
    datos["efecto"] = datos["carta"].map(nombres).fillna("?")

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=datos, x="efecto", y="frecuencia", ax=ax, hue="efecto", legend=False)
    ax.set_title("Frecuencia de Cartas de Caja de Comunidad", fontsize=14)
    ax.set_xlabel("Efecto")
    ax.set_ylabel("Frecuencia")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "efectos_caja.png"), dpi=150)
    plt.close(fig)


def grafica_propiedades_rentables(df: pd.DataFrame, salida: str):
    """Barras: propiedades que generan más alquiler."""
    datos = propiedades_mas_rentables(df)
    if datos.empty:
        return

    datos["nombre"] = datos["casilla"].map(NOMBRES_CASILLAS).fillna(datos["casilla"].astype(str))

    fig, ax = plt.subplots(figsize=(12, 6))
    sns.barplot(data=datos, x="nombre", y="alquiler_total", ax=ax, hue="nombre", legend=False)
    ax.set_title("Propiedades Más Rentables (Total Alquiler Generado)", fontsize=14)
    ax.set_xlabel("Propiedad")
    ax.set_ylabel("Alquiler Total (€)")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "propiedades_rentables.png"), dpi=150)
    plt.close(fig)


def grafica_heatmap_casillas(df: pd.DataFrame, salida: str):
    """Heatmap: visitas por casilla y jugador."""
    datos = visitas_por_casilla(df)
    if datos.empty:
        return

    pivot = datos.pivot_table(index="jugador", columns="casilla", values="visitas", fill_value=0)

    fig, ax = plt.subplots(figsize=(20, 5))
    sns.heatmap(pivot, cmap="YlOrRd", ax=ax, linewidths=0.5)
    ax.set_title("Mapa de Calor: Visitas por Casilla y Jugador", fontsize=14)
    ax.set_xlabel("Casilla")
    ax.set_ylabel("Jugador")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "heatmap_casillas.png"), dpi=150)
    plt.close(fig)


def grafica_turnos_eliminacion(df: pd.DataFrame, salida: str):
    """Boxplot: turno de eliminación por jugador."""
    datos = turnos_eliminacion(df)
    if datos.empty:
        return

    fig, ax = plt.subplots(figsize=(10, 6))
    sns.boxplot(data=datos, x="jugador", y="turno_eliminacion", ax=ax)
    ax.set_title("Turno de Eliminación (Bancarrota) por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Turno")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "turnos_eliminacion.png"), dpi=150)
    plt.close(fig)


def grafica_vueltas(df: pd.DataFrame, salida: str):
    """Barras: promedio de vueltas completadas por jugador."""
    datos = vueltas_por_jugador(df)
    if datos.empty:
        return

    prom = datos.groupby("jugador")["vueltas"].mean().reset_index()

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=prom, x="jugador", y="vueltas", ax=ax, hue="jugador", legend=False)
    ax.set_title("Vueltas al Tablero Promedio por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Vueltas (pasos por Salida)")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "vueltas_jugador.png"), dpi=150)
    plt.close(fig)


def grafica_impuestos(df: pd.DataFrame, salida: str):
    """Barras: impuestos totales promedio pagados por jugador."""
    datos = impuestos_totales(df)
    if datos.empty:
        return

    prom = datos.groupby("jugador")["total_impuestos"].mean().reset_index()

    fig, ax = plt.subplots(figsize=(8, 6))
    sns.barplot(data=prom, x="jugador", y="total_impuestos", ax=ax, hue="jugador", legend=False)
    ax.set_title("Impuestos Promedio Pagados por Jugador", fontsize=14)
    ax.set_xlabel("Jugador")
    ax.set_ylabel("Impuestos (€)")
    plt.tight_layout()
    fig.savefig(os.path.join(salida, "impuestos_jugador.png"), dpi=150)
    plt.close(fig)


def main():
    parser = argparse.ArgumentParser(description="Gráficas estadísticas del Monopoly")
    parser.add_argument(
        "--datos",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "data"),
        help="Directorio con los CSV",
    )
    parser.add_argument(
        "--salida",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "graficas"),
        help="Directorio de salida para las gráficas",
    )
    args = parser.parse_args()

    os.makedirs(args.salida, exist_ok=True)

    print("Cargando datos...")
    df = cargar_partidas(args.datos)
    print(f"Datos cargados: {len(df)} eventos de {df['partida'].nunique()} partidas")

    print("Generando gráficas...")
    grafica_casillas_visitadas(df, args.salida)
    print("  - casillas_visitadas.png")

    grafica_distribucion_dados(df, args.salida)
    print("  - distribucion_dados.png")

    grafica_ganadores(df, args.salida)
    print("  - ganadores.png")

    grafica_duracion_partidas(df, args.salida)
    print("  - duracion_partidas.png")

    grafica_evolucion_saldo(df, args.salida)
    print("  - evolucion_saldo.png")

    grafica_entradas_carcel(df, args.salida)
    print("  - entradas_carcel.png")

    grafica_alquiler_balance(df, args.salida)
    print("  - alquiler_balance.png")

    grafica_efectos_suerte(df, args.salida)
    print("  - efectos_suerte.png")

    grafica_efectos_caja(df, args.salida)
    print("  - efectos_caja.png")

    grafica_propiedades_rentables(df, args.salida)
    print("  - propiedades_rentables.png")

    grafica_heatmap_casillas(df, args.salida)
    print("  - heatmap_casillas.png")

    grafica_turnos_eliminacion(df, args.salida)
    print("  - turnos_eliminacion.png")

    grafica_vueltas(df, args.salida)
    print("  - vueltas_jugador.png")

    grafica_impuestos(df, args.salida)
    print("  - impuestos_jugador.png")

    print(f"\nTodas las gráficas guardadas en {args.salida}/")


if __name__ == "__main__":
    main()
