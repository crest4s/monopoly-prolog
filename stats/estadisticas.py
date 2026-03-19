"""
estadisticas.py — Análisis estadístico de las partidas de Monopoly.

Lee los CSVs generados por el simulador Prolog y calcula estadísticas.

Uso:
    python stats/estadisticas.py [--datos DIR]

Las estadísticas se imprimen por consola y se guardan en stats/data/resumen.csv.
"""

import argparse
import os
import sys

import pandas as pd


def cargar_partidas(directorio: str) -> pd.DataFrame:
    """Carga todos los CSV de partidas en un solo DataFrame."""
    archivos = sorted(
        f for f in os.listdir(directorio)
        if f.startswith("partida_") and f.endswith(".csv")
    )
    if not archivos:
        print("No se encontraron archivos de partida en", directorio, file=sys.stderr)
        sys.exit(1)

    frames = []
    for archivo in archivos:
        ruta = os.path.join(directorio, archivo)
        try:
            df = pd.read_csv(ruta)
            # Extraer número de partida del nombre
            num = archivo.replace("partida_", "").replace(".csv", "")
            df["partida"] = int(num)
            frames.append(df)
        except Exception as e:
            print(f"Error leyendo {archivo}: {e}", file=sys.stderr)

    return pd.concat(frames, ignore_index=True)


def visitas_por_casilla(df: pd.DataFrame) -> pd.DataFrame:
    """Cuenta cuántas veces cada jugador visita cada casilla."""
    movimientos = df[df["evento"] == "movimiento"].copy()
    movimientos["v2"] = pd.to_numeric(movimientos["v2"], errors="coerce")
    return (
        movimientos.groupby(["jugador", "v2"])
        .size()
        .reset_index(name="visitas")
        .rename(columns={"v2": "casilla"})
        .sort_values(["jugador", "visitas"], ascending=[True, False])
    )


def casillas_mas_visitadas(df: pd.DataFrame) -> pd.DataFrame:
    """Top 10 casillas más visitadas globalmente."""
    movimientos = df[df["evento"] == "movimiento"].copy()
    movimientos["v2"] = pd.to_numeric(movimientos["v2"], errors="coerce")
    return (
        movimientos.groupby("v2")
        .size()
        .reset_index(name="visitas")
        .rename(columns={"v2": "casilla"})
        .sort_values("visitas", ascending=False)
        .head(10)
    )


def vueltas_por_jugador(df: pd.DataFrame) -> pd.DataFrame:
    """Cuenta cuántas veces cada jugador pasó por Salida."""
    pasos = df[df["evento"] == "paso_salida"]
    return (
        pasos.groupby(["partida", "jugador"])
        .size()
        .reset_index(name="vueltas")
    )


def evolucion_saldo(df: pd.DataFrame) -> pd.DataFrame:
    """Evolución del saldo de cada jugador por turno."""
    saldos = df[df["evento"] == "saldo"].copy()
    saldos["v1"] = pd.to_numeric(saldos["v1"], errors="coerce")
    return saldos[["partida", "turno", "jugador", "v1"]].rename(columns={"v1": "dinero"})


def compras_por_jugador(df: pd.DataFrame) -> pd.DataFrame:
    """Total de compras realizadas por cada jugador."""
    compras = df[df["evento"] == "compra"]
    return (
        compras.groupby(["partida", "jugador"])
        .size()
        .reset_index(name="num_compras")
    )


def alquileres_pagados(df: pd.DataFrame) -> pd.DataFrame:
    """Total de alquiler pagado por cada jugador."""
    alq = df[df["evento"] == "alquiler"].copy()
    alq["v2"] = pd.to_numeric(alq["v2"], errors="coerce")
    return (
        alq.groupby(["partida", "jugador"])["v2"]
        .sum()
        .reset_index(name="total_alquiler_pagado")
    )


