"""
simulador.py — Ejecuta simulaciones de Monopoly vía SWI-Prolog y genera CSVs.

Uso:
    python stats/simulador.py [--partidas N] [--turnos T]

Requiere SWI-Prolog (swipl) instalado y accesible en PATH.
"""

import argparse
import os
import subprocess
import sys


def ejecutar_simulacion(num_partidas: int, max_turnos: int, directorio_datos: str) -> bool:
    """Ejecuta el lote de simulaciones en SWI-Prolog."""
    os.makedirs(directorio_datos, exist_ok=True)

    raiz_proyecto = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

    goal = f"simular_lote({num_partidas}, {max_turnos})"
    cmd = ["swipl", "-g", goal, "-t", "halt", "main.pl"]

    print(f"Ejecutando {num_partidas} simulaciones de hasta {max_turnos} turnos...")
    print(f"Directorio de trabajo: {raiz_proyecto}")
    print(f"Comando: {' '.join(cmd)}")

    result = subprocess.run(
        cmd,
        cwd=raiz_proyecto,
        capture_output=True,
        text=True,
        timeout=300
    )

    if result.returncode != 0:
        print(f"Error en SWI-Prolog:\n{result.stderr}", file=sys.stderr)
        return False

    # Contar CSVs generados
    csvs = [f for f in os.listdir(directorio_datos) if f.endswith(".csv")]
    print(f"Simulacion completada. {len(csvs)} archivos CSV generados en {directorio_datos}/")
    return True


def main():
    parser = argparse.ArgumentParser(description="Simulador de Monopoly — Generador de datos CSV")
    parser.add_argument("--partidas", type=int, default=50, help="Numero de partidas a simular")
    parser.add_argument("--turnos", type=int, default=200, help="Turnos maximos por partida")
    args = parser.parse_args()

    directorio_datos = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
    ok = ejecutar_simulacion(args.partidas, args.turnos, directorio_datos)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