def alquileres_cobrados(df: pd.DataFrame) -> pd.DataFrame:
    """Total de alquiler cobrado por cada jugador (como dueño)."""
    alq = df[df["evento"] == "alquiler"].copy()
    alq["v2"] = pd.to_numeric(alq["v2"], errors="coerce")
    return (
        alq.groupby(["partida", "v3"])["v2"]
        .sum()
        .reset_index(name="total_alquiler_cobrado")
        .rename(columns={"v3": "jugador"})
    )


def entradas_carcel(df: pd.DataFrame) -> pd.DataFrame:
    """Número de veces que cada jugador entra en cárcel."""
    ent = df[df["evento"] == "carcel_entrada"]
    return (
        ent.groupby(["partida", "jugador"])
        .size()
        .reset_index(name="entradas_carcel")
    )


def turnos_eliminacion(df: pd.DataFrame) -> pd.DataFrame:
    """Turno en que cada jugador quiebra."""
    bancarrotas = df[df["evento"] == "bancarrota"]
    return bancarrotas[["partida", "turno", "jugador"]].rename(
        columns={"turno": "turno_eliminacion"}
    )


def distribucion_dados(df: pd.DataFrame) -> pd.DataFrame:
    """Distribución de la suma de dados."""
    dados = df[df["evento"] == "dados"].copy()
    dados["v3"] = pd.to_numeric(dados["v3"], errors="coerce")
    return (
        dados.groupby("v3")
        .size()
        .reset_index(name="frecuencia")
        .rename(columns={"v3": "suma_dados"})
    )


def frecuencia_dobles(df: pd.DataFrame) -> dict:
    """Porcentaje de tiradas que son dobles."""
    dados = df[df["evento"] == "dados"]
    total = len(dados)
    dobles = len(dados[dados["v4"] == "true"])
    return {
        "total_tiradas": total,
        "dobles": dobles,
        "porcentaje_dobles": round(dobles / total * 100, 2) if total > 0 else 0,
    }


def ganadores(df: pd.DataFrame) -> pd.DataFrame:
    """Frecuencia de victorias por jugador."""
    gan = df[df["evento"] == "ganador"]
    return (
        gan.groupby("jugador")
        .size()
        .reset_index(name="victorias")
        .sort_values("victorias", ascending=False)
    )


def duracion_partidas(df: pd.DataFrame) -> pd.DataFrame:
    """Turno máximo alcanzado en cada partida."""
    return (
        df.groupby("partida")["turno"]
        .max()
        .reset_index(name="duracion_turnos")
    )


def efectos_suerte(df: pd.DataFrame) -> pd.DataFrame:
    """Frecuencia de cada carta de suerte."""
    suertes = df[df["evento"] == "suerte"].copy()
    suertes["v1"] = pd.to_numeric(suertes["v1"], errors="coerce")
    return (
        suertes.groupby("v1")
        .size()
        .reset_index(name="frecuencia")
        .rename(columns={"v1": "carta"})
    )


def efectos_caja(df: pd.DataFrame) -> pd.DataFrame:
    """Frecuencia de cada carta de caja de comunidad."""
    cajas = df[df["evento"] == "caja"].copy()
    cajas["v1"] = pd.to_numeric(cajas["v1"], errors="coerce")
    return (
        cajas.groupby("v1")
        .size()
        .reset_index(name="frecuencia")
        .rename(columns={"v1": "carta"})
    )


def impuestos_totales(df: pd.DataFrame) -> pd.DataFrame:
    """Total impuestos pagados por jugador."""
    imp = df[df["evento"] == "impuesto"].copy()
    imp["v2"] = pd.to_numeric(imp["v2"], errors="coerce")
    return (
        imp.groupby(["partida", "jugador"])["v2"]
        .sum()
        .reset_index(name="total_impuestos")
    )


def propiedades_mas_rentables(df: pd.DataFrame) -> pd.DataFrame:
    """Casillas que generan más alquiler total."""
    alq = df[df["evento"] == "alquiler"].copy()
    alq["v1"] = pd.to_numeric(alq["v1"], errors="coerce")
    alq["v2"] = pd.to_numeric(alq["v2"], errors="coerce")
    return (
        alq.groupby("v1")["v2"]
        .sum()
        .reset_index(name="alquiler_total")
        .rename(columns={"v1": "casilla"})
        .sort_values("alquiler_total", ascending=False)
        .head(15)
    )


def main():
    parser = argparse.ArgumentParser(description="Estadísticas de Monopoly")
    parser.add_argument(
        "--datos",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "data"),
        help="Directorio con los CSV",
    )
    args = parser.parse_args()

    print("=" * 60)
    print("  ESTADISTICAS DEL MONOPOLY CLASICO ESPANOL")
    print("=" * 60)

    df = cargar_partidas(args.datos)
    num_partidas = df["partida"].nunique()
    print(f"\nPartidas analizadas: {num_partidas}")
    print(f"Total eventos registrados: {len(df)}")

    print("\n--- TOP 10 CASILLAS MAS VISITADAS ---")
    print(casillas_mas_visitadas(df).to_string(index=False))

    print("\n--- DISTRIBUCION DE DADOS ---")
    print(distribucion_dados(df).to_string(index=False))

    print("\n--- FRECUENCIA DE DOBLES ---")
    freq = frecuencia_dobles(df)
    print(f"  Total tiradas: {freq['total_tiradas']}")
    print(f"  Dobles: {freq['dobles']} ({freq['porcentaje_dobles']}%)")

    print("\n--- GANADORES ---")
    gan = ganadores(df)
    if len(gan) > 0:
        print(gan.to_string(index=False))
    else:
        print("  (ninguna partida terminó con ganador)")

    print("\n--- DURACION DE PARTIDAS (turnos) ---")
    dur = duracion_partidas(df)
    print(f"  Media: {dur['duracion_turnos'].mean():.1f}")
    print(f"  Min: {dur['duracion_turnos'].min()}")
    print(f"  Max: {dur['duracion_turnos'].max()}")

    print("\n--- COMPRAS PROMEDIO POR JUGADOR ---")
    comp = compras_por_jugador(df)
    if len(comp) > 0:
        prom = comp.groupby("jugador")["num_compras"].mean().reset_index()
        print(prom.to_string(index=False))

    print("\n--- ALQUILER PROMEDIO PAGADO POR JUGADOR ---")
    alq = alquileres_pagados(df)
    if len(alq) > 0:
        prom_alq = alq.groupby("jugador")["total_alquiler_pagado"].mean().reset_index()
        print(prom_alq.to_string(index=False))

    print("\n--- ENTRADAS EN CARCEL POR JUGADOR ---")
    ent = entradas_carcel(df)
    if len(ent) > 0:
        prom_ent = ent.groupby("jugador")["entradas_carcel"].mean().reset_index()
        print(prom_ent.to_string(index=False))

    print("\n--- TURNOS DE ELIMINACION (BANCARROTA) ---")
    eli = turnos_eliminacion(df)
    if len(eli) > 0:
        prom_eli = eli.groupby("jugador")["turno_eliminacion"].mean().reset_index()
        prom_eli.columns = ["jugador", "turno_medio_eliminacion"]
        print(prom_eli.to_string(index=False))

    print("\n--- PROPIEDADES MAS RENTABLES ---")
    rent = propiedades_mas_rentables(df)
    if len(rent) > 0:
        print(rent.to_string(index=False))

    print("\n--- EFECTOS DE CARTAS DE SUERTE ---")
    print(efectos_suerte(df).to_string(index=False))

    print("\n--- EFECTOS DE CARTAS DE CAJA ---")
    print(efectos_caja(df).to_string(index=False))

    # Guardar resumen
    resumen_path = os.path.join(args.datos, "resumen_estadisticas.csv")
    resumen = {
        "metrica": [
            "partidas",
            "eventos_totales",
            "media_duracion",
            "porcentaje_dobles",
        ],
        "valor": [
            num_partidas,
            len(df),
            round(dur["duracion_turnos"].mean(), 1),
            freq["porcentaje_dobles"],
        ],
    }
    pd.DataFrame(resumen).to_csv(resumen_path, index=False)
    print(f"\nResumen guardado en {resumen_path}")


if __name__ == "__main__":
    main()
